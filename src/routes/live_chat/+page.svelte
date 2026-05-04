
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
        console.log('sendMessage')
        if (ws === null)
            return

        ws.send(inputField.value)
        inputField.value = ''
    }

</script>

<main>
    <Navbar/>

    <div class="border border-white p-4 overflow-scroll h-96">
        <!-- {#each { length: 12 }, rank} -->
        {#each messages as msg}
            <p class="text-white">{msg}</p>
        {/each}
        <!-- {/each} -->
    </div>

    <div class="m-2">
        <!-- <textarea bind:this={inputField}></textarea> -->
        <input type='text' class="min-w-64" bind:this={inputField} onkeydown={(e) => { if (e.key === 'Enter') sendMessage() } }/>

        <button class="bg-white px-2 py-0 bg-gray-500 rounded-sm" onclick={sendMessage} title='send message' >
            send
        </button>
    </div>
</main>

<style>
</style>
