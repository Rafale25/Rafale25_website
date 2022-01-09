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
            name: "Slimes",
            link: "https://github.com/Rafale25/Slime_simulation",
            img: "https://github.com/Rafale25/Slime_simulation/raw/master/screenshots/screenshot1.png?raw=true",
            description: "Blob simulation in Python with ModernGL",
        },
        {
            name: "Boids",
            link: "https://github.com/Rafale25/Boids-Pyglet-Moderngl", 
            img:"./img/boids.png",
            description: "Flock simulation in Python with ModernGL",
        },
        {
            name: "ScrapMechanic injection interface",
            link: "https://github.com/Rafale25/python_injection_interface_SM", 
            img: "./img/boids.png",
            description: "Modular interface for sending custom inputs to ScrapMechanic through Injection Mod",
        },
    ];

</script>
<Styles/>

<main>
    <Navbar color="light" light expand="md">
        <img src="img/logo.jpg" alt="ProfilePicture" class="logo"/>
        <p style="text-align: center">
            <span style="color:white;">Rafale25</span><span style="color:gray">#0025</span>
        </p>

        <Nav class="ms-auto" navbar>
            <NavItem>
                <NavLink class="m-0 p-0" href="https://github.com/Rafale25">
                    <img src="img/github-icon.svg" alt="githubIcon" style="width: 3em; padding: 3px"/>
                </NavLink>
            </NavItem>
        </Nav>
    </Navbar>

    <Container style="padding: 5em;">
        {#each projects as p}
            <div class="card mb-3" style="max-height: 200px;">
                <div class="row g-0">
                    <div class="col-md-4">
                        <img src={p.img} class="img-fluid rounded-start" alt={p.name}>
                    </div>
                    <div class="col-md-8">
                        <div class="card-body">
                            <h5 class="card-title">{p.name}</h5>
                            <p class="card-text">{p.description}</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- <Card class="mb-3">
                <CardHeader>
                    <CardTitle>{p.name}</CardTitle>
                </CardHeader>
                <CardBody>
                    <CardText>{p.description}</CardText>
                </CardBody>
            </Card>
            -->

            <!-- {#if p.img != ""} -->
            <!-- <Row cols={3}>
                <Col></Col>
                <Col style="background-color: white;">
                    <p class="text-white">{p.name}</p>
                    <p class="text-muted">{p.description}</p>
                </Col>
                <Col>
                    <a href={p.link}>
                        <img alt={p.name} src={p.img} class="projectPicture">
                    </a>
                </Col>
            </Row> -->
            <!-- {/if} -->
        {/each}
    </Container>

    <!-- 
    <div class="row">

        <div class="column">
            <h2 style="color:grey">Projects</h2>
            
            <div class="container">
                {#each projects as p}
                    {#if p.img != ""}
                        <a href={p.link}>
                            <img alt={p.name} src={p.img} class="projectPicture">
                        </a>
                    {:else}
                        <a href={p.link}>
                            <img alt={p.name} src="https://i.imgflip.com/430zkq.png" class="projectPicture">
                        </a>
                    {/if}
                {/each}
            </div>
        </div>
    </div>
    -->
        
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

    .logo {
        float: left;
        width: 50px;
        border-radius: 50%;
        border-style: solid;
        border-width: 2px;
        border-color: white;
    }

    .projectPicture {
        width: 200px;
        height: 200px;
        object-fit: cover; /* crop the img if to large*/
        border-radius: 5px;
        margin: 5px;
        /* border-style: solid; */
        /* border-color: black; */
        /* border-width: 2px; */
    }
    

    .row {
        display: flex;
    }

    .column {
        flex: 100%;
    }

</style>

<!--
.container {
    width: 100%;
    /* height: 500px; */
    background-color:#ccc;

    display: flex;
    flex-flow: row wrap;
    justify-content: space-between;
    align-items: center;
}
-->