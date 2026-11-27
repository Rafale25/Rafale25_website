<script>
    const { collapsed = false, children } = $props();
</script>

<div class="collapsable {collapsed ? "" : "grid-template-rows-1fr"} duration-500">
    <div>
        {@render children?.()}
    </div>
</div>

<style>
    .collapsable {
        display: grid;
        grid-template-rows: 0fr;
    }

    .collapsable > div {
        overflow: hidden;
    }

    .grid-template-rows-1fr {
        grid-template-rows: 1fr;
    }
</style>
