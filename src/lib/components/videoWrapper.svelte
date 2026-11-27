<script>
    const { src, title = 'YouTube video player' } = $props();
</script>

<iframe
    width="auto"
    height="auto"
    src={src}
    title={title}
    frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    referrerpolicy="strict-origin-when-cross-origin"
    allowfullscreen>
</iframe>
