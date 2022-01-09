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
        },
        {
            name: "Boids",
            link: "https://github.com/Rafale25/Boids-Pyglet-Moderngl", 
            img:"./img/boids.png",
            description: "Flocking simulation in Python with ModernGL",
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
    <Navbar color="light" light expand="xxl">
        <!-- <img src="img/logo.jpg" alt="ProfilePicture" class="logo"/>
        <p style="text-align: center">
            <span style="color:white;">Rafale25</span><span style="color:gray">#0025</span>
        </p>

        <Nav class="ms-auto" navbar>
            <NavItem>
                <NavLink class="m-0 p-0" href="https://github.com/Rafale25">
                    <img src="img/github-icon.svg" alt="githubIcon" style="width: 3em; padding: 3px"/>
                </NavLink>
            </NavItem>
        </Nav> -->
    </Navbar>

    <Container class="mt-5" style="padding-left: 10%; padding-right: 10%;">
        <h2 style="color:grey;">Projects</h2>

        {#each projects as p}
            <Card class="m-3">
                <Row class="g-0">
                    <Col md="4" style="max-height: 200px;">
                        <a href={p.link}>
                            <img src={p.img} alt={p.name} class="img-fluid rounded-start w-100 h-100" style="object-fit: cover;">
                        </a>
                    </Col>
                    <Card class="col-md-8">
                        <CardHeader>
                            <CardTitle>{p.name}</CardTitle>
                        </CardHeader>
                        <CardBody>
                            <CardText>{p.description}</CardText>
                        </CardBody>
                        <CardFooter style="">
                            <span>Python - ModernGL</span>
                        </CardFooter>
                    </Card>
                </Row>
            </Card>
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
    
</style>

<!-- 
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
-->
