<script lang='ts'>
    import NumberInput from '$lib/components/numberInput.svelte'

    import { onMount } from 'svelte'
    import { mat4 } from "gl-matrix"
    import {
        makeShaderDataDefinitions,
        makeStructuredView,
    } from 'webgpu-utils';

    import * as webgpuHelpers from '$lib/webgpuHelpers'
    import triangle_shader from './shader.wgsl?raw'

    let canvas: HTMLCanvasElement
    let width: number, height: number
    let resizedFinished = setTimeout(()=>{})
    let frameCount = 1

    let render = null; // function
    let pause = null; // function

    let isPaused = true

    // $bindable(
    const params = {
        numRaysPerPixel: 1,
        maxLightBounce: 16,
        divergeStrength: 1.5,

        useSkybox: 1,
        SkyColorZenith: [0.0788, 0.364, 0.7264],
        SkyColorHorizon: [1.0, 1.0, 1.0],
        GroundColor: [0.35, 0.3, 0.35],
        SunLightDirection: [0.53, 0.64, -0.53],
        SunFocus: 300.0,
        SunIntensity: 100.0,
    }

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

        const defs = makeShaderDataDefinitions(triangle_shader);
        const uniformValues = makeStructuredView(defs.uniforms.u_params);

        const uniformBuffer: GPUBuffer = device.createBuffer({
            size: uniformValues.arrayBuffer.byteLength,
            usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
        });

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

        render = () => {
            isPaused = false;
            requestAnimationFrame(frame)
        }

        pause = () => {
            isPaused = true;
        }


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

            uniformValues.set({
                resolution: [canvas.width, canvas.height],
                frameCount,
                ...params
            })

            console.log(params)

            device.queue.writeBuffer(uniformBuffer, 0, uniformValues.arrayBuffer); // copy the values from JavaScript to the GPU

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
            if (isPaused) return;

            requestAnimationFrame(frame)
            frameCount += 1
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

<main>
    <div class="fixed z-10">
        <div class="flex flex-col p-4 gap-4 bg-slate-300 rounded-br">

            <div class="flex justify-center gap-x-4">
                <button class="px-2 border-2 hover:bg-blue-300 active:bg-blue-400" on:click={null}>Reset</button>
                <button class="px-2 border-2 hover:bg-blue-300 active:bg-blue-400" on:click={render}>Render</button>
                <button class="px-2 border-2 hover:bg-blue-300 active:bg-blue-400" on:click={pause}>Pause</button>
            </div>


            <span>frame: {frameCount}</span>


            <!-- The bindValue is not working -->
            <div class="flex gap-2">
                <NumberInput min=1 max=128 step=1 bindValue={params.numRaysPerPixel}/>
                <span>Rays per pixel</span>
            </div>
            <div class="flex gap-2">
                <NumberInput min=0 max=128 step=1 bindValue={params.maxLightBounce}/>
                <span>Max light bounce</span>
            </div>
            <div class="flex gap-2">
                <NumberInput min=0.0 max=200.0 step=0.1 bindValue={params.divergeStrength}/>
                <span>Diverge strength</span>
            </div>

        </div>
    </div>
</main>

<canvas
    class="w-screen h-screen"
    bind:this={canvas}
    bind:clientWidth={width}
    bind:clientHeight={height}
    {width} {height}
/>
