
<script>
	import Navbar from '$lib/components/navbar.svelte'
    import Footer from '$lib/components/footer.svelte'
	import { onMount } from 'svelte'
    import { PUBLIC_VPS_IP, PUBLIC_VPS_LIVECHAT_PORT } from '$env/static/public'

    let messages = $state([])
    let inputField

    let ws = null

	onMount(() => {
        const wsUri = `ws://${PUBLIC_VPS_IP}:${PUBLIC_VPS_LIVECHAT_PORT}`
        ws = new WebSocket(wsUri)

        ws.addEventListener("open", () => {
            console.log("CONNECTED")
        })

        ws.addEventListener("error", (e) => {
            console.log(`ERROR`)
        })

        ws.addEventListener("message", (e) => {
            messages.push(e.data)
        })

        // const message = {
        //     iteration: counter,
        //     content: "ping",
        // };
        // websocket.send(JSON.stringify(message));
	})

    function sendMessage() {
        if (ws === null)
            return

        ws.send(inputField.value)
        inputField.value = ''
    }

</script>

<main>
    <Navbar/>

    <div class="border border-white p-4">
        {#each messages as msg}
            <p class="text-white">{msg}</p>
        {/each}
    </div>

    <textarea bind:this={inputField}></textarea>
    <button title='send message' class="bg-white w-8 h-6" onclick={sendMessage}></button>
</main>

<style>
</style>
