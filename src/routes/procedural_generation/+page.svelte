<script>
    import { onMount } from 'svelte'
    import { noise } from '$lib/noise.js'
    import { BlockType, getBlock } from '$lib/getBlock.js'

    // Window, webgl2 //
    let gl, canvas
    let innerWidth, innerHeight

    // Rendering //
    let frame_count = 0
    let program, vao
    let resolutionUniformLocation, scaleUniformLocation, voxelResolutionUniformLocation
    let instanceCount = 0
    let vertexBuffer, instanceBuffer

    // Config //
    let scale = 1.0
    let resolution = 4
    let seed = 0;
    let voxelWidth = 512, voxelHeight = 256
    let centerX = 0, centerY = 0, centerZ = 0


    const vertexShaderSource = `#version 300 es
        in vec2 a_position;

        in vec2 a_offset;
        in float a_material;

        uniform vec2 u_resolution;
        uniform float u_scale;
        uniform float u_voxelResolution;

        flat out float f_material;

        void main() {
            f_material = a_material;
            gl_Position = vec4((a_position*u_voxelResolution*u_scale + a_offset*u_scale) / u_resolution, 0.0, 1.0);
        }
    `;

    const fragmentShaderSource = `#version 300 es
        precision highp float;

        flat in float f_material;

        out vec4 outColor;

        vec3 materials[] = vec3[](
            vec3(0.0, 0.0, 0.0) / 255.0,  // Air
            vec3(105, 163, 90) / 255.0,   // Grass
            vec3(122, 99, 76)   / 255.0,  // Dirt
            vec3(119, 119, 122) / 255.0,  // Stone
            vec3(0, 0, 0) / 255.0,        // OAK LOG
            vec3(0, 0, 0) / 255.0,        // OAK LEAF
            vec3(59, 128, 173) / 255.0    // WATER
        );

        void main() {
            outColor = vec4(materials[int(f_material)], 1.0);
            //outColor = vec4(vec3(f_material * 0.5 + 0.5), 1.0);
        }
    `;

    function createShader(gl, type, source) {
        const shader = gl.createShader(type)
        gl.shaderSource(shader, source)
        gl.compileShader(shader)
        const success = gl.getShaderParameter(shader, gl.COMPILE_STATUS)
        if (success) {
            return shader
        }
        console.log(gl.getShaderInfoLog(shader))
        gl.deleteShader(shader)
    }

    function createProgram(gl, vertexShader, fragmentShader) {
        const program = gl.createProgram()
        gl.attachShader(program, vertexShader)
        gl.attachShader(program, fragmentShader)
        gl.linkProgram(program)
        const success = gl.getProgramParameter(program, gl.LINK_STATUS)
        if (success) {
            return program
        }
        console.log(gl.getProgramInfoLog(program))
        gl.deleteProgram(program)
    }

    function squareVertices() {
        return [
            0, 0,
            1, 0,
            0, 1,

            1, 0,
            1, 1,
            0, 1,
        ]
    }

    function square(x, y, material=1) {
        return [x, y, material]
    }

    function generateTerrainSlice(_x, _y, _z, width, height, resolution=1) {
        const instances = []

        const lowX = _x - (width/2) >> 0 // use to get integer part of value without Math.floor
        const rightX = _x + (width/2) >> 0

        let lowY = _y - (height/2) >> 0
        lowY = Math.max(-512, lowY) // To avoid lag by not generate too low

        let highY = _y + (height/2) >> 0
        highY = Math.min(512, highY) // To avoid lag by not generate too high

        for (let x = lowX ; x < rightX ; x+=resolution) {
            for (let y = lowY ; y < highY ; y+=resolution) {
                const block = getBlock(x, y, _z)
                // if (block === BlockType.AIR) continue
                instances.push(
                    ...square(
                        x - _x,
                        y - _y,
                        block)
                )
            }
        }

        return instances
    }

    function generate() {
        noise.seed(seed)
        const MAX_SIZE = 2<<14
        voxelWidth = Math.min(MAX_SIZE, (canvas.width*2 / scale) >> 0)
        voxelHeight = Math.min(MAX_SIZE, (canvas.height*2 / scale) >> 0)

        const startTime = performance.now()
        const instances = generateTerrainSlice(
            centerX,
            centerY,
            centerZ,
            voxelWidth, voxelHeight,
            resolution
        )
        const endTime = performance.now()
        console.log(`generateTerrainSlice: ${(endTime - startTime).toFixed(3)} ms`)

        instanceCount = instances.length / 3
        gl.bindBuffer(gl.ARRAY_BUFFER, instanceBuffer)
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(instances), gl.STATIC_DRAW)

        frame()
    }

    function init() {
        const vertexShader = createShader(gl, gl.VERTEX_SHADER, vertexShaderSource)
        const fragmentShader = createShader(gl, gl.FRAGMENT_SHADER, fragmentShaderSource)

        program = createProgram(gl, vertexShader, fragmentShader)

        resolutionUniformLocation = gl.getUniformLocation(program, "u_resolution");
        scaleUniformLocation = gl.getUniformLocation(program, "u_scale");
        voxelResolutionUniformLocation = gl.getUniformLocation(program, "u_voxelResolution");

        const vertices = squareVertices()
        vertexBuffer = gl.createBuffer()
        gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer)
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW)

        vao = gl.createVertexArray()
        gl.bindVertexArray(vao)
        gl.enableVertexAttribArray(0)
        gl.vertexAttribPointer(0, 2, gl.FLOAT, false, 4*2, 0)
        //gl.enableVertexAttribArray(1)
        //gl.vertexAttribPointer(1, 1, gl.FLOAT, false, 4*3, 8)

        instanceBuffer = gl.createBuffer()
        gl.bindBuffer(gl.ARRAY_BUFFER, instanceBuffer)

        gl.enableVertexAttribArray(1)
        gl.vertexAttribPointer(1, 2, gl.FLOAT, false, 4*3, 0)
        gl.enableVertexAttribArray(2)
        gl.vertexAttribPointer(2, 1, gl.FLOAT, false, 4*3, 4*2)
        gl.vertexAttribDivisor(1, 1);
        gl.vertexAttribDivisor(2, 1);
    }

    function frame() {
        gl.clearColor(0, 0, 0, 0)
        gl.clear(gl.COLOR_BUFFER_BIT)

        gl.useProgram(program)
        gl.uniform2f(resolutionUniformLocation, canvas.width, canvas.height);
        gl.uniform1f(scaleUniformLocation, scale);
        gl.uniform1f(voxelResolutionUniformLocation, resolution);

        gl.bindVertexArray(vao)
        gl.drawArraysInstanced(gl.TRIANGLES, 0, 6, instanceCount)

        frame_count += 1
    }

    function onChangeDimension() {
        voxelWidth = Math.floor(voxelWidth)
        voxelHeight = Math.floor(voxelHeight)
        generate()
    }

    const updateWidthHeight = () => {
        canvas.width = innerWidth
        canvas.height = innerHeight
        gl.viewport(0, 0, canvas.width, canvas.height)
    }

    function onKeyDown(e) {
        const speed = Math.max(1, 90 / scale)

        switch (e.key) {
            case "ArrowRight":
                centerX += speed
                break
            case "ArrowDown":
                centerY -= speed
                break
            case "ArrowLeft":
                centerX -= speed
                break
            case "ArrowUp":
                centerY += speed
                break
        }

        centerX = Math.round(centerX)
        centerY = Math.round(centerY)
        centerZ = Math.round(centerZ)

        generate()
    }

    onMount(() => {
        gl = canvas.getContext("webgl2");
        if (!gl) {
            alert("no webgl2 !")
            return
        }

        window.addEventListener('resize', () => { updateWidthHeight(); onChangeDimension(); })
        updateWidthHeight()

        init()
        onChangeDimension()
    })
</script>

<svelte:window
    bind:innerWidth
    bind:innerHeight
    on:keydown={onKeyDown}
/>

<main>
    <div class="absolute">
        <div class="flex flex-col p-4 gap-4 bg-gray-300 rounded-md opacity-90">

            <span>frames: {frame_count}</span>

            <div class="flex items-center gap-x-2">
                Seed<input class="text-center" type="number" step="1" min="0" max="2147483647" bind:value={seed} on:change={generate}>
            </div>

            <div class="flex items-center gap-x-2">
                X<input class="text-center" type="number" step="1" min="-65536" max="65536" bind:value={centerX} on:input={onChangeDimension}>
                Y<input class="text-center" type="number" step="1" min="-65536" max="65536" bind:value={centerY} on:input={onChangeDimension}>
                Z<input class="text-center" type="number" step="1" min="-65536" max="65536" bind:value={centerZ} on:input={onChangeDimension}>
            </div>

            <div class="flex items-center gap-x-2">
                Scale<input class="text-center" type="number" step="0.1" min="0.1" max="100" bind:value={scale} on:change={onChangeDimension}>
                Resolution<input class="text-center" type="number" step="1" min="1" max="64" bind:value={resolution} on:change={onChangeDimension}>
            </div>

            <div class="flex items-center gap-x-2">
                <span class="text-center">Width {voxelWidth}</span>
                <span class="text-center">Height {voxelHeight}</span>

            </div>

        </div>
    </div>

    <canvas class="bg-neutral-700" width={innerWidth} height={innerHeight} bind:this={canvas}></canvas>
</main>

<style>
    :root {
        background-color: rgb(82 82 82);
    }

    input[type='number']::-webkit-inner-spin-button,
    input[type='number']::-webkit-outer-spin-button {
        opacity: 1;
    }

    canvas {
        image-rendering: pixelated;
    }
</style>
