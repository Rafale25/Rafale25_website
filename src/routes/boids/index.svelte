<script>
    // import Boids from "./boids.svelte";
    import { onMount } from 'svelte'

    let canvas
    let init, play, stop
    let innerWidth, innerHeight

    let Config = {
        count: 3000,
        radius: 10,
        speed: 2.0,
        viewDistance: 45.0,

        separationWeight: 1.5,
        aligmentWeight: 0.3,
        cohesionWeight: 0.005,
    }

    onMount(() => {
        function randRange(min, max) { // min and max included
            return (Math.random() * (max - min) + min)
        }

        function sqrDist(x1, y1, x2, y2) {
            const dx = x2 - x1
            const dy = y2 - y1
            return (dx*dx + dy*dy)
        }

        function cellCoord(x, y, size) {
            return [ Math.floor(x/size), Math.floor(y/size) ]
        }

        function hashCoords(x, y, count) {
            // const h = (x * 92837111) ^ (y * 689287499)
            // return Math.abs(h) % count

            const h = y*675 + x
            return Math.abs(h) % count
        }

        function DebugTime(id, func) {
            const t1 = performance.now()
            func()
            const t2 = performance.now()

            const el = document.getElementById(id);
            if (el)
                el.textContent=`${(t2 - t1).toFixed(2)} ms`
        }

        // const canvas = document.getElementById("boidCanvas")
        const ctx = canvas.getContext("2d")

        let isRunning = true
        const boids = []
        const bucket_boids = []

        let count = new Array(Config.count).fill(0)

        const boidCanvas = document.createElement('canvas')
        const ctxBoid = boidCanvas.getContext('2d')
        boidCanvas.width = Config.radius*2 + 4;
        boidCanvas.height = Config.radius*2 + 4;
        ctxBoid.fillStyle = 'lime'
        ctxBoid.beginPath()
        ctxBoid.translate(2, 2)
        ctxBoid.arc(Config.radius, Config.radius, Config.radius, 0, 2 * Math.PI, false)
        ctxBoid.fill()
        ctxBoid.stroke()
        ctxBoid.closePath()

        ctxBoid.beginPath()
        ctxBoid.moveTo(Config.radius, Config.radius)
        ctxBoid.lineTo(Config.radius*2, Config.radius)
        ctxBoid.stroke()
        ctxBoid.closePath()

        const boidPattern = ctx.createPattern(boidCanvas, 'no-repeat');


        class Vector {
            constructor(x=0, y=0) {
                this.x = x
                this.y = y
            }

            add(other) {
                return new Vector(this.x + other.x, this.y + other.y)
            }

            sub(other) {
                return new Vector(this.x - other.x, this.y - other.y)
            }

            mul(scalar) {
                return new Vector(this.x * scalar, this.y * scalar)
            }

            div(scalar) {
                return new Vector(this.x / scalar, this.y / scalar)
            }

            length() {
                return Math.sqrt(this.x*this.x + this.y*this.y)
            }

            normalize() {
                return this.div(this.length())
            }
        }

        class Boid {
            constructor(x=0, y=0, angle=0) {
                this.pos = new Vector(x, y)
                this.vel = new Vector(Math.cos(angle), Math.sin(angle))
                this.hash = null
            }

            update() {
                this.pos.x += this.vel.x * Config.speed
                this.pos.y += this.vel.y * Config.speed
            }

            draw() {
                ctx.arc(this.pos.x, this.pos.y, Config.radius, 0, 2 * Math.PI, false)
                // ctx.fill()

                // ctx.moveTo(this.pos.x, this.pos.y)
                // ctx.lineTo(this.pos.x + (this.vel.x * Config.radius), this.pos.y + (this.vel.y * Config.radius))
                // ctx.stroke()
            }
        }


        const compute = (me) => {
            let nbFlockmates = 0;
            let averageDirection = new Vector(0, 0)
            let averagePosition = new Vector(0, 0)
            let totalForce = new Vector(0, 0)

            for (let y = -1 ; y <= 1 ; ++y) {
            for (let x = -1 ; x <= 1 ; ++x) {
                const cell = cellCoord(me.pos.x, me.pos.y, Config.viewDistance)
                cell[0] += x
                cell[1] += y

                const cellHash = hashCoords(cell[0], cell[1], Config.count)
                const start = count[cellHash]
                const end = count[cellHash + 1]

                for (let i = start ; i < Config.count && i < end; ++i) {
                    const other = bucket_boids[i]
                    if (me == other) continue

                    const distSqr = sqrDist(me.pos.x, me.pos.y, other.pos.x, other.pos.y)

                    if (distSqr < Config.viewDistance * Config.viewDistance) {
                        nbFlockmates += 1
                        averageDirection = averageDirection.add(other.vel)
                        averagePosition = averagePosition.add(other.pos)
                        totalForce = totalForce.add( ( me.pos.sub(other.pos) ).div(distSqr) )
                    }
                }
            }
            }

            me.vel = me.vel.add(totalForce.mul(Config.separationWeight))

            if (nbFlockmates != 0) {
                averageDirection = averageDirection.div(nbFlockmates)
                me.vel = me.vel.add( averageDirection.mul(Config.aligmentWeight) )

                averagePosition = averagePosition.div(nbFlockmates)
                me.vel = me.vel.add( me.pos.sub(averagePosition).mul(Config.cohesionWeight).mul(-1) )
            }

            me.vel = me.vel.normalize()
        }

        const step = () => {
            if (!isRunning) return

            canvas.width = innerWidth
            canvas.height = innerHeight

            count.fill(0)

            // counting + update hash
            for (const boid of boids) {
                const cell = cellCoord(boid.pos.x, boid.pos.y, Config.viewDistance)
                boid.hash = hashCoords(cell[0], cell[1], Config.count)

                count[boid.hash] += 1
            }

            // prefix sum
            for (let i = 1 ; i < Config.count ; ++i) {
                count[i] += count[i - 1]
            }

            // fill in
            for (const boid of boids) {
                count[boid.hash] -= 1
                bucket_boids[ count[boid.hash] ] = boid
            }

            DebugTime("ComputeTime", () => {
                for (let boid of boids) {
                    boid.update()

                    compute(boid)

                    if (boid.pos.x < 0 - Config.radius)
                        boid.pos.x = canvas.width + Config.radius
                    if (boid.pos.x > canvas.width + Config.radius)
                        boid.pos.x = 0 - Config.radius
                    if (boid.pos.y < 0 - Config.radius)
                        boid.pos.y = canvas.height + Config.radius
                    if (boid.pos.y > canvas.height + Config.radius)
                        boid.pos.y = 0 - Config.radius
                }
            })

            ctx.clearRect(0, 0, canvas.width, canvas.height)

            DebugTime('RenderingTime', () => {
                ctx.fillStyle = boidPattern
                boids.forEach(boid => {
                    ctx.save()
                    ctx.translate(boid.pos.x, boid.pos.y)
                    ctx.rotate(Math.atan2(boid.vel.y, boid.vel.x))
                    ctx.translate(-Config.radius, -Config.radius)
                    ctx.fillRect(0, 0, boidCanvas.width, boidCanvas.height)
                    ctx.restore()
                })
            })

            setTimeout( () => step(), 1000.0/60.0)
        }

        init = () => {
            // window.onresize()

            boids.length = Config.count
            bucket_boids.length = Config.count

            for (let i = 0 ; i < Config.count ; ++i) {
                boids[i] = new Boid(
                    randRange(0, canvas.width),
                    randRange(0, canvas.height),
                    randRange(0, Math.PI*2)
                )
            }
        }

        play = () => {
            if (!isRunning === true) {
                isRunning = true
                step()
            }
        }

        stop = () => {
            isRunning = false
        }

        init()
        step()
    });

</script>

<svelte:window
    bind:innerWidth
    bind:innerHeight
/>

<main>
    <!-- <body style="margin: 0; height: 100vh; width: 100%;"> -->
    <body class="">

        <div class="absolute">
            <div class="flex flex-col p-4 gap-4 bg-slate-400">

                <div class="inline-block">
                    <span>Compute</span> <span id="ComputeTime"></span>
                </div>
                <div class="inline-block">
                    <span>Rendering</span> <span id="RenderingTime"></span>
                </div>

                <div class="flex justify-center gap-x-4">
                    <button class="relative px-2 border-2" on:click={init}>reset</button>
                    <button class="relative px-2 border-2" on:click={play}>play</button>
                    <button class="relative px-2 border-2" on:click={stop}>stop</button>
                </div>

                <div class="flex">
                    <input class="relative" type="range" min="0.0" max="4.0" step="0.001" bind:value={Config.separationWeight}>
                    <span>Separation</span>
                </div>

                <div class="flex">
                    <input class="relative" type="range" min="0.0" max="1.0" step="0.001" bind:value={Config.aligmentWeight}>
                    <span>Aligment</span>
                </div>

                <div class="flex">
                    <input class="relative" type="range" min="0.0" max="0.1" step="0.0001" bind:value={Config.cohesionWeight}>
                    <span>Cohesion</span>
                </div>

                <div class="flex">
                    <input class="relative mx-2" type="range" min="0.0" max="10.0" step="0.0001" bind:value={Config.speed}>
                    <span>Speed</span>
                </div>

                <div class="flex">
                    <input class="relative mx-2" type="range" min="0.0" max="100.0" step="0.0001" bind:value={Config.viewDistance}>
                    <span>View distance</span>
                </div>

            </div>
        </div>

        <canvas class="bg-slate-400" width="800" height="800" bind:this={canvas}></canvas>
    </body>

</main>

