<script>
    import Project from "../components/project.svelte";

    function clipboard() {
        const discord_username = "rafale25";
        navigator.clipboard.writeText(discord_username);
        window.alert(`${discord_username} copied to the clipboard`);
    }
</script>

<!--
    - add bio
    - gif when hovering projects
    - page for each project
-->

<svelte:head>
    <link rel="icon" type="image/jpg" href="logo.jpg" />
    <title>Rafale25</title>
</svelte:head>

<main>
    <div class="flex bg-no-repeat bg-cover bg-center bg-[color:var(--background-secondary)] bg-[url('/boids-blurred.png')]">
        <div class="flex w-full justify-center items-center">
            <div class="flex flex-col items-center p-2 gap-1">

                <img class="w-20 rounded-full" src="logo.jpg" alt="ProfilePicture"/>

                    <div class="group text-xl">
                        <span style="text-decoration: none; color: white;">Rafale25</span>
                        <!-- <span class="absolute text-transparent group-hover:text-[rgba(255,255,255,0.6)] duration-300">#0025</span> -->
                    </div>
            </div>
        </div>
    </div>


    <div class="flex flex-col m-16 gap-6">

        <div class="font-bold text-center text-xl text-yellow-400">
            <p>Currently looking for a 6 months internship!</p>
        </div>

        <div class="font-bold text-lg text-center text-neutral-400">
            <p>Hey! I'm Rafale25, I like game-design, computer graphics and simulation.</p>
        </div>
    </div>

    <div class="flex flex-col items-center w-full px-5 gap-8">

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

    <footer class="flex justify-center items-center gap-x-6 mt-16 p-10 bg-raflou-background-secondary">
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
        background-image: url("/tri.png");
        background-repeat: repeat;
    }
</style>
