<script lang='ts'>
    import { onMount, onDestroy } from 'svelte'
    import { mat4 } from "gl-matrix"
    import * as webgpuHelpers from '$lib/webgpuHelpers'

    import triangle_shader from './shader.wgsl?raw'
    import { dev } from '$app/environment';

    let canvas: HTMLCanvasElement
    let width: number, height: number
    let resizedFinished = setTimeout(()=>{})
    let frameCount = 1

    onMount(async () => {
        const adapter: GPUAdapter = await navigator.gpu.requestAdapter() as GPUAdapter
        const device: GPUDevice = await adapter.requestDevice() as GPUDevice
        if (!device) {
            const msg = 'need a browser that supports WebGPU'
            alert(msg); throw new Error(msg);
        }

        const context: GPUCanvasContext = canvas.getContext('webgpu') as GPUCanvasContext

        const format: GPUTextureFormat = navigator.gpu.getPreferredCanvasFormat() // Macos M3: 'bgra8unorm'
        context.configure({
            device,
            format,
			alphaMode: 'opaque'
        })

        const vertices = new Float32Array([
            -1.0, -1.0, 0.0,
            1.0, -1.0, 0.0,
            -1.0, 1.0, 0.0,

            1.0, -1.0, 0.0,
            1.0, 1.0, 0.0,
            -1.0, 1.0, 0.0,
        ])
        const mesh = new webgpuHelpers.Mesh(device, vertices) // only xyzrgb
        const pipeline = webgpuHelpers.makePipeline(device, triangle_shader, triangle_shader, [mesh.bufferLayout], "triangle-list")

        // Uniform buffer
        const uniformBufferSize = 2 * 4 + 4; // 2 vec2 of 4 bytes
        const uniformBuffer: GPUBuffer = device.createBuffer({
            size: uniformBufferSize,
            usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
        });
        const uniformValues = new Float32Array(uniformBufferSize / 4);

        const pixelBuffer = device.createBuffer({
            label: 'PixelBuffer',
            size: canvas.width * canvas.height * 4 * 4,
            usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_SRC | GPUBufferUsage.COPY_DST,
        })

        // const zeroArray = new Float32Array(canvas.width * canvas.height * 4).fill(0);
        // device.queue.writeBuffer(pixelBuffer, 0, zeroArray);

        // const bufferTexture2Dping: GPUTexture = device.createTexture({
        //     size: [canvas.width, canvas.height],
        //     usage: GPUTextureUsage.RENDER_ATTACHMENT | GPUTextureUsage.TEXTURE_BINDING | GPUTextureUsage.STORAGE_BINDING | GPUTextureUsage.COPY_DST | GPUTextureUsage.COPY_SRC,
        //     format: 'rgba32float',
        // });
        // const bufferTexture2Dpong: GPUTexture = device.createTexture({
        //     size: [canvas.width, canvas.height],
        //     usage: GPUTextureUsage.RENDER_ATTACHMENT | GPUTextureUsage.TEXTURE_BINDING,
        //     format: format,//'rgba32float',
        // });

        // const viewBufferTexture2Dping: GPUTextureView = bufferTexture2Dping.createView()
        // const viewBufferTexture2Dpong: GPUTextureView = bufferTexture2Dpong.createView()


        // --

        function frame() {
            const commandEncoder: GPUCommandEncoder = device.createCommandEncoder()
            const textureView: GPUTextureView = context.getCurrentTexture().createView()

            // commandEncoder.clearBuffer(pixelBuffer, 0, pixelBuffer.size)

            const renderPassDescriptor: GPURenderPassDescriptor = {
                colorAttachments: [
                {
                    view: textureView,
                    clearValue: [0.0, 0.0, 0.0, 1.0],
                    loadOp: 'clear',
                    storeOp: 'store',
                },
                ],
            }

            const bindGroup: GPUBindGroup = device.createBindGroup({
                label: 'MyBindGroup',
                layout: pipeline.getBindGroupLayout(0),
                entries: [
                    { binding: 0, resource: { buffer: uniformBuffer }},
                    { binding: 1, resource: { buffer: pixelBuffer } },
                ],
            });

            uniformValues.set([canvas.width, canvas.height, frameCount], 0);
            device.queue.writeBuffer(uniformBuffer, 0, uniformValues); // copy the values from JavaScript to the GPU

            const renderPass: GPURenderPassEncoder = commandEncoder.beginRenderPass(renderPassDescriptor)
            renderPass.setPipeline(pipeline)
            renderPass.setBindGroup(0, bindGroup)
            renderPass.setVertexBuffer(0, mesh.buffer)
            renderPass.draw(3*2) // call vertex shader 3 times
            renderPass.end()

            // commandEncoder.copyTextureToTexture({texture: bufferTexture2Dping}, {texture: currentTexture}, {width:canvas.width, height:canvas.height, depthOrArrayLayers:1})

            device.queue.submit([commandEncoder.finish()])

            // setTimeout(() => {
            //     requestAnimationFrame(frame);
            // }, 1000 / 5);
            requestAnimationFrame(frame)
            frameCount += 1
            console.log(frameCount)
        }

        function resize() {
            const devicePixelRatio = window.devicePixelRatio
            canvas.width = canvas.clientWidth * devicePixelRatio
            canvas.height = canvas.clientHeight * devicePixelRatio

            // requestAnimationFrame(frame)
        }

        resize()
        // window.addEventListener('resize', resize)

        // To prevent resize() when still resizing window
        window.addEventListener('resize', () => {
            clearTimeout(resizedFinished);
            resizedFinished = setTimeout(() => {
                resize();
                console.log('Resized finished.');
            }, 100);
        })

        requestAnimationFrame(frame)
    })
</script>

<svelte:head>
    <title>Raytracer</title>
    <meta name="description" content="WebGPU Raytracer" />
</svelte:head>

<canvas
    class="w-screen h-screen"
    bind:this={canvas}
    bind:clientWidth={width}
    bind:clientHeight={height}
    {width} {height}
/>
