
<script>
    import Navbar from '$lib/components/navbar.svelte'
    import Footer from '$lib/components/footer.svelte'
    import { mousePosition } from '$lib/stores/mousePosition.svelte.js';
    import { onMount } from 'svelte'
    import { PUBLIC_LIVECHAT_URL } from '$env/static/public'
    import { tick } from 'svelte';

    let messages = $state([])
    let inputField
    let chatwindowEl

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
                waitTickAndScroll()
            } else if (msg.type === 'mouse') {
                userMouses[msg.author] = {'x': msg.x, 'y': msg.y}
            }
        })

        const interval = setInterval(() => sendMousePosition(), 100)

        return () => clearInterval(interval) // Svelte call this callback function on unMount
    })

    async function waitTickAndScroll() {
        await tick()
        chatwindowEl.scrollTop = chatwindowEl.scrollHeight
    }

    function sendMessage() {
        if (ws?.readyState !== WebSocket.OPEN)
            return

        const obj = {
            'type': 'message',
            'text': inputField.value
        }

        ws.send(JSON.stringify(obj))
        clearAndReset()
    }

    async function clearAndReset() {
        inputField.value = ''
        await tick()
        inputField.focus()
        inputField.setSelectionRange(0, 0)
        autoResize()
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

    function autoResize() {
        if (!inputField)
            return
        inputField.style.height = 'auto'
        inputField.style.height = inputField.scrollHeight + 'px'
    }

</script>

<main>
    <Navbar/>

    <div bind:this={chatwindowEl} class="border border-white p-4 overflow-y-auto h-96">
        <!-- {#each { length: 12 }, rank} -->
        {#each messages as msg}
            <p class="text-white whitespace-pre-wrap">({formatDate(msg.date)}) {msg.author}: {msg.text}</p>
        {/each}
        <!-- {/each} -->
    </div>

    <div class="flex flew-row gap-4 m-2 content-center">
        <textarea
            class="resize-none w-64 p-1"
            rows="1"
            maxlength="1024"
            bind:this={inputField}
            oninput={autoResize}
            onkeydown={(e) => {
                if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault()
                    sendMessage()
                }
            }}></textarea>

        <button class="bg-white px-2 py-0 h-8 bg-gray-500 rounded-sm" onclick={sendMessage} title='send message' >
            send
        </button>
    </div>

    {#each Object.entries(userMouses) as [author, mouse]}
        <div class="fixed text-white top-0 left-0 transition-transform duration-100 ease-linear" style:transform="translate({mouse.x}px, {mouse.y}px)">{author}</div>
    {/each}
</main>

<style>
</style>
