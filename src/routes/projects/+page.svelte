<script>
	import Navbar from '$lib/components/navbar.svelte'
    import Footer from '$lib/components/footer.svelte'
</script>

<main style="--customSaturation: 0%">
    <Navbar/>

    <div class="min-h-screen w-full text-white bg-neutral-900 overflow-hidden">
        <div class="flex flex-col items-center gap-12 mx-6 my-12">

            <iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/pdIvYXba9r8?si=n7Ca4jj0ZiW2zsif&rel=0" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

        </div>
    </div>

    <Footer/>
</main>
