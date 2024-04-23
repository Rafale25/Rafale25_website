<script lang='ts'>
/*
example:
    vao = VAO(mode=moderngl.LINES)
    vao.buffer(self.ctx.buffer(vertices), '3f', ['in_position'])
    vao.buffer(self.ctx.buffer(color), '3f', ['in_color'])

    vao2 = self.ctx.vertex_array(
        self.program['BOIDS_GS'],
        [
            (self.buffer_boid, '3f 1x4 3f 1x4', 'in_pos', 'in_for')
        ]
    )

webgpu:
    positionBuffer = createBuffer(positions, GPUBufferUsage.VERTEX);

    const mesh = mesh(
        {vertices, '3f'}
        {color, '3f'}
        // {vertices_color, '3f 3f'}
    )

*/
    import { onMount, onDestroy } from 'svelte'
    import { mat4 } from "gl-matrix"
    import * as rf from '$lib/raf-webgpu/'

    import triangle_shader from './triangle.wgsl?raw'

    let canvas: HTMLCanvasElement
    let width: number, height: number;

    onMount(async () => {
        const devicePixelRatio = window.devicePixelRatio
        canvas.width = canvas.clientWidth * devicePixelRatio
        canvas.height = canvas.clientHeight * devicePixelRatio

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
                 0.0,  0.5, 0.0,  1.0, 0.0, 0.0,
                -0.5, -0.5, 0.0,  0.0, 1.0, 0.0,
                 0.5, -0.5, 0.0,  0.0, 0.0, 1.0
            ]
        )
        const mesh = new rf.Mesh(device, vertices)
        const pipeline = rf.makePipeline(device, triangle_shader, triangle_shader, [mesh.bufferLayout], "triangle-list")

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

            const renderPass: GPURenderPassEncoder = commandEncoder.beginRenderPass(renderPassDescriptor)
            renderPass.setPipeline(pipeline)
            renderPass.setVertexBuffer(0, mesh.buffer)
            renderPass.draw(3, 5) // call vertex shader 3 times
            renderPass.end()

            device.queue.submit([commandEncoder.finish()])

            requestAnimationFrame(frame)
        }

        requestAnimationFrame(frame)
    })
</script>

<svelte:head>
    <title>Dynamic Foam</title>
    <meta name="description" content="WebGPU triangle render example" />
</svelte:head>

<canvas
    class="w-full h-auto"
    bind:this={canvas}
    bind:clientWidth={width}
    bind:clientHeight={height}
    {width} {height}
/>
