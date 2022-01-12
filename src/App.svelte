<script lang="ts">
    const tags = {
        'Python': 'https://www.python.org/',
        'ModernGL': 'https://github.com/moderngl/moderngl',
        'Pygame': 'https://github.com/pygame/pygame',
        'ScrapMechanic': 'https://store.steampowered.com/app/387990/Scrap_Mechanic/',
    }

    const projects = [
        {
            name: 'Slime',
            link: 'https://github.com/Rafale25/Slime_simulation',
            img: 'https://github.com/Rafale25/Slime_simulation/raw/master/screenshots/screenshot1.png?raw=true',
            description: 'Blob simulation in Python with ModernGL',
            tags: ['Python', 'ModernGL'],
        },
        {
            name: 'Boids',
            link: 'https://github.com/Rafale25/Boids-Pyglet-Moderngl',
            img:'./img/boids.png',
            description: 'Flocking simulation in Python with ModernGL',
            tags: ['Python', 'ModernGL'],
        },
        {
            name: 'ScrapMechanic injection interface',
            link: 'https://github.com/Rafale25/python_injection_interface_SM',
            img: '',
            description: 'Modular interface for sending custom inputs to ScrapMechanic through the Injection Mod',
            tags: ['ScrapMechanic', 'Python', 'Pygame'],
        },
    ];
</script>

<main>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

    <div class="navbar bg-dark">
        <div class="mx-3">
            <img  class="logo mx-1" src="img/logo.jpg" alt="ProfilePicture"/>
        </div>
        <div class="mx-4">
            <span class="text-white">Rafale25</span><span class="text-secondary">#0025</span>
        </div>
    </div>

    <div class="text-warning text-center m-5">
        <h5>This website is still under development</h5>
    </div>

    <div class="container containerProject mt-5 mb-5 pt-3 pb-3">
        <h3 class="text-white mx-2" style="text-align: left;">Projects</h3>

        {#each projects as p}
            <a href={p.link} style="text-decoration: inherit; color: inherit;">
                <div class="row g-0 mx-3 my-3" style="background-color: var(--background-third);">
                    <div class="col" style="max-height: 200px; overflow: hidden;">
                        <img src={p.img} alt={p.name} class="img-fluid preview-img">
                    </div>
                    <div class="card col-md-8">
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

    <footer style="text-align: center; padding: 20px; 0px; 40px 0px; background-color: var(--background-secondary);">
            <a href="https://github.com/Rafale25">
                <img src="img/github-icon.svg" alt="githubIcon" style="width: 3em; padding: 3px"/>
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

    :global(Nav) {
        background-image: url("/img/boids.png");
        background-repeat: no-repeat;
        background-size: cover;
        background-color: var(--background-secondary);
        /* filter: blur(5px); */
    }

    main {
        /* text-align: center; */
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
        color: var(--primary-dark);
    }

    /* large screen */
    @media screen and (min-width: 800px) {
        :global(.containerProject) {
            max-width: 70% !important;
            border-radius: 8px;
            border: 4px solid #303030;
            background-color: var(--background-secondary);
            box-shadow: 5px 5px 10px 0px var(--shadow);
            transition: max-width 0.3s, width 0.3s;
        }
    }

    /* small screen */
    @media screen and (max-width: 800px) {
        :global(.containerProject) {
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
        float: left;
        width: 50px;
        border-radius: 50%;
        border-style: solid;
        border-width: 2px;
        border-color: white;
    }

</style>
