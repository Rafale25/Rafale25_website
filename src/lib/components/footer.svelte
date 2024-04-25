<script>
    function clipboard() {
        const discord_username = "rafale25"
        navigator.clipboard.writeText(discord_username)
        window.alert(`${discord_username} copied to the clipboard`)
    }
</script>


<footer class="flex justify-center items-center gap-x-6 p-10 bg-raflou-background-secondary">
    <a href="https://github.com/Rafale25">
        <img src="github-icon.svg" alt="Github Icon" class="w-12"/>
    </a>
    <a href="https://www.youtube.com/channel/UCjJYtSy8dMGJkMVrBnwaWSA">
        <img src="youtube-icon.svg" alt="Youtube Icon" class="w-12"/>
    </a>

    <!-- svelte-ignore a11y-invalid-attribute -->
    <a href="" on:click={clipboard}>
        <img src="discord-icon.svg" alt="Discord Icon" class="w-12"/>
    </a>

    <a href="mailto:rafale25.dev@gmail.com" aria-label="email">
        <img src="mail.svg" alt="Youtube Icon" class="w-12"/>
    </a>
</footer>