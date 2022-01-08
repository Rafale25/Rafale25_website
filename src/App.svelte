<script lang="ts">	
	import { Styles, Button, Icon } from 'sveltestrap';
	import {
		Container,
		Col,
		Row,
		Collapse,
		Navbar,
		NavbarToggler,
		NavbarBrand,
		Nav,
		NavItem,
		NavLink
	} from 'sveltestrap';

	let projects = [
		{
			name: "Slimes",
			link: "https://github.com/Rafale25/Slime_simulation",
			img: "https://github.com/Rafale25/Slime_simulation/raw/master/screenshots/screenshot1.png?raw=true"
		},
		{
			name: "Boids",
			link: "https://github.com/Rafale25/Boids-Pyglet-Moderngl", 
			img:"./img/boids.png"
		},
		{
			name: "ScrapMechanic injection interface",
			link: "https://github.com/Rafale25/python_injection_interface_SM", 
			img: ""
		},
	];

</script>
<Styles icons={false}/>

<main>
	<Navbar color="light" light expand="md">
		
	</Navbar>


	<Container>
		<Col class=".col-sm-1 rounded2 .col-md-6 .offset-md-3">
			<h1 class="text-primary">TEXT</h1>
		</Col>
	</Container>
<!-- 	
	<div class="navigation-bar">
		<div class="navigation-container">
			<img src="img/logo.jpg" alt="ProfilePicture" class="logo">
			<p><span style="color:white;">Rafale25</span><span style="color:gray">#0025</span></p>
	
			<a href="#">Home</a>
			<a href="#">Projects</a>
			<a href="#">About</a>
			<a href="#">Services</a>
			<a href="#">Get in Touch</a>
		</div>
	</div>

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
		background-color:rgb(5, 0, 19) !important;
	}

	main {
		text-align: center;
	}	

	.logo {
		display: block;
		margin-left: auto;
		margin-right: auto;
		width: 50px;
		border-radius: 50%;
		border-style: solid;
		border-color: #00a129;
		border-width: 2px;
	}

	.projectPicture {
		width: 200px;
		height: 200px;
		object-fit: cover; /* crop the img if to large*/
		border-radius: 5%;
		margin: 5px;
		/* border-style: solid;
		border-color: black; */
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