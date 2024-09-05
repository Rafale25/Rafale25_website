<script>
    import { onMount } from 'svelte'

    let gl
    let canvas
    let generate
    let innerWidth, innerHeight

    let frame_count = 0

    let program, vao
    let resolutionUniformLocation

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
            vec3(1.0, 0.0, 0.0),
            vec3(0.0, 1.0, 0.0),
            vec3(0.0, 0.0, 1.0),
            vec3(0.0, 1.0, 1.0)
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

    function square(x, y, size=20, material=0) {
        const dx = x*size
        const dy = y*size

        material = getRandomInt(4)

        return [
            dx,      dy,        material,
            dx+size, dy,        material,
            dx,      dy+size,   material,

            dx+size, dy,        material,
            dx+size, dy+size,   material,
            dx,      dy+size,   material,
        ]
    }

    function createTerrainSlice() {
        const positions = []

        for (let x = 0 ; x < 10 ; ++x) {
            for (let z = 0 ; z < 10 ; ++z) {
                positions.push(...square(x, z))
            }
        }
        // positions.push(...square(0, 0))

        return positions
    }

    function init() {
        const vertexShader = createShader(gl, gl.VERTEX_SHADER, vertexShaderSource)
        const fragmentShader = createShader(gl, gl.FRAGMENT_SHADER, fragmentShaderSource)

        program = createProgram(gl, vertexShader, fragmentShader)

        resolutionUniformLocation = gl.getUniformLocation(program, "u_resolution");

        // const positionAttributeLocation = gl.getAttribLocation(program, "a_position")
        const vertexBuffer = gl.createBuffer()
        gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer)

        const vertices = createTerrainSlice()

        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW)

        vao = gl.createVertexArray()
        gl.bindVertexArray(vao)
        gl.enableVertexAttribArray(0)
        gl.vertexAttribPointer(0, 2, gl.FLOAT, false, 4*3, 0)
        gl.enableVertexAttribArray(1)
        gl.vertexAttribPointer(1, 1, gl.FLOAT, false, 4*3, 8)

        gl.viewport(0, 0, gl.canvas.width, gl.canvas.height)
    }

    function frame() {
        gl.clearColor(0, 0, 0, 0)
        gl.clear(gl.COLOR_BUFFER_BIT)

        gl.useProgram(program)
        gl.uniform2f(resolutionUniformLocation, gl.canvas.width, gl.canvas.height);

        gl.bindVertexArray(vao)
        gl.drawArrays(gl.TRIANGLES, 0, 3*2 * 10*10)

        frame_count += 1
        setTimeout( () => frame(gl), 1000.0/60.0)
    }

    onMount(() => {
        gl = canvas.getContext("webgl2");
        if (!gl) {
            alert("no webgl2 !")
            return
        }

        canvas.width = innerWidth
        canvas.height = innerHeight

        init()
        frame()
    })
</script>

<svelte:window
    bind:innerWidth
    bind:innerHeight
/>

<main>
    <div class="absolute">
        <div class="flex flex-col p-4 gap-4 bg-gray-300 rounded-md">

            <span>frames: {frame_count}</span>

            <button class="w-fit px-2 border-2 rounded" on:click={generate}>Generate</button>

            <div class="flex items-center gap-x-2">
                X<input class="text-center" type="number" value="0" step="1" min="-256" max="256">
                Y<input class="text-center" type="number" value="0" step="1" min="-256" max="256">
                Z<input class="text-center" type="number" value="0" step="1" min="-256" max="256">
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
