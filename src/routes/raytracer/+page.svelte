<script lang='ts'>
    import { onMount, onDestroy } from 'svelte'
    import { mat4 } from "gl-matrix"
    import * as rf from '$lib/raf-webgpu/'

    import triangle_shader from './shader.wgsl?raw'

    let canvas: HTMLCanvasElement
    let width: number, height: number;
    let resizedFinished = setTimeout(()=>{});

    onMount(async () => {
        const adapter: GPUAdapter = await navigator.gpu.requestAdapter() as GPUAdapter
        const device: GPUDevice = await adapter.requestDevice() as GPUDevice
        if (!device) {
            const msg = 'need a browser that supports WebGPU'
            alert(msg); throw new Error(msg);
        }

        const context: GPUCanvasContext = canvas.getContext('webgpu') as GPUCanvasContext

        const format: GPUTextureFormat = navigator.gpu.getPreferredCanvasFormat()
        context.configure({
            device,
            format,
			alphaMode: 'opaque'
        })

        const vertices: Float32Array = new Float32Array(
            [
                -1.0, -1.0, 0.0,
                1.0, -1.0, 0.0,
                -1.0, 1.0, 0.0,

                1.0, -1.0, 0.0,
                1.0, 1.0, 0.0,
                -1.0, 1.0, 0.0,
            ]
        )
        const mesh = new rf.Mesh(device, vertices) // only xyzrgb
        const pipeline = rf.makePipeline(device, triangle_shader, triangle_shader, [mesh.bufferLayout], "triangle-list")

        // Uniform buffer
        const uniformBufferSize = 2 * 4; // 2 vec2 of 4 bytes
        const uniformBuffer = device.createBuffer({
            size: uniformBufferSize,
            usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
        });
        const uniformValues = new Float32Array(uniformBufferSize / 4);

        const bindGroup = device.createBindGroup({
            layout: pipeline.getBindGroupLayout(0),
            entries: [
                { binding: 0, resource: { buffer: uniformBuffer }},
            ],
        });
        // --

        function frame() {
            const commandEncoder: GPUCommandEncoder = device.createCommandEncoder()
            const textureView: GPUTextureView = context.getCurrentTexture().createView()

            const renderPassDescriptor: GPURenderPassDescriptor = {
                colorAttachments: [
                {
                    view: textureView,
                    clearValue: [0, 0, 0, 1],
                    loadOp: 'clear',
                    storeOp: 'store',
                },
                ],
            }

            uniformValues.set([canvas.width, canvas.height], 0);
            device.queue.writeBuffer(uniformBuffer, 0, uniformValues); // copy the values from JavaScript to the GPU

            const renderPass: GPURenderPassEncoder = commandEncoder.beginRenderPass(renderPassDescriptor)
            renderPass.setPipeline(pipeline)
            renderPass.setBindGroup(0, bindGroup)
            renderPass.setVertexBuffer(0, mesh.buffer)
            renderPass.draw(3*2) // call vertex shader 3 times
            renderPass.end()

            device.queue.submit([commandEncoder.finish()])

            // setTimeout(() => {
            //     requestAnimationFrame(frame);
            // }, 1000 / 1);
            // requestAnimationFrame(frame)
        }

        function resize() {
            const devicePixelRatio = window.devicePixelRatio
            canvas.width = canvas.clientWidth * devicePixelRatio
            canvas.height = canvas.clientHeight * devicePixelRatio

            requestAnimationFrame(frame)
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
