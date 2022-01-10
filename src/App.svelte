<script lang="ts">
    import { Styles, Button, Icon } from 'sveltestrap';
    import {
        Container,
        Col, Row,
        Navbar, NavbarToggler, NavbarBrand, Nav, NavItem, NavLink,
        Card, CardBody, CardFooter, CardHeader, CardSubtitle, CardText, CardTitle
    } from 'sveltestrap';

    let projects = [
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
    <Navbar color="light" light expand="md">
        <img  class="logo mx-1" src="img/logo.jpg" alt="ProfilePicture"/>
        <span class="mx-3" style="color:white;">Rafale25</span>

        <Nav class="ms-auto" navbar>
            <NavItem>
                <NavLink class="mx-1 p-0" href="https://github.com/Rafale25">
                    <img src="img/github-icon.svg" alt="githubIcon" style="width: 3em; padding: 3px"/>
                </NavLink>
            </NavItem>
        </Nav>
    </Navbar>

    <Container class="containerProject mt-5 mb-5 pt-3 pb-3">
        <h3 class="text-secondary">Projects</h3>

        {#each projects as p}
            <Row class="g-0 m-3">
                <Col md="4" style="max-height: 200px;">
                    <a href={p.link}>
                        <img src={p.img} alt={p.name} class="img-fluid rounded-start w-100 h-100" style="object-fit: cover; background-color: whitesmoke;">
                    </a>
                </Col>
                <Card class="col-md-8 p-0 m-0" style="border-top-left-radius: 0px; border-bottom-left-radius: 0px">
                    <CardHeader>
                        <CardTitle>{p.name}</CardTitle>
                    </CardHeader>
                    <CardBody>
                        <CardText>{p.description}</CardText>
                    </CardBody>
                    <CardFooter>
                        <CardText>{p.tags}</CardText>
                    </CardFooter>
                </Card>
            </Row>
        {/each}
    </Container>

    <footer class="bg-light text-lg-start">
        <div class="p-3" style="background-color: white;">
            <span class="text-dark">Rafale25</span><span class="text-secondary">#0025</span>
        </div>
      </footer>

</main>


<style>
    :global(body) {
        padding: 0px;
        background-color:rgb(5, 0, 19) !important;
        /* background-color:rgb(50, 50, 50) !important; */
    }

    :global(Nav) {
        background-image: url("/img/boids.png");
        background-repeat: no-repeat;
        background-size: cover;
    }

    main {
        text-align: center;
    }

    :global(.containerProject) {
        border-radius: 8px;
        background-color:white;
        padding-left: 5%;
        padding-right: 5%;
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

