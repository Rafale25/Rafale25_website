<script>
    import Collapsable from '$lib/components/collapsable.svelte'

    let visible = false;
</script>

<nav class="flex w-full justify-between items-center py-4 backdrop-brightness-[10%]">
    <div class="flex items-center gap-x-4 px-6">
        <img class="min-w-12 max-w-12 rounded-lg" src="logo.jpg" alt="ProfilePicture"/>
        <div class="sm:block hidden text-xl">
            <span class="text-white">Rafale25</span>
        </div>
    </div>

    <ul class="sm:flex hidden font-bold gap-x-8 px-9 text-lg text-neutral-300">
        <li><a class="btn hover:underline" href="/">Projects</a></li>
        <li><a class="btn hover:underline" href="/gallery">Gallery</a></li>
    </ul>

    <div class="sm:hidden flex px-6">
        <button class="w-10" on:click={() => visible = !visible}>
            <img src="burger-menu.svg" alt="Burger Menu"  class="w-12"/>
        </button>
    </div>
</nav>

<!-- p-0.5 because backdrop filter don't work on mobile when the object start with a size of 0 -->
<div class="sm:hidden block backdrop-brightness-[10%] p-0.5">
    <Collapsable collapsed={!visible}>
        <div class="flex flex-col w-full items-end gap-y-2 px-9 pb-4 font-bold text-lg text-neutral-300">
            <a class="btn hover:underline" href="/">Projects</a>
            <a class="btn hover:underline" href="/gallery">Gallery</a>
        </div>
    </Collapsable>
</div>

<style>
    :root {
        background-color: black;
    }
</style>
