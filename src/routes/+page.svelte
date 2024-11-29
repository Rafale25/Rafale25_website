<script>
    import Navbar from '$lib/components/navbar.svelte'
    import Project from '$lib/components/project.svelte'
    import Footer from '$lib/components/footer.svelte'

    let customHue = 234
</script>

<!--
    - gif when hovering projects
    - page for each project
-->

<main class="flex flex-col overflow-hidden min-h-screen" style="--customHue: {customHue}">
    <!-- <input type="range" bind:value={customHue} min="0" max="360">
    <span class="text-white">{customHue}</span> -->

    <div class="flex flex-col w-full h-full bg-no-repeat bg-cover bg-center bg-[url('/boids-blurred.png')]">
        <Navbar/>

        <div class="flex flex-col w-full h-full items-center justify-center px-8 py-16 backdrop-brightness-[50%]">
            <div class="font-bold text-lg text-center text-neutral-100 sm:w-[60ch]">
                <span class="drop-shadow-[0_2px_2px_rgba(0,0,0,1)]">
                    Hey! I'm Rafale25, I like game-design, computer graphics, simulation and optimisation.
                </span>
            </div>
            <!-- <div class="font-bold text-center text-xl text-yellow-400">
                <span class="drop-shadow-[0_2px_2px_rgba(0,0,0,1)]">Yellow text</span>
            </div> -->
        </div>
    </div >

    <div class="w-full h-2 backdrop-brightness-[70%]"></div>

    <div class="flex flex-wrap w-full justify-center my-16 px-5 gap-8">
        <Project
            name={'Pathtracer'}
            link={'raytracer'}
            img={'https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/pathtraced_raymarching_4.png'}
            description={'Pathtracer in browser with raytracing and raymarching implementation.'}
            tags={['js', 'WebGPU', 'wgsl']}
        />
        <Project
            name={'Minecraft clone'}
            link={'https://github.com/Rafale25/minecraft-clone'}
            img={'https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/Screenshot%20from%202024-06-02%2005-42-20.png'}
            description={'Minecraft clone using modern OpenGL with multiplayer support.'}
            tags={['C++', 'OpenGL']}
        />
        <Project
            name={'Knossos'}
            link={'https://primarter.itch.io/knossos'}
            img={'https://github.com/Primarter/Knossos/raw/dev/img/ScreenshotStartingZone.png'}
            description={'Game Design master\'s game that was made in duo over a period of 3 months in Unity'}
            tags={['Unity']}
        />
        <Project
            name={'Run Hunt Repeat'}
            link={'https://rafale25.itch.io/run-hunt-repeat'}
            img={'https://img.itch.zone/aW1hZ2UvMTczMTQ2OC8xMDE5MzU2NC5wbmc=/original/Uwgfw9.png'}
            description={'Game I made for the Ludum Dare 51'}
            tags={['Python', 'Arcade', 'Ludum Dare']}
        />
        <Project
            name={'Light Is Death'}
            link={'https://rafale25.itch.io/light-is-death'}
            img={'./light-is-death.png'}
            description={'Game I made for the Global Game Jam 2022'}
            tags={['Python', 'Arcade', 'GlobalGameJam']}
        />
        <Project
            name='Vine mesh generation'
            link='https://github.com/Rafale25/Vine_mesh_generation'
            img='./vine.png'
            description='Vine mesh generation using geometry shader'
            tags={['OpenGL', 'GLSL', 'Geometry Shaders']}
        />
        <Project
            name='Slime'
            link='https://github.com/Rafale25/Slime_simulation'
            img='./slime.png'
            description='Blob simulation using compute shaders'
            tags={['OpenGL', 'GLSL', 'Compute Shaders']}
        />
        <Project
            name='Boids'
            link='https://github.com/Rafale25/Boids'
            img='./boids.png'
            description='Large flocking simulation using compute shaders'
            tags={['OpenGL', 'GLSL', 'Compute Shaders']}
        />
        <Project
            name='ScrapMechanic injection interface'
            link='https://github.com/Rafale25/python_injection_interface_SM'
            img='./sm_interface.png'
            description='Modular interface for sending custom inputs to the game ScrapMechanic through the Injection Mod'
            tags={['ScrapMechanic', 'Python', 'DearPygui', 'Pygame']}
        />

        <div class="flex justify-center items-center relative">
            <a class="absolute text-lg text-opacity-0 text-green-500" href="boids">
                Boids2D
            </a>
        </div>
    </div>

    <Footer/>
</main>

<style>
    main {
        font-family: monospace;
        background-color: hsl(var(--customHue), 76%, 3%);

        /* background-repeat: repeat; */
        /* background: center no-repeat center; */
        /* background-image: url("/tri.png"); */
    }
</style>
