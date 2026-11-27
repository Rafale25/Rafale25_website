<script>
	import Navbar from '#lib/components/navbar.svelte'
    import Footer from '#lib/components/footer.svelte'

    let { params } = $props();

    const games = [
        'Bleh',
        'BlehPathOfPain',
    ]
</script>

<main style="--customSaturation: 0%">
    <Navbar/>

    <div class="min-h-screen w-full text-white bg-neutral-900 overflow-hidden flex flex-col items-center">
        <div class="flex flex-col gap-2 px-16 w-full md:w-[750px] lg:w-[1000px] m-8">

            {#each games as game}
                <a class="underline" href="/games/{game}">{game}</a>
            {/each}

        </div>
    </div>

    <Footer/>
</main>
