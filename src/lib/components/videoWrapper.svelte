<script>
    const { src, title = 'YouTube video player' } = $props();
</script>

<iframe
    class="aspect-video"
    width="100%"
    height="auto"
    src={src}
    title={title}
    frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    referrerpolicy="strict-origin-when-cross-origin"
    allowfullscreen>
</iframe>
