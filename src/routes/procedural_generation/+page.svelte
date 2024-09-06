<script>
    import { onMount } from 'svelte'

    // Window, webgl2 //
    let gl, canvas
    let innerWidth, innerHeight

    // Rendering //
    let frame_count = 0
    let program, vao
    let resolutionUniformLocation
    let vertexCount = 0

    // Buttons //
    let generate

    // Config //
    let scale = 12
    let seed = 0;
    let voxelWidth = 128
    let voxelHeight = 128
    let centerX = 0, centerY = 0, centerZ = 0

    const BLOCK = {
        AIR: 0,
        GRASS: 1,
        DIRT: 2,
        STONE: 3,
    }

    const vertexShaderSource = `#version 300 es
        in vec2 a_position;
        in float a_material;

        uniform vec2 u_resolution;

        flat out float f_material;

        void main() {
            f_material = a_material;
            gl_Position = vec4(a_position / u_resolution, 0.0, 1.0);
        }
    `;

    const fragmentShaderSource = `#version 300 es
        precision highp float;

        flat in float f_material;

        out vec4 outColor;

        vec3 materials[] = vec3[](
            vec3(0.0, 0.0, 0.0) / 255.0,  // Air
            vec3(105, 163, 90) / 255.0,  // Grass
            vec3(122, 99, 76)   / 255.0,  // Dirt
            vec3(119, 119, 122) / 255.0   // Stone
        );

        void main() {
            outColor = vec4(materials[int(f_material)], 1.0);
        }
    `;

    function createShader(gl, type, source) {
        const shader = gl.createShader(type);
        gl.shaderSource(shader, source);
        gl.compileShader(shader);
        const success = gl.getShaderParameter(shader, gl.COMPILE_STATUS);
        if (success) {
            return shader;
        }
        console.log(gl.getShaderInfoLog(shader));
        gl.deleteShader(shader);
    }

    function createProgram(gl, vertexShader, fragmentShader) {
        const program = gl.createProgram();
        gl.attachShader(program, vertexShader);
        gl.attachShader(program, fragmentShader);
        gl.linkProgram(program);
        const success = gl.getProgramParameter(program, gl.LINK_STATUS);
        if (success) {
            return program;
        }
        console.log(gl.getProgramInfoLog(program));
        gl.deleteProgram(program);
    }

    function getRandomInt(max) {
        return Math.floor(Math.random() * max)
    }

    function square(x, y, size=20, material=1) {
        const dx = x*size
        const dy = y*size

        return [
            dx,      dy,        material,
            dx+size, dy,        material,
            dx,      dy+size,   material,

            dx+size, dy,        material,
            dx+size, dy+size,   material,
            dx,      dy+size,   material,
        ]
    }

    function getBlock(x, y, z) {
        const baseHeight = 16
        const height = Math.floor(Math.sin(x * 0.2) * 4) + baseHeight

        if (y === height) return BLOCK.GRASS
        if (y < height && y > height - 3) return BLOCK.DIRT
        if (y < height) return BLOCK.STONE
        return BLOCK.AIR
    }

    function generateTerrainSlice(_x, _y, _z, width, height) {
        const positions = []

        const lowX = _x - (width/2) >> 0 // use to get integer part of value without Math.floor
        const rightX = _x + (width/2) >> 0

        const lowY = _y - (height/2) >> 0
        const highY = _y + (height/2) >> 0

        for (let x = lowX ; x < rightX ; ++x) {
            for (let y = lowY ; y < highY ; ++y) {
                const block = getBlock(x, y, _z)
                if (block === BLOCK.AIR) continue
                positions.push(
                    ...square(
                        x - _x,
                        y - _y,
                        scale, block)
                )
            }
        }

        return positions
    }

    generate = () => {
        const vertices = generateTerrainSlice(
            centerX,
            centerY,
            centerZ,
            voxelWidth, voxelHeight
        )
        vertexCount = vertices.length / 3
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW)
    }

    function init() {
        const vertexShader = createShader(gl, gl.VERTEX_SHADER, vertexShaderSource)
        const fragmentShader = createShader(gl, gl.FRAGMENT_SHADER, fragmentShaderSource)

        program = createProgram(gl, vertexShader, fragmentShader)

        resolutionUniformLocation = gl.getUniformLocation(program, "u_resolution");

        const vertexBuffer = gl.createBuffer()
        gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer)

        generate()

        vao = gl.createVertexArray()
        gl.bindVertexArray(vao)
        gl.enableVertexAttribArray(0)
        gl.enableVertexAttribArray(1)
        gl.vertexAttribPointer(0, 2, gl.FLOAT, false, 4*3, 0)
        gl.vertexAttribPointer(1, 1, gl.FLOAT, false, 4*3, 8)
    }

    function frame() {
        gl.clearColor(0, 0, 0, 0)
        gl.clear(gl.COLOR_BUFFER_BIT)

        gl.useProgram(program)
        gl.uniform2f(resolutionUniformLocation, canvas.width, canvas.height);

        gl.bindVertexArray(vao)
        gl.drawArrays(gl.TRIANGLES, 0, vertexCount)

        frame_count += 1
        requestAnimationFrame(() => frame());
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
        const speed = Math.max(1, 40 / scale)

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

        window.addEventListener('resize', () => updateWidthHeight())
        updateWidthHeight()

        init()
        frame()
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

            <button class="w-fit px-2 border-2 rounded" on:click={generate}>Generate</button>

            <div class="flex items-center gap-x-2">
                Seed<input class="text-center" type="number" step="1" min="0" max="2147483647" bind:value={seed} on:change={generate}>
            </div>

            <div class="flex items-center gap-x-2">
                X<input class="text-center" type="number" step="1" min="-256" max="256" bind:value={centerX} on:change={onChangeDimension}>
                Y<input class="text-center" type="number" step="1" min="-256" max="256" bind:value={centerY} on:change={onChangeDimension}>
                Z<input class="text-center" type="number" step="1" min="-256" max="256" bind:value={centerZ} on:change={onChangeDimension}>
            </div>

            <div class="flex items-center gap-x-2">
                Width<input class="text-center" type="number" step="1" min="8" max="1024" bind:value={voxelWidth} on:change={onChangeDimension}>
            </div>
            <div class="flex items-center gap-x-2">
                Height<input class="text-center" type="number" step="1" min="8" max="1024" bind:value={voxelHeight} on:change={onChangeDimension}>
            </div>
            <div class="flex items-center gap-x-2">
                Scale<input class="text-center" type="number" step="1" min="1" max="100" bind:value={scale} on:change={onChangeDimension}>
            </div>

        </div>
    </div>

    <canvas class="bg-neutral-600" width={innerWidth} height={innerHeight} bind:this={canvas}></canvas>
</main>

<style>
    :root {
        background-color: rgb(82 82 82);
    }

    input[type='number']::-webkit-inner-spin-button,
    input[type='number']::-webkit-outer-spin-button {
        opacity: 1;
    }
</style>
