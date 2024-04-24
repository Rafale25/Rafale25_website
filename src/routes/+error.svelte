<script>
    import { page } from '$app/stores';
</script>

<main class="flex w-screen h-screen bg-black overflow-hidden">
    <div class="flex flex-col w-full h-full justify-center items-center gap-2">
        <img class="w-12 h-auto" src="waaa.png" alt="waaa"/>
        <h1 class="text-white">{$page.status} {$page.error.message}</h1>
    </div>
</main>