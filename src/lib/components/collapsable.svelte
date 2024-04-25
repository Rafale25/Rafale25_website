<script>
	export let collapsed = false;
</script>

<div class="collapsable {collapsed ? "" : "grid-template-rows-1fr"} duration-500">
    <div>
        <slot/>
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