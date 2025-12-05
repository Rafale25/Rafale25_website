<script>
    import Navbar from '$lib/components/navbar.svelte'
    import Project from '$lib/components/project.svelte'
    import Footer from '$lib/components/footer.svelte'
    import GPwebring from '$lib/components/GP_webring.svelte'

    let customHue = 234

    const Type = {
        All: 0,
        Graphic: 1,
        Game: 2
    }

    const projects = [
        {
            name:'Bleh',
            link:'https://rafale25.itch.io/bleh',
            img:'https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/thumbnail-Bleh.webp',
            description:'Game made in 48h for the Micro Jam #042 : Frogs',
            date: 'Jun 2025',
            tags:['Unity', 'C#', 'MicroJam'],
            type: Type.Game,
        },
        {
            name:'Pathtracer',
            link:'raytracer',
            img:'https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/pathtraced_raymarching_4.webp',
            description:'Pathtracer in browser with raytracing and raymarching implementation.',
            date: 'Oct 2024',
            tags:['js', 'WebGPU', 'wgsl'],
            type: Type.Graphic,
        },
        {
            name:'Minecraft clone',
            link:'https://github.com/Rafale25/minecraft-clone',
            img:'https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_01.webp',
            description:'Minecraft clone focused on graphic programming techniques using modern OpenGL with multiplayer support.',
            date: 'May 2024 (updated Nov 2025)',
            tags:['C++', 'OpenGL'],
            type: Type.Graphic,
        },
        {
            name:'Knossos',
            link:'https://primarter.itch.io/knossos',
            img:'https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/knossos.webp',
            description:'Game Design master\'s game that was made in duo over a period of 3 months in Unity.',
            date: 'Aug 2023',
            tags:['Unity', 'C#'],
            type: Type.Game,
        },
        {
            name:'Run Hunt Repeat',
            link:'https://rafale25.itch.io/run-hunt-repeat',
            img:'https://img.itch.zone/aW1hZ2UvMTczMTQ2OC8xMDE5MzU2NC5wbmc=/original/Uwgfw9.png',
            description:'Game I made for the Ludum Dare 51.',
            date: 'Oct 2022',
            tags:['Python', 'Arcade', 'Ludum Dare'],
            type: Type.Game,
        },
        {
            name:'Light Is Death',
            link:'https://rafale25.itch.io/light-is-death',
            img:'./light-is-death.png',
            description:'Game I made for the Global Game Jam 2022.',
            date: 'Jan 2022',
            tags:['Python', 'Arcade', 'GlobalGameJam'],
            type: Type.Game,
        },
        {
            name:'L-system-Visualizer',
            link:'https://github.com/Rafale25/L-System-Explorer',
            img:'https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/image18.png',
            description:'Visualizer for fractal patterns generated using L-systems.',
            date: 'Jan 2022',
            tags:['Python', 'OpenGL', 'L-System'],
            type: Type.Graphic,
        },
        {
            name:'Vine mesh generation',
            link:'https://github.com/Rafale25/Vine_mesh_generation',
            img:'./vine.png',
            description:'Vine mesh generation using geometry shader.',
            date: 'Oct 2021',
            tags:['OpenGL', 'GLSL', 'Geometry Shaders'],
            type: Type.Graphic,
        },
        {
            name:'Slime',
            link:'https://github.com/Rafale25/Slime_simulation',
            img:'./slime.png',
            description:'Blob simulation using compute shaders.',
            date: 'Sep 2021',
            tags:['OpenGL', 'GLSL', 'Compute Shaders'],
            type: Type.Graphic,
        },
        {
            name:'Boids',
            link:'https://github.com/Rafale25/Boids',
            img:'./boids.png',
            description:'Large flocking simulation using compute shaders.',
            date: 'Mar 2021 (updated Oct 2022)',
            tags:['OpenGL', 'GLSL', 'Compute Shaders'],
            type: Type.Graphic,
        },
        {
            name:'ScrapMechanic injection interface',
            link:'https://github.com/Rafale25/python_injection_interface_SM',
            img:'./sm_interface.png',
            description:'Modular interface for sending custom inputs to the game ScrapMechanic through the Injection Mod.',
            date: 'Aug 2021',
            tags:['ScrapMechanic', 'Python', 'DearPygui', 'Pygame'],
            type: Type.Graphic,
        }
    ]

    let filterType = $state(Type.All)

    let filteredProjects = $derived.by(() => {
        if (filterType == Type.All) return projects
        return projects.filter((project) => project.type == filterType)
    })

</script>

<main class="flex flex-col overflow-hidden min-h-screen">
    <!-- <input type="range" bind:value={customHue} min="0" max="360">
    <span class="text-white">{customHue}</span> -->

    <div class="flex flex-col w-full h-full bg-no-repeat bg-cover bg-center bg-[url('/boids-blurred.png')]">
        <Navbar/>

        <div class="flex flex-col w-full h-full items-center justify-center px-8 py-16 backdrop-brightness-[50%]">
            <div class="flex flex-col gap-4 font-bold text-lg text-center text-neutral-100 sm:w-[60ch] drop-shadow-[0_2px_2px_rgba(0,0,0,1)]">
                <p class="">
                    Hey! I'm Rafale25, I like graphic programming, game dev, simulation and optimization.
                </p>
                <p class="text-xl text-yellow-400 bounce-text">
                    Currently looking for a job!
                </p>
            </div>
        </div>
    </div >

    <div class="flex justify-center">
        <div class="flex flex-row justify-center font-bold gap-1 rounded-lg px-4 py-2 my-6 bg-primary3dark">
            <button class="text-primary1 rounded py-1 px-4 transition-all duration-200 {filterType!=Type.All && "hover:bg-primary3lighter"} {filterType==Type.All && "bg-primary3light"}" onclick={() => filterType=Type.All}>
                All
            </button>
            <button class="text-primary1 rounded py-1 px-4 transition-all duration-200 {filterType!=Type.Graphic && "hover:bg-primary3lighter"} {filterType==Type.Graphic && "bg-primary3light"}" onclick={() => filterType=Type.Graphic}>
                Graphics
            </button>
            <button class="text-primary1 rounded py-1 px-4 transition-all duration-200 {filterType!=Type.Game && "hover:bg-primary3lighter"} {filterType==Type.Game && "bg-primary3light"}" onclick={() => filterType=Type.Game}>
                Games
            </button>
        </div>
    </div>

    <div class="flex flex-col w-full items-center">
        <div class="grid md:grid-cols-2 xl:grid-cols-3 3xl:grid-cols-4 gap-8 w-11/12 sm:w-10/12 mb-6">
            {#each filteredProjects as props}
                <Project {...props}/>
            {/each}
        </div>
    </div>

    <div class="mb-6">
        <GPwebring fontSize={22}/>
    </div>

    <Footer/>
</main>
