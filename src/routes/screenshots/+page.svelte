<script>
	import Navbar from '$lib/components/navbar.svelte'
    import Footer from '$lib/components/footer.svelte'
    import { onMount } from 'svelte';

    export let data;

    let imageContainer, viewer, viewerImage, viewerVideo
    let videoSrc
    // let current_index = 0

    function setImage(e) {
        viewer.classList.remove('hidden')
        viewerImage.classList.remove('hidden')
        viewerImage.src = e.target.src
    }

    function setVideo(e) {
        const src = e.target.children[0].src
        viewer.classList.remove('hidden')
        viewerVideo.classList.remove('hidden')
        videoSrc = src
        viewerVideo.load()
    }

    function closeImageViewer() {
        viewer.classList.add('hidden')
        viewerVideo.classList.add('hidden')
        viewerImage.classList.add('hidden')
    }

    onMount(() => {
        closeImageViewer()
    })
</script>

<main>
    <Navbar/>

    <div class="min-h-screen text-white overflow-hidden">

        <div bind:this={imageContainer} class="w-full gap-3 space-y-3 p-6 sm:p-12
            sm:columns-2 md:columns-3 lg:columns-4 xl:columns-5 2xl:columns-6">

            {#each [...Array(2).keys()] as i}
            {#each data.screenshots as screenshot}

                <div class="flex w-full h-auto sm:hover:scale-110 transition duration-150 rounded-md overflow-hidden">

                    {#if screenshot.url.slice(-4) === '.mp4'}
                        <button on:click={setVideo} class="relative cursor-default w-full h-auto">
                            <!-- <div class="absolute flex w-full h-full justify-start items-end p-2"> -->
                                <!-- <div class="absolute flex w-full h-full justify-end items-start p-2"> -->
                            <div class="absolute flex w-full h-full justify-center items-center">
                                <img src="play-button3.svg" alt="Play Icon" class="w-14 opacity-50"/>
                            </div>
                            <video class="w-full h-auto" width="320" height="240" preload="metadata">
                                <source src="{screenshot.url}" type=video/mp4/>
                            </video>
                        </button>
                    {:else}
                        <button on:click={setImage} class="cursor-default w-full h-auto">
                            <img class="w-full h-auto object-cover" src="{screenshot.url}" alt="Hello"/>
                        </button>
                    {/if}
                </div>
            {/each}
            {/each}


            <!-- <video width="320" height="240" controls preload="metadata"> -->
            <!-- <video width="320" height="240" preload="metadata">
                <source src="https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/2022-08-28_15-34-40.mp4" type=video/mp4/>
            </video> -->

        </div>
    </div>

    <button bind:this={viewer} on:click={closeImageViewer} class="fixed flex w-full h-full justify-center items-center p-16 top-0 left-0 backdrop-brightness-[20%] cursor-default">
            <!-- <div class="absolute right-0 px-8 py-6 ">
                <button on:click={closeImageViewer} class="bg-white rounded px-4 py-2 font-bold text-lg">x</button>
            </div> -->

            <div class="flex max-w-auto max-h-full justify-center items-center">
                <img bind:this={viewerImage} class="w-3/4 object-contain" src="" alt="" on:click|stopPropagation>

                <video bind:this={viewerVideo} class="w-full h-auto" width="320" height="240" controls preload="metadata" on:click|stopPropagation>
                    <source src={videoSrc} type=video/mp4/>
                </video>
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
