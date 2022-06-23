<script>
    import Project from "../components/project.svelte";
    import Swal from 'sweetalert2'
    import 'sweetalert2/dist/sweetalert2.min.css'

    function clipboard() {
        const discord_name = "Rafale25#0025";
        navigator.clipboard.writeText(discord_name);

        Swal.fire({
            title: `${discord_name} copied to the clipboard`,
            confirmButtonText: 'Ok'
        })
    }
</script>

<!--
    primary:
    - page for gamejams (add game "light is death")
    - add bio
    - gif when hovering projects
    - page for each project
    - cleanup slime.png (remove imgui from screenshot)
    secondary:
    - project sortable by date/name/stars?
-->

<main>
    <div class="flex bg-no-repeat bg-cover bg-center bg-[color:var(--background-secondary)] bg-[url('/boids-blurred.png')]">
        <div class="flex w-full justify-center items-center">
            <div class="flex flex-col items-center p-2 gap-1">

                <img class="w-20 rounded-full" src="logo.jpg" alt="ProfilePicture"/>

                    <div class="group text-xl" on:click={clipboard}>
                        <span style="text-decoration: none; color: white;">Rafale25</span>
                        <span class="absolute text-transparent group-hover:text-[rgba(255,255,255,0.6)] duration-300">#0025</span>
                    </div>
            </div>
        </div>
    </div>

    <div class="m-10 font-bold text-yellow-400 text-center text-lg">
        <p>This website is still under development</p>
    </div>


    <!-- <div style="text-align: center; color: whitesmoke;"> -->
        <!-- <h4>I'm a student at a computer science university</h4> -->
        <!-- <p>Hey ! I'm Rafale25, I like computer graphics and simulation</p> -->
        <!-- <p>This page highlights several of my personal software projects</p> -->
    <!-- </div> -->

    <div class="flex flex-col items-center w-full p-5 gap-7">

        <Project
            name={'Light Is Death'}
            link={'https://narchalpaulyahoofr.itch.io/light-is-death'}
            img={'./light-is-death.png'}
            description={'Game I made for the Global Game Jam 2022'}
            tags={['Python', 'Arcade', 'GlobalGameJam']}
        />
        <Project
            name='Vine mesh generation'
            link='https://github.com/Rafale25/Vine_mesh_generation'
            img='./vine.png'
            description='Vine mesh generation using geometry shader'
            tags={['Python', 'ModernGL', 'Geometry Shaders']}
        />
        <Project
            name='Slime'
            link='https://github.com/Rafale25/Slime_simulation'
            img='./slime.png'
            description='Blob simulation using compute shaders'
            tags={['Python', 'ModernGL', 'Compute Shaders']}
        />
        <Project
            name='Boids'
            link='https://github.com/Rafale25/Boids-Pyglet-Moderngl'
            img='./boids.png'
            description='Large flocking simulation using compute shaders'
            tags={['Python', 'ModernGL', 'Compute Shaders']}
        />
        <Project
            name='ScrapMechanic injection interface'
            link='https://github.com/Rafale25/python_injection_interface_SM'
            img='./sm_interface.png'
            description='Modular interface for sending custom inputs to ScrapMechanic through the Injection Mod'
            tags={['ScrapMechanic', 'Python', 'DearPygui', 'Pygame']}
        />

    </div>

    <footer class="flex justify-center items-center gap-x-6 mt-10 p-10  bg-[color:var(--background-secondary)]">
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
    </footer>

</main>

<style>
    :root {
        --primary-light: rgb(41, 219, 41);
        --primary-dark: rgb(0, 175, 0);
        --background-primary: #252830;
        --background-secondary: #202020;
        --border: #303030;
        --shadow: #191919;
    }

    main {
        font-family: monospace;
        color: var(--primary-dark);
        background-image: url("/tri.png");
        background-repeat: repeat;
    }
</style>
