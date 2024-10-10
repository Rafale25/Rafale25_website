<script lang='ts'>
    import NumberInput from '$lib/components/numberInput.svelte'
    import ColorInput from '$lib/components/colorInput.svelte'

    import { onMount } from 'svelte'
    import { mat4, vec3 } from "gl-matrix"
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

    let camera = new webgpuHelpers.Camera(60.0, width/height, vec3.fromValues(0,0,0), 0, 0)

    // functions
    let render = null
    let pause = null
    let reset = null

    let isPaused = true
    let updatedParams = true

    const params = {
        numRaysPerPixel: 1,
        maxLightBounce: 16,
        divergeStrength: 1.5,

        useSkybox: 1,
        skyColorZenith: [0.0788, 0.364, 0.7264],
        skyColorHorizon: [1.0, 1.0, 1.0],
        groundColor: [0.35, 0.3, 0.35],
        sunLightDirection: [0.53, 0.64, -0.53],
        sunFocus: 300.0,
        sunIntensity: 100.0,
    }

    let sunAngle = 0.0
    let sunPitch = 0.0
    // let sunRoll = 0.0

    const updateSunLightDirection = () => {
        let forward = vec3.fromValues(0, 0, 1)

        let mat = mat4.create()
        // mat4.rotateY(mat, mat, sunRoll)
        mat4.rotateZ(mat, mat, sunPitch)
        mat4.rotateX(mat, mat, sunAngle)

        vec3.transformMat4(forward, forward, mat)

        params.sunLightDirection = [...forward]
    }

    $: (sunAngle, sunPitch), updateSunLightDirection()
    $: params.useSkybox, params.useSkybox = +params.useSkybox;
    $: params, reset && reset()

    function onMouseMove(e) {
		// const x = e.clientX
		// const y = e.clientY

        // const dx = e.movementX || e.mozMovementX || e.webkitMovementX || 0
        // const dy = e.movementY || e.mozMovementY || e.webkitMovementY || 0

        // console.log(dx, dy)
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
        // --

        render = () => {
            isPaused = false;
        }

        pause = () => {
            isPaused = true;
        }

        reset = () => {
            const zeroArray = new Float32Array(canvas.width * canvas.height * 4).fill(0)
            device.queue.writeBuffer(pixelBuffer, 0, zeroArray)

            frameCount = 1
            updatedParams = true
        }

        function frame() {
            camera.update()

            if (isPaused && updatedParams === false) {
                requestAnimationFrame(frame)
                return
            };
            updatedParams = false

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

            device.queue.writeBuffer(uniformBuffer, 0, uniformValues.arrayBuffer); // copy the values from JavaScript to the GPU

            const renderPass: GPURenderPassEncoder = commandEncoder.beginRenderPass(renderPassDescriptor)
            renderPass.setPipeline(pipeline)
            renderPass.setBindGroup(0, bindGroup)
            renderPass.setVertexBuffer(0, mesh.buffer)
            renderPass.draw(3*2) // call vertex shader 3 times
            renderPass.end()


            device.queue.submit([commandEncoder.finish()])

            requestAnimationFrame(frame)
            frameCount += 1
        }

        function resize() {
            const devicePixelRatio = window.devicePixelRatio
            canvas.width = canvas.clientWidth * devicePixelRatio
            canvas.height = canvas.clientHeight * devicePixelRatio
        }

        resize()

        window.addEventListener('resize', () => {
            // To prevent resize() when still resizing window
            clearTimeout(resizedFinished);
            resizedFinished = setTimeout(() => {
                resize();
                console.log('Resized finished.');
            }, 100);
        })

        frame()
    })
</script>

<svelte:head>
    <title>Raytracer</title>
    <meta name="description" content="WebGPU Raytracer" />
</svelte:head>

<main>
    <div class="fixed z-10">
        <div class="flex flex-col p-4 gap-4 bg-slate-300/80 rounded-br">

            <div class="flex justify-center gap-x-4">
                <button class="px-2 border-2 hover:bg-blue-300 active:bg-blue-400" on:click={reset}>Reset</button>
                <button class="px-2 border-2 hover:bg-blue-300 active:bg-blue-400" on:click={render}>Render</button>
                <button class="px-2 border-2 hover:bg-blue-300 active:bg-blue-400" on:click={pause}>Pause</button>
            </div>

            <span>frame: {frameCount-1}</span>
            <span>samples: {frameCount*params.numRaysPerPixel}</span>

            <div class="flex gap-2">
                <span>Rays per pixel</span>
                <NumberInput min={1} max={128} step={1} bind:bindValue={params.numRaysPerPixel}/>
            </div>
            <div class="flex gap-2">
                <span>Max light bounce</span>
                <NumberInput min={0} max={128} step={1} bind:bindValue={params.maxLightBounce}/>
            </div>
            <div class="flex gap-2">
                <span>Diverge strength</span>
                <NumberInput min={0.0} max={200.0} step={0.1} bind:bindValue={params.divergeStrength}/>
            </div>
            <div class="flex gap-2">
                <span>Skybox</span>
                <input type="checkbox" bind:checked={params.useSkybox}/>
            </div>
            <div class="flex gap-2">
                <span>skyColorZenith</span>
                <ColorInput bind:bindValue={params.skyColorZenith}/>
            </div>
            <div class="flex gap-2">
                <span>skyColorHorizon</span>
                <ColorInput bind:bindValue={params.skyColorHorizon}/>
            </div>
            <div class="flex gap-2">
                <span>GroundColor</span>
                <ColorInput bind:bindValue={params.groundColor}/>
            </div>
            <div class="flex flex-col gap-2">
                <span>sunLightDirection</span>
                <div class="flex gap-2">
                    <span>Angle</span>
                    <NumberInput min={-Math.PI} max={Math.PI} step={0.1} bind:bindValue={sunAngle}/>
                </div>
                <div class="flex gap-2">
                    <span>Pitch</span>
                    <NumberInput min={-Math.PI} max={Math.PI} step={0.1} bind:bindValue={sunPitch}/>
                </div>
                <!-- <div class="flex gap-2">
                    <span>Roll</span>
                    <NumberInput min={-Math.PI} max={Math.PI} step={0.1} bind:bindValue={sunRoll}/>
                </div> -->
            </div>
            <div class="flex gap-2">
                <span>sunFocus</span>
                <NumberInput min={1} max={2000} step={50} bind:bindValue={params.sunFocus}/>
            </div>
            <div class="flex gap-2">
                <span>sunIntensity</span>
                <NumberInput min={0} max={1000} step={10} bind:bindValue={params.sunIntensity}/>
            </div>


        </div>
    </div>
</main>

<canvas
    class="w-screen h-screen"
    bind:this={canvas}
    bind:clientWidth={width}
    bind:clientHeight={height}
    on:mousemove={onMouseMove}
    {width} {height}
></canvas>

<!--
const bufferTexture2Dping: GPUTexture = device.createTexture({
    size: [canvas.width, canvas.height],
    usage: GPUTextureUsage.RENDER_ATTACHMENT | GPUTextureUsage.TEXTURE_BINDING | GPUTextureUsage.STORAGE_BINDING | GPUTextureUsage.COPY_DST | GPUTextureUsage.COPY_SRC,
    format: 'rgba32float',
});
const bufferTexture2Dpong: GPUTexture = device.createTexture({
    size: [canvas.width, canvas.height],
    usage: GPUTextureUsage.RENDER_ATTACHMENT | GPUTextureUsage.TEXTURE_BINDING,
    format: format,//'rgba32float',
});

const viewBufferTexture2Dping: GPUTextureView = bufferTexture2Dping.createView()
const viewBufferTexture2Dpong: GPUTextureView = bufferTexture2Dpong.createView()


commandEncoder.copyTextureToTexture({texture: bufferTexture2Dping}, {texture: currentTexture}, {width:canvas.width, height:canvas.height, depthOrArrayLayers:1})
-->
