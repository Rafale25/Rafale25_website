<script lang="ts">
    import { fade } from 'svelte/transition';
    import Hoverable from './Hoverable.svelte';

    const tags = {
        'Python': 'https://www.python.org/',
        'ModernGL': 'https://github.com/moderngl/moderngl',
        'Pygame': 'https://github.com/pygame/pygame',
        'ScrapMechanic': 'https://store.steampowered.com/app/387990/Scrap_Mechanic/',
        'Compute Shaders': 'https://www.khronos.org/opengl/wiki/Compute_Shader',
        'Geometry Shaders': 'https://www.khronos.org/opengl/wiki/Geometry_Shader',
    }

    const projects = [
        {
            name: 'Vine mesh generation',
            link: 'https://github.com/Rafale25/Vine_mesh_generation',
            img: './img/vine.png',
            description: 'Vine mesh generation using geometry shader',
            tags: ['Python', 'ModernGL', 'Geometry Shaders'],
        },
        {
            name: 'Slime',
            link: 'https://github.com/Rafale25/Slime_simulation',
            img: 'https://github.com/Rafale25/Slime_simulation/raw/master/screenshots/screenshot1.png?raw=true',
            description: 'Blob simulation',
            tags: ['Python', 'ModernGL', 'Compute Shaders'],
        },
        {
            name: 'Boids',
            link: 'https://github.com/Rafale25/Boids-Pyglet-Moderngl',
            img:'./img/boids.png',
            description: 'Large flocking simulation with compute shaders',
            tags: ['Python', 'ModernGL', 'Compute Shaders'],
        },
        {
            name: 'ScrapMechanic injection interface',
            link: 'https://github.com/Rafale25/python_injection_interface_SM',
            img: './img/sm_interface.png',
            description: 'Modular interface for sending custom inputs to ScrapMechanic through the Injection Mod',
            tags: ['ScrapMechanic', 'Python', 'DearPygui', 'Pygame'],
        },
    ];

    const discord_name = "Rafale25#0025";

    function clipboard(e) {
        navigator.clipboard.writeText(discord_name);
        alert("Discord tag copied in the clipboard: " + discord_name);
    }
</script>

<!--
primary:
    - replace card with normal css
        (because i can't get card to resize with its preview-image,
        card's right column not taking full width on right sider with large screen)

secondary:
    - add bio
    - gif when hovering projects
    - page for each project
    - project sortable by date/name/stars?
 -->

<main>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

    <div class="r-navbar">
        <div class="r-navbar-container">
            <div style="text-align: center; padding: 1rem;">

                <img  class="logo mx-2" src="img/logo.jpg" alt="ProfilePicture"/>

                <Hoverable let:hovering={active}>
                    <div style="font-size: 20px;" on:click={clipboard}>
                        <span style="text-decoration: none; color: white;">Rafale25</span>
                        {#if active}
                        <span transition:fade={{duration: 150}} style="position: absolute; color: rgba(255,255,255,0.3);">#0025</span>
                        {/if}
                    </div>
                </Hoverable>

            </div>
        </div>
    </div>

    <!-- <div class="text-warning text-center m-5">
        <h5>This website is still under development</h5>
    </div> -->

    <!-- <a href="resume.html">Resume</a> -->

    <div class="container containerProject">

        {#each projects as p}
            <a href={p.link} style="text-decoration: inherit; color: inherit;">
                <div class="row g-0 mx-3 my-3" style="background-color: transparent;">
                    <!-- <div class="col" style="overflow: hidden;"> -->
                    <!-- <div class="col" style="width:20vw; height:20vw; max-width: 200px; max-height: 200px; overflow: hidden;"> -->
                    <div class="col" style="width:20vw; height:20vw; max-height: 200px; overflow: hidden;">
                        <img src={p.img} alt={p.name} class="img-fluid preview-img">
                    </div>
                    <div class="col-md-8 card">
                        <div class="card-header">
                            <span>{p.name}</span>
                        </div>
                        <div class="card-body">
                            <p>{p.description}</p>
                        </div>
                        <div class="card-footer" style="display: flex; flex-direction: row;">
                            {#each p.tags as tag}
                                <a href={tags[tag]} style="text-decoration: none;">
                                    <span class="tag">{tag}</span>
                                </a>
                            {/each}

                        </div>
                    </div>
                </div>
            </a>
        {/each}
    </div>

    <footer class="r-footer">
        <a href="https://github.com/Rafale25">
            <img src="img/github-icon.svg" alt="Github Icon" style="width: 3em; padding: 3px"/>
        </a>
        <a href="https://www.youtube.com/channel/UCjJYtSy8dMGJkMVrBnwaWSA">
            <img src="img/youtube2.svg" alt="Youtube Icon" style="width: 3em; padding: 3px"/>
        </a>
        <a href="" on:click={clipboard}>
            <img src="img/discord-icon.svg" alt="Discord Icon" style="width: 3em; padding: 3px"/>
        </a>
    </footer>

</main>

<style>
    :root {
        --primary-light: rgb(41, 219, 41);
        --primary-dark: rgb(0, 146, 0);

        --background-primary: #252830;
        --background-secondary: #202020;
        --background-third: #282828;
        --border: #303030;
        --shadow: #191919;
    }

    :global(body) {
        padding: 0px;
        background-color:var(--background-primary) !important;
    }

    .r-navbar {
        display: flex;
        background-color: var(--background-secondary);

        background-image: url("/img/boids.png");
        background-repeat: no-repeat;
        background-size: cover;
        background-position: center;
        background-size: 100%;
    }
    .r-navbar-container {
        display: flex;
        justify-content: center;
        width: 100%;
        height: 100%;
        backdrop-filter: blur(5px);
        -webkit-backdrop-filter: blur(5px);
    }

    .r-footer {
        margin-top: 3rem;
        padding: 2rem;
        text-align: center;
        background-color: var(--background-secondary);
    }

    main {
        /* font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif; */
        font-family: monospace;
        color: var(--primary-dark);
        background-image: url("/img/tri.png");
        background-repeat: repeat;
    }

    /* large screen */
    @media screen and (min-width: 700px) {
        :global(.containerProject) {
            margin-top: 3rem;
            padding-top: 0.75rem;
            padding-bottom: 0.75rem;
            max-width: 70% !important;
            border-radius: 8px;
            border: 4px solid #303030;
            background-color: var(--background-secondary);
            box-shadow: 5px 5px 10px 0px var(--shadow);
            transition: max-width 0.3s, width 0.3s;
        }
    }

    /* small screen */
    @media screen and (max-width: 700px) {
        :global(.containerProject) {
            margin-top: 3rem;
            max-width: 100% !important;
            border-radius: 8px;
            border: 4px solid #303030;
            background-color: var(--background-secondary);
            box-shadow: 5px 5px 10px 0px var(--shadow);
            transition: max-width 0.3s, width 0.3s;
        }
    }

    .card {
        background-color: transparent;
        box-shadow: 5px 5px 10px 0px var(--shadow);
    }
    .card-header {
        background-color: var(--border);
        border-radius: 0px 10px 0px 0px !important;
        font-weight: bold;
        font-size: 1.15em;
    }
    .card-body {
        background-color: var(--background-third);
        border-radius: 0px 0px 0px 0px !important;
        color: var(--primary-dark);
    }
    .card-footer {
        background-color: var(--border);
        border-radius: 0px 0px 10px 0px !important;
        flex-wrap: wrap !important;
    }

    .preview-img {
        object-fit: cover;
        border-radius: 10px 0px 0px 10px;
        width: 100%;
        height: 100%;
        transition: transform 0.4s;
        backface-visibility: hidden;
        transform: translateZ(0);
    }

    .row:hover > .col > .preview-img {
        transform: scale(1.1);
	}

    .row:hover > .card > .card-header {
        color: var(--primary-light);
    }

    .tag {
        background-color: var(--primary-light);
        color: black;
        margin: 0px 1px 0px 1px;
        padding: 0px 6px 0px 6px;
        border: 1px solid;
        border-radius: 10px;
    }
    .tag:hover {
        filter: saturate(200%);
    }

    .logo {
        width: 75px;
        border-radius: 50%;
        border-style: solid;
        border-width: 2px;
        border-color: var(--background-third);
    }

</style>
