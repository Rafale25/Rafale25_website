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
            description: 'Blob simulation using compute shaders',
            tags: ['Python', 'ModernGL', 'Compute Shaders'],
        },
        {
            name: 'Boids',
            link: 'https://github.com/Rafale25/Boids-Pyglet-Moderngl',
            img:'./img/boids.png',
            description: 'Large flocking simulation using compute shaders',
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
    - page for gamejams (add game "light is death")

    - add bio
    - gif when hovering projects
    - page for each project
    - project sortable by date/name/stars?
 -->

<main>
    <div class="r-navbar">
        <div class="r-navbar-container">
            <div style="text-align: center; padding: 1rem;">

                <img class="logo" src="img/logo.jpg" alt="ProfilePicture"/>

                <Hoverable let:hovering={active}>
                    <div type="" style="font-size: 20px;" on:click={clipboard}>
                        <span style="text-decoration: none; color: white;">Rafale25</span>
                        {#if active}
                            <span transition:fade={{duration: 150}} style="position: absolute; color: rgba(255,255,255,0.3);">#0025</span>
                        {/if}
                    </div>
                </Hoverable>

            </div>
        </div>
    </div>

    <div style="font-weight: 500; color:#ffc107; text-align: center; margin: 3rem;">
        <h3>This website is still under development</h3>
    </div>

    <div class="containerProject">

        {#each projects as p}
            <a href={p.link} style="text-decoration: inherit; color: inherit;">
                <div class="card">

                    <div class="preview-img-container">
                        <img src={p.img} alt={p.name} class="preview-img">
                    </div>

                    <div class="card-content">

                        <div class="card-header">
                            <span>{p.name}</span>
                        </div>

                        <div class="card-body">
                            <span>{p.description}</span>
                        </div>

                        <div class="card-footer">
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
            <img src="img/youtube-icon.svg" alt="Youtube Icon" style="width: 3em; padding: 3px"/>
        </a>
        <a href="" on:click={clipboard}>
            <img src="img/discord-icon.svg" alt="Discord Icon" style="width: 3em; padding: 3px"/>
        </a>
    </footer>

</main>

<style>
    :root {
        --primary-light: rgb(41, 219, 41);
        --primary-dark: rgb(0, 175, 0);

        --background-primary: #252830;
        --background-secondary: #202020;
        --background-third: #282828;
        --border: #303030;
        --shadow: #191919;

        --r-text: #dddddd;
    }

    main {
        font-family: monospace;
        color: var(--primary-dark);
        background-image: url("/img/tri.png");
        background-repeat: repeat;
    }

    :global(body) {
        padding: 0px;
        background-color:var(--background-primary) !important;
        font-size: 1rem;
    }

    .r-navbar {
        display: flex;
        background-color: var(--background-secondary);

        background-image: url("/img/boids-blurred.png");
        background-repeat: no-repeat;
        background-size: cover;
        background-position: center;
    }

    .r-navbar-container {
        display: flex;
        justify-content: center;
        width: 100%;
        height: 100%;
    }

    .r-footer {
        margin-top: 3rem;
        padding: 2rem;
        text-align: center;
        background-color: var(--background-secondary);
    }

    :global(.containerProject) {
        margin: 3rem auto 0px auto;
        padding: 0.75rem;

        max-width: 70%;
        border-radius: 8px;
        border: 4px solid #303030;
        background-color: var(--background-secondary);
        box-shadow: 5px 5px 10px 0px var(--shadow);
        transition: max-width 0.3s, width 0.3s;
    }

    .card {
        display: flex;
        margin: 1rem;
        background-color: transparent;
        box-shadow: 5px 5px 10px 0px var(--shadow);
        border-radius: 0px 10px 10px 0px;
        overflow: hidden;
    }

    .card-content {
        background-color: transparent;
        display: flex;
        flex-direction: column;
        min-height: 100%;
        width: 100%;
    }

    .card-header {
        background-color: var(--border);
        font-weight: bold;
        font-size: 1.15em;
        padding: 0.5rem 1rem;
    }
    .card:hover > .card-content > .card-header {
        color: var(--primary-light);
    }

    .card-body {
        height: 100%;
        padding: 1rem;
        background-color: var(--background-third);
        color: var(--r-text);
    }

    .card-footer {
        display: flex;
        flex-direction: row;
        flex-wrap: wrap;
        padding: 0.5rem 0.75rem;
        background-color: var(--border);
    }

    .preview-img-container {
        min-height: 200px;
        max-height: 200px;
        min-width: 200px;
        max-width: 30%;
        border-radius: 10px 0px 0px 10px;
        overflow: hidden;
    }

    .preview-img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.4s;
        backface-visibility: hidden;
        transform: translateZ(0);
    }
    .card:hover > .preview-img-container > .preview-img {
        transform: scale(1.1);
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
        width: 70px;
        border-radius: 50%;
        border-style: solid;
        border-width: 2px;
        border-color: var(--background-third);
    }

    /* large screen */
    @media screen and (min-width: 700px) {
        :global(.containerProject) {
            max-width: 60%;
        }

        .card {
            flex-direction: row;
        }
    }

    /* small screen */
    @media screen and (max-width: 700px) {
        :global(.containerProject) {
            max-width: 100%;
        }

        .card {
            flex-direction: column;
            border-radius: 0px 0px 10px 10px;
        }

        .preview-img-container {
            height: 200px; /* WTF */
            max-width: 100%;
            border-radius: 10px 10px 0px 0px;
        }

        .preview-img {
            /* width: 100%; */
            /* width: auto; */
            max-height: 100%;
            min-height: 100%;
        }
    }

</style>
