<script>
    import Project from "../components/project.svelte";

    function clipboard() {
        const discord_username = "rafale25";
        navigator.clipboard.writeText(discord_username);
        window.alert(`${discord_username} copied to the clipboard`);
    }
</script>

<!--
    - gif when hovering projects
    - page for each project
-->

<svelte:head>
    <link rel="icon" type="image/jpg" href="logo.jpg" />
    <title>Rafale25</title>
</svelte:head>

<main class="overflow-hidden">
    <div class="flex flex-col w-full h-80 bg-no-repeat bg-cover bg-center bg-[url('/boids-blurred.png')]">

        <nav class="flex w-full justify-between items-center py-4 backdrop-brightness-[10%]">
            <div class="flex items-center gap-x-4  px-6">
                <img class="w-12 rounded-lg" src="logo.jpg" alt="ProfilePicture"/>
                <div class="text-xl">
                    <span class="text-white">Rafale25</span>
                </div>
            </div>

            <div class="flex font-bold gap-x-8 px-9 text-lg text-neutral-300">
                <a class="btn hover:underline" href="/">Projects</a>
                <a class="btn hover:underline" href="/screenshots">Screenshots</a>
            </div>
        </nav>

        <div class="flex flex-col w-full h-full items-center justify-center px-12 gap-6 backdrop-brightness-[50%]">
            <div class="font-bold text-lg text-center text-neutral-100">
                <span class="drop-shadow-[0_2px_2px_rgba(0,0,0,1)]">Hey! I'm Rafale25, I like game-design, computer graphics, simulation and optimisation.</span>
            </div>
            <div class="font-bold text-center text-xl text-yellow-400">
                <span class="drop-shadow-[0_2px_2px_rgba(0,0,0,1)]">Currently looking for a 6 months internship!</span>
            </div>
        </div>

    </div >

    <div class="w-full h-2 backdrop-brightness-[70%]"/>

    <div class="flex flex-col w-full items-center my-16 px-5 gap-8">
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
    </div>

    <footer class="flex justify-center items-center gap-x-6 p-10 bg-raflou-background-secondary">
        <a href="https://github.com/Rafale25">
            <img src="github-icon.svg" alt="Github Icon" class="w-12"/>
        </a>
        <a href="https://www.youtube.com/channel/UCjJYtSy8dMGJkMVrBnwaWSA">
            <img src="youtube-icon.svg" alt="Youtube Icon" class="w-12"/>
        </a>

        <!-- svelte-ignore a11y-invalid-attribute -->
        <a href="" on:click={clipboard}>
            <img src="discord-icon.svg" alt="Discord Icon" class="w-12"/>
        </a>

        <a href="mailto:rafale25.dev@gmail.com" aria-label="email">
            <img src="mail.svg" alt="Youtube Icon" class="w-12"/>
        </a>
    </footer>

</main>

<style>
    main {
        font-family: monospace;
        background-repeat: repeat;
        background: center no-repeat center;
        background-image: url("/tri.png");
    }
    </style>
        <!-- bg-no-repeat bg-cover bg-center bg-[url('/boids-blurred.png')]" -->
        <!-- background-color: #0f1012; -->
