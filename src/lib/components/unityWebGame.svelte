<script>
    const { url } = $props();

    let canvas
    let unityInstance

    let is_loading = $state(false)
    let loading_progress = $state(0)
    let loaded = $state(false)
    let started = $state(false)

    function goFullscreen() {
        if (canvas.requestFullscreen) {
            canvas.requestFullscreen()
        } else if (canvas.webkitRequestFullscreen) {
            canvas.webkitRequestFullscreen() // Safari
        }

        // Optional: notify Unity
        if (unityInstance?.SetFullscreen) {
            unityInstance.SetFullscreen(1)
        }
    }

    function start()
    {
        if (started) return
        started = true

        const buildUrl = `${url}/Build`
        // const buildUrl = "/unity/Build"
        const loaderUrl = `${buildUrl}/Build.loader.js`

        const config = {
            dataUrl: `${buildUrl}/Build.data.unityweb`,
            frameworkUrl: `${buildUrl}/Build.framework.js.unityweb`,
            codeUrl: `${buildUrl}/Build.wasm.unityweb`,
            streamingAssetsUrl: "StreamingAssets",
            companyName: "DefaultCompany",
            productName: "Micro-Jam-042-Frogs",
            productVersion: "1.0",
            showBanner: (msg, type) => {
                console.warn(`${type.toUpperCase()}: ${msg}`)
            },
        }

        const script = document.createElement("script")
        script.src = loaderUrl
        script.onload = () => {
            createUnityInstance(canvas, config, (progress) => {
                const percentage = Math.floor(progress * 100)
                console.log(`Loading: ${percentage}%`)
                loading_progress = percentage
            })
                .then((instance) => {
                    unityInstance = instance
                    loaded = true
                    is_loading = false
                    console.log("Unity loaded")
                })
                .catch((message) => {
                    console.error(message)
                })
        }
        document.body.appendChild(script)

        is_loading = true
    }
</script>

<div id="unity-container" class="flex flex-row justify-center">
    <canvas id="unity-canvas" class="flex bg-white w-full {!loaded && "hidden"}" bind:this={canvas}></canvas>

    <div class="flex items-center justify-center  bg-neutral-800 w-full w-[960px] h-[480px] {loaded && "hidden"}">
        <button
            title="Play"
            aria-label="Play"
            class="flex text-xl text-white font-bold bg-blue-700 rounded-sm py-4 px-6 {started && 'hidden'}"
            onclick={start}>
            Run game
        </button>

        <div class="flex flex-row gap-2 items-center justify-center {!is_loading && "hidden"}">
            <progress class="" value={loading_progress} max="100"></progress>
            <span class="text-white">{loading_progress}%</span>
        </div>
    </div>

    <button
        title="Fullscreen"
        aria-label="Fullscreen"
        class="absolute right-0 flex self-end min-w-8 min-h-8 w-8 h-8 {!loaded && "hidden"}"
        onclick={goFullscreen}><img alt="fullscreen icon" src="enlarge.svg"/>
    </button>
</div>

<style>
    #unity-container {
        background: #000;
        position: relative;
        user-select: none;
    }

    canvas {
        width: 960px;
        height: 480px;
        user-select: none;
    }

    :global(body) {
        background-color: hsl(0, 0%, 4%);
    }
</style>
