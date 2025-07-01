<script>
  import { onMount } from 'svelte';

  let canvas;
  let unityInstance;

  function goFullscreen() {
    if (canvas.requestFullscreen) {
      canvas.requestFullscreen();
    } else if (canvas.webkitRequestFullscreen) {
      canvas.webkitRequestFullscreen(); // Safari
    }

    // Optional: notify Unity
    if (unityInstance?.SetFullscreen) {
      unityInstance.SetFullscreen(1);
    }
  }

  onMount(() => {
    const buildUrl = "/unity/Build";
    const loaderUrl = `${buildUrl}/Build.loader.js`;

    const config = {
      dataUrl: `${buildUrl}/Build.data.unityweb`,
      frameworkUrl: `${buildUrl}/Build.framework.js.unityweb`,
      codeUrl: `${buildUrl}/Build.wasm.unityweb`,
      streamingAssetsUrl: "StreamingAssets",
      companyName: "DefaultCompany",
      productName: "Micro-Jam-042-Frogs",
      productVersion: "1.0",
      showBanner: (msg, type) => {
        console.warn(`${type.toUpperCase()}: ${msg}`);
      },
    };

    const script = document.createElement("script");
    script.src = loaderUrl;
    script.onload = () => {
      createUnityInstance(canvas, config, (progress) => {
        console.log(`Loading: ${Math.floor(progress * 100)}%`);
      }).then((instance) => {
        unityInstance = instance;
        console.log("Unity loaded");
      }).catch((message) => {
        console.error(message);
      });
    };
    document.body.appendChild(script);
  });
</script>

<div id="unity-container" class="flex flex-row justify-center">
  <canvas id="unity-canvas" class="flex bg-white w-full" bind:this={canvas}></canvas>
  <button title="Fullscreen" aria-label="Fullscreen" class="flex self-end min-w-8 min-h-8 w-8 h-8" on:click={goFullscreen}><img src="https://itch.io/static/images/enlarge.svg?1751209071"></button>
</div>

<style>
  #unity-container {
    background: #000;
    position: relative;
  }

  canvas {
    width: 960px;
    height: 480px;
    user-select: none;
  }


:global(body) {
    background-color: hsl(0, 0%, 2%);
}

</style>
