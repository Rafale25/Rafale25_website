
<script>
    import Navbar from '$lib/components/navbar.svelte'
    import Footer from '$lib/components/footer.svelte'
    import { onMount } from 'svelte'
    import { PUBLIC_LIVECHAT_URL } from '$env/static/public'

    let messages = $state([])
    let inputField

    let ws = null

    onMount(() => {
        const wsUri = PUBLIC_LIVECHAT_URL

        ws = new WebSocket(wsUri)

        ws.addEventListener('open', () => {
            console.log('CONNECTED')
        })

        ws.addEventListener('error', (e) => {
            console.log('ERROR')
        })

        ws.addEventListener('message', (e) => {
            const msg = JSON.parse(e.data)
            messages.push(msg)
        })

        // websocket.send(JSON.stringify(message));
    })

    function sendMessage() {
        console.log('sendMessage')
        if (ws === null)
            return

        ws.send(inputField.value)
        inputField.value = ''
    }

    function formatDate(date_str) {
        const date = new Date(date_str)
        const language = 'fr-FR' // navigator.language
        return date.toLocaleTimeString(language, {
            hour: '2-digit',
            minute:'2-digit'
        });
    }

</script>

<main>
    <Navbar/>

    <div class="border border-white p-4 overflow-scroll h-96">
        <!-- {#each { length: 12 }, rank} -->
        {#each messages as msg}
            <p class="text-white">({formatDate(msg.date)}) {msg.author}: {msg.text}</p>
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
