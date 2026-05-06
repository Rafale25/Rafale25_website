
<script>
    import Navbar from '$lib/components/navbar.svelte'
    import Footer from '$lib/components/footer.svelte'
    import { mousePosition } from '$lib/stores/mousePosition.svelte.js';
    import { onMount } from 'svelte'
    import { PUBLIC_LIVECHAT_URL } from '$env/static/public'

    let messages = $state([])
    let inputField

    let ws = null

    const mousePos = mousePosition()
    let userMouses = $state({})


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

            if (msg.type === 'message') {
                messages.push(msg)
            } else if (msg.type === 'mouse') {
                userMouses[msg.author] = {'x': msg.x, 'y': msg.y}
                // console.log(userMouses)
                console.log(msg.x, msg.y)
            }
        })

        const interval = setInterval(() => sendMousePosition(), 100)

        return () => clearInterval(interval) // Svelte call this callback function on unMount
    })

    function sendMessage() {
        if (ws?.readyState !== WebSocket.OPEN)
            return

        const obj = {
            'type': 'message',
            'text': inputField.value
        }

        ws.send(JSON.stringify(obj))
        inputField.value = ''
    }

    function sendMousePosition() {
        if (ws?.readyState !== WebSocket.OPEN)
            return

        const obj = {
            'type': 'mouse',
            'x': mousePos.x,
            'y': mousePos.y
        }

        ws.send(JSON.stringify(obj))
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

    {#each Object.entries(userMouses) as [author, mouse]}
        <div class="fixed text-white top-0 left-0 transition-transform duration-100 ease-linear" style:transform="translate({mouse.x}px, {mouse.y}px)">{author}</div>
    {/each}
</main>

<style>
</style>
