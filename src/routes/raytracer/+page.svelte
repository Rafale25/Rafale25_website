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
    // import triangle_shader from './shader.wgsl?raw'
    import triangle_shader from './shader_raymarching.wgsl?raw'

    const KEY_FORWARD = 'KeyW'
    const KEY_BACK = 'KeyS'
    const KEY_RIGHT = 'KeyD'
    const KEY_LEFT = 'KeyA'
    const KEY_DOWN = 'KeyQ'
    const KEY_UP = 'KeyE'
    const keystate = {
        [KEY_FORWARD]: 0,
        [KEY_BACK]: 0,
        [KEY_RIGHT]: 0,
        [KEY_LEFT]: 0,
        [KEY_DOWN]: 0,
        [KEY_UP]: 0,
    }

    let canvas: HTMLCanvasElement
    let width: number, height: number
    let resizedFinished = setTimeout(()=>{})
    let frameCount = 1

    let camera = new webgpuHelpers.Camera(60.0, width/height, vec3.fromValues(0,0,0), -Math.PI/2, 0)

    let render: Function = ()=>{}
    let pause: Function = ()=>{}
    let reset: Function = ()=>{}

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
        sunLightDirection: [0.0, 0.0, 0.0],
        sunFocus: 300.0,
        sunIntensity: 100.0,

        focusDistance: 1.0,
        unfocusStrength: 0.0,

        // For raymarching //
        mergeStrength: 0.0,

        // viewMatrix: mat4.create(),
        // viewPosition: vec3.create()
    }

    let sunAngle = -2.1
    let sunPitch = -0.6

    const updateSunLightDirection = () => {
        let forward = vec3.fromValues(0, 0, 1)

        let mat = mat4.create()
        mat4.rotateZ(mat, mat, sunPitch)
        mat4.rotateX(mat, mat, sunAngle)

        vec3.transformMat4(forward, forward, mat)

        params.sunLightDirection = [...forward]
    }

    $: (sunAngle, sunPitch), updateSunLightDirection()
    $: params.useSkybox, params.useSkybox = +params.useSkybox;
    $: params, reset()

    function onMouseMove(e) {
        if (!document.pointerLockElement) return

        const dx = e.movementX || e.mozMovementX || e.webkitMovementX || 0
        const dy = e.movementY || e.mozMovementY || e.webkitMovementY || 0

        camera.onMouseMotion(-dx, dy)

        if (dx !== 0 || dy !== 0)
            reset()
    }

    function updateCamera() {
        if (!document.pointerLockElement) return

        const delta = vec3.fromValues(
            keystate[KEY_BACK] - keystate[KEY_FORWARD],
            keystate[KEY_UP] - keystate[KEY_DOWN],
            keystate[KEY_RIGHT] - keystate[KEY_LEFT],
        )

        camera.move(delta)

        if (delta.mag > 0.01)
            reset()
    }

    function onKeyUp(e) {
        keystate[e.code] = false
    }

    function onKeyDown(e) {
        if (!document.pointerLockElement) return
        keystate[e.code] = true
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

        render = () => {
            isPaused = false;
        }

        pause = () => {
            isPaused = true;
        }

        reset = () => {
            frameCount = 1
            updatedParams = true
        }

        function frame() {
            updateCamera()
            camera.update()

            if (isPaused && updatedParams === false) {
                requestAnimationFrame(frame)
                return
            };

            const commandEncoder: GPUCommandEncoder = device.createCommandEncoder()
            const textureView: GPUTextureView = context.getCurrentTexture().createView()

            if (updatedParams) {
                commandEncoder.clearBuffer(pixelBuffer, 0, pixelBuffer.size)
            }
            updatedParams = false

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
                ...params,
                viewPosition: camera.position,
                viewMatrix: camera.getViewInverse(),
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

        canvas.addEventListener("click", async () => {
            if (!document.pointerLockElement) {
                await canvas.requestPointerLock({
                    unadjustedMovement: true,
                });
            }
        });

        document.onkeydown = onKeyDown
        document.onkeyup = onKeyUp

        window.onbeforeunload = (e) => {
            e.preventDefault()
            e.stopPropagation()
        }

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
            </div>
            <div class="flex gap-2">
                <span>sunFocus</span>
                <NumberInput min={1} max={2000} step={50} bind:bindValue={params.sunFocus}/>
            </div>
            <div class="flex gap-2">
                <span>sunIntensity</span>
                <NumberInput min={0} max={1000} step={10} bind:bindValue={params.sunIntensity}/>
            </div>

            <div class="flex gap-2">
                <span>focusDistance</span>
                <NumberInput min={0} max={100} step={0.1} bind:bindValue={params.focusDistance}/>
            </div>
            <div class="flex gap-2">
                <span>unfocusStrength</span>
                <NumberInput min={0} max={1000} step={5} bind:bindValue={params.unfocusStrength}/>
            </div>

            <div class="flex gap-2">
                <span>mergeStrength</span>
                <NumberInput min={0} max={2.0} step={0.01} bind:bindValue={params.mergeStrength}/>
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
