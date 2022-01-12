<script lang="ts">
    import { Styles } from 'sveltestrap';
    import { fade } from 'svelte/transition';
    import {
        Container,
        Col, Row,
        Navbar, NavbarToggler, NavbarBrand, Nav, NavItem, NavLink,
        Card, CardBody, CardFooter, CardHeader, CardSubtitle, CardText, CardTitle
    } from 'sveltestrap';

    const tags = {
        "Python": "https://www.python.org/",
        "ModernGL": "https://github.com/moderngl/moderngl",
        "Pygame": "https://github.com/pygame/pygame",
        "ScrapMechanic": "https://store.steampowered.com/app/387990/Scrap_Mechanic/",
    }

    const projects = [
        {
            name: "Slime",
            link: "https://github.com/Rafale25/Slime_simulation",
            img: "https://github.com/Rafale25/Slime_simulation/raw/master/screenshots/screenshot1.png?raw=true",
            description: "Blob simulation in Python with ModernGL",
            tags: ["Python", "ModernGL"],
        },
        {
            name: "Boids",
            link: "https://github.com/Rafale25/Boids-Pyglet-Moderngl",
            img:"./img/boids.png",
            description: "Flocking simulation in Python with ModernGL",
            tags: ["Python", "ModernGL"],
        },
        {
            name: "ScrapMechanic injection interface",
            link: "https://github.com/Rafale25/python_injection_interface_SM",
            img: "",
            description: "Modular interface for sending custom inputs to ScrapMechanic through the Injection Mod",
            tags: ["ScrapMechanic", "Python", "Pygame"],
        },
    ];
</script>
<Styles/>

<main>
    <Navbar color="dark" expand="md">
        <img  class="logo mx-1" src="img/logo.jpg" alt="ProfilePicture"/>
        <h3 class="mx-3" style="color:white;">Rafale25</h3>

        <Nav class="ms-auto" navbar>
            <NavItem>
                <NavLink class="mx-1 p-0" href="https://github.com/Rafale25">
                    <img src="img/github-icon.svg" alt="githubIcon" style="width: 3em; padding: 3px"/>
                </NavLink>
            </NavItem>
        </Nav>
    </Navbar>

    <div class="text-warning text-center m-5">
        <h5>This website is still under development</h5>
    </div>

    <Container class="containerProject mt-5 mb-5 pt-3 pb-3">
        <h3 class="text-white mx-2" style="text-align: left;">Projects</h3>

        {#each projects as p}

            <!-- TODO: put the whole row in an <a></a> -->
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
                            <CardText>{p.description}</CardText>
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

    </Container>

    <footer class="bg-light text-lg-start">
        <div class="p-3" style="background-color: white;">
            <span class="text-dark">Rafale25</span><span class="text-secondary">#0025</span>
        </div>
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
    @media screen and (min-width: 600px) {
        :global(.containerProject) {
            max-width: 70% !important;
            border-radius: 8px;
            border: 4px solid #303030;
            background-color: var(--background-secondary);
            box-shadow: 5px 5px 10px 0px var(--shadow);
        }
    }

    /* small screen */
    @media screen and (max-width: 600px) {
        :global(.containerProject) {
            max-width: 100% !important;
            border-radius: 8px;
            border: 4px solid #303030;
            background-color: var(--background-secondary);
            box-shadow: 5px 5px 10px 0px var(--shadow);
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

<!-- <Row class="g-0 mx-3 my-3" style="background-color: var(--background-third);"> -->
    <!-- <Col md="4" style="max-height: 200px; overflow: hidden;"> -->
    <!-- </Col> -->
<!-- <CardTitle></CardTitle> -->
    <!-- <Card class="col-md-8" style="border-top-left-radius: 0px; border-bottom-left-radius: 0px;">
        <CardHeader>
        </CardHeader>
        <CardBody>
        </CardBody>
        <CardFooter>
        </CardFooter>
    </Card> -->
    <!-- </Row> -->
