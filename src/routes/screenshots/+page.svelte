<script>
	import Navbar from '$lib/components/navbar.svelte'
    import Footer from '$lib/components/footer.svelte'
    import { afterUpdate } from 'svelte';

    export let data;

    let imageContainer, imageViewer, imageViewerImage

    // let current_index = 0

    afterUpdate(() => {
    })

    function setImage(e) {
        if (e == null) return
        imageViewer.classList.remove('hidden')
        imageViewerImage.src = e.target.src
    }

    function closeImageViewer() {
        imageViewer.classList.add('hidden')
    }

</script>

<main>
    <Navbar/>

    <div class="min-h-screen text-white overflow-hidden">

        <div bind:this={imageContainer} class="flex w-full p-12 justify-evenly items-center flex-wrap gap-4">

            {#each data.screenshots as screenshot}

                <div class="max-w-80 h-auto sm:hover:scale-125 transition duration-150">
                    <button on:click={setImage} class="cursor-default">
                        {#if screenshot.url.slice(-4) === '.mp4'}
                            <!-- <video width="320" height="240" preload="metadata">
                                <source src="{screenshot.url}" type=video/mp4/>
                            </video> -->
                        {:else}
                            <img class="object-cover" src="{screenshot.url}" alt="Hello"/>
                        {/if}

                    </button>
                </div>
            {/each}

            <!-- Invisible divs to make last item stick to the left when using justify-evenly -->
            {#each [...Array(5).keys()] as i}
                <div class="w-64 h-0 invisible"/>
            {/each}

            <!-- <video width="320" height="240" controls preload="metadata"> -->
            <!-- <video width="320" height="240" preload="metadata">
                <source src="https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/2022-08-28_15-34-40.mp4" type=video/mp4/>
            </video> -->

        </div>
    </div>

    <button bind:this={imageViewer} on:click={closeImageViewer} class="hidden fixed w-full h-full top-0 left-0 backdrop-brightness-[10%] cursor-default">
        <!-- <div class="absolute right-0 px-8 py-6 ">
            <button on:click={closeImageViewer} class="bg-white rounded px-4 py-2 font-bold text-lg">x</button>
        </div> -->
        <div class="flex w-full h-full justify-center items-center p-16">
            <img bind:this={imageViewerImage} class="max-w-full max-h-full" src="" alt="">
        </div>
    </button>

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
