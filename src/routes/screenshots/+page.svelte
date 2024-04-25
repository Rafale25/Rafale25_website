<script>
	import Navbar from '$lib/components/navbar.svelte'
    import Footer from '$lib/components/footer.svelte'
</script>

<!--
    - gif when hovering projects
    - page for each project
-->

<main>
    <Navbar/>

    <div class="min-h-screen">
    </div>

    <Footer/>
</main>

<style>
    main {
        font-family: monospace;
        background-repeat: repeat;
        background: center no-repeat center;
        background-image: url("/tri.png");
    }
</style>
