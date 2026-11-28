<script>
    let { images } = $props()

    let i = $state(0)
    let imageViewerEnabled = $state(true);

    function increment(v) {
        i += v
        if (i < 0)
            i = images.length - 1
        if (i >= images.length)
            i = 0
    }
</script>

{#snippet NavigationArrows()}
    <button onclick={() => increment(-1)} class="absolute left-0 top-1/2 -translate-y-1/2 p-2 rounded-r-sm bg-black/50">
        <span>&lt;</span>
    </button>
    <button onclick={() => increment(1)} class="absolute right-0 top-1/2 -translate-y-1/2 p-2 rounded-l-sm bg-black/50">
        <span>&gt;</span>
    </button>
{/snippet}

<div class="relative text-white w-full h-auto aspect-video rounded-xl">
    <img class="w-full h-full m-0 object-cover" alt="" src={images[i]}/>

    {@render NavigationArrows()}

    <button
        title="Fullscreen"
        aria-label="Fullscreen"
        class="absolute cursor-pointer flex right-0 w-8 h-auto self-end {imageViewerEnabled && "hidden"}"
        onclick={() => {imageViewerEnabled = !imageViewerEnabled}}>
        <img class="m-0" alt="fullscreen icon" src="/enlarge.svg"/>
    </button>
</div>

<div class="fixed left-0 top-0 bottom-0 right-0 flex justify-center items-center text-white w-screen h-screen bg-black/75 aspect-video {!imageViewerEnabled && "hidden"}">
    <div class=" text-white w-full h-full">
        <img class="m-0 w-full h-full object-contain" alt="" src={images[i]}/>
    </div>

    <button
        title="Quit Fullscreen"
        aria-label="QuitFullscreen"
        class="fixed cursor-pointer right-0 top-0 w-8 h-8 bg-white/10 {!imageViewerEnabled && "hidden"}"
        onclick={() => {imageViewerEnabled = !imageViewerEnabled}}>
        &#66327;
    </button>

    {@render NavigationArrows()}
</div>


<style>
</style>
