<script>
	import Navbar from '$lib/components/navbar.svelte'
    import Footer from '$lib/components/footer.svelte'
    import { browser } from '$app/environment'

    export let data;

    // binded
    let viewer, viewerVideo, viewerVideoContainer, viewerImageContainer
    let videoSrc, imageSrc
    // --

    let videoDurations = []
    let videoDurationElement = []
    // let current_index = 0

    function toHHMMSS(timeInseconds) {
        const sec_num = Math.ceil(timeInseconds) // ceil of seconds
        let hours   = Math.floor(sec_num / 3600)
        let minutes = Math.floor((sec_num - (hours * 3600)) / 60)
        let seconds = sec_num - (hours * 3600) - (minutes * 60)

        // if (hours   < 10) {hours   = "0"+hours}
        // if (minutes < 10) {minutes = "0"+minutes}
        if (seconds < 10) {seconds = "0"+seconds}

        let result = ''
        if (hours > 0) result += hours + ':'
        result += minutes + ':' + seconds

        return result
    }

    function setImage(e) {
        viewerImageContainer.classList.remove('hidden')
        viewer.classList.remove('hidden')
        imageSrc = e.target.src
    }

    function setVideo(url) {
        viewerVideoContainer.classList.remove('hidden')
        viewer.classList.remove('hidden')

        videoSrc = url
        viewerVideo.load()
    }

    function closeImageViewer() {
        viewer.classList.add('hidden')
        viewerVideoContainer.classList.add('hidden')
        viewerImageContainer.classList.add('hidden')
    }

    function setVideoLength(element, index)
    {
        const duration = element.target.duration
        videoDurations[index] = toHHMMSS(duration)
        videoDurationElement[index].classList.remove('hidden')
    }
</script>

<main>
    <Navbar/>

    <div class="min-h-screen text-white overflow-hidden">

        <div class="w-full gap-3 space-y-3 p-6 sm:p-12
            sm:columns-2 md:columns-3 lg:columns-4 xl:columns-5 2xl:columns-6">

            <!-- {#each [...Array(1).keys()] as _} -->
            {#each data.screenshots as screenshot, i (i)}

                <div class="flex w-full h-auto sm:hover:scale-110 transition-all duration-150 rounded-md overflow-hidden">
                    {#if screenshot.url.slice(-4) === '.mp4'}
                        <button on:click={() => setVideo(screenshot.url)} class="relative cursor-default w-full h-auto">
                            <div class="absolute flex w-full h-full justify-center items-center">
                                <img src="play-button.svg" alt="Play Icon" class="w-14 opacity-50"/>
                            </div>
                            <div bind:this={videoDurationElement[i]} class="hidden absolute flex w-full h-full justify-end items-end">
                                <span class="m-2 px-1 rounded-sm text-sm backdrop-brightness-50">{videoDurations[i]}</span>
                            </div>
                            {#if browser}
                                <video on:loadedmetadata={e => setVideoLength(e, i)} class="w-full h-auto" width="320" height="240" preload="metadata">
                                    <source src="{screenshot.url}" type=video/mp4/>
                                </video>
                            {:else}
                                <div class="w-full h-36 bg-black"/>
                            {/if}
                        </button>
                    {:else}
                        <button on:click={setImage} class="cursor-default w-full h-auto">
                            <img class="w-full h-auto object-cover" src="{screenshot.url}" alt="Hello"/>
                        </button>
                    {/if}
                </div>
            {/each}
            <!-- {/each} -->

        </div>
    </div>

    <button bind:this={viewer} on:click={closeImageViewer} class="hidden fixed flex w-full h-full justify-center items-center sm:p-16 top-0 left-0 cursor-default">
        <!-- <div class="absolute right-0 top-0 px-8 py-6 ">
            <button on:click={closeImageViewer} class="bg-white rounded px-4 py-2 font-bold text-lg">x</button>
        </div> -->
        <div class="absolute top-0 left-0 w-screen h-screen -z-10 bg-black opacity-80"/>

        <div bind:this={viewerImageContainer} class="hidden flex w-auto h-full justify-center items-center">
            <img class="flex w-full h-full object-contain" src={imageSrc} alt="">
        </div>

        <div bind:this={viewerVideoContainer} class="hidden flex w-full h-full justify-center items-center">
            <video bind:this={viewerVideo} class="flex w-full h-auto max-h-full" controls preload="metadata" on:click|stopPropagation>
                <source src={videoSrc} type=video/mp4/>
            </video>
        </div>
    </button>

    <Footer/>
</main>
