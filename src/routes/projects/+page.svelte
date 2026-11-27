<script>
	import Navbar from '#lib/components/navbar.svelte'
    import Footer from '#lib/components/footer.svelte'

    let { params } = $props();

    // Import all Markdown files as compiled Svelte components
    const blogs = import.meta.glob('/src/content/*.md', {
        eager: true,
        query: '?url',
        import: 'default'
    });

    const filenames = Object.keys(blogs).map(path =>
        path.split('/').pop().replace(/\.[^/.]+$/, '')
    );

    console.log(filenames);

</script>

<main style="--customSaturation: 0%">
    <Navbar/>

    <div class="min-h-screen w-full text-white bg-neutral-900 overflow-hidden flex flex-col items-center">
        <div class="flex flex-col gap-2 px-16 w-full md:w-[750px] lg:w-[1000px] m-8">

            {#each filenames as filename}
                <a class="underline" href="/projects/{filename}">{filename}</a>
            {/each}

        </div>
    </div>

    <Footer/>
</main>
