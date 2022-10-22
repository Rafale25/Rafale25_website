<script>
    export let name
    export let link
    export let img
    export let description
    export let tags

    const allTags = {
        'Python': 'https://www.python.org',
        'GLSL': 'https://www.khronos.org/opengl/wiki/OpenGL_Shading_Language',
        'ModernGL': 'https://github.com/moderngl/moderngl',
        'Pygame': 'https://github.com/pygame/pygame',
        'ScrapMechanic': 'https://store.steampowered.com/app/387990/Scrap_Mechanic',
        'Compute Shaders': 'https://www.khronos.org/opengl/wiki/Compute_Shader',
        'Geometry Shaders': 'https://www.khronos.org/opengl/wiki/Geometry_Shader',
        'Arcade': 'https://github.com/pythonarcade/arcade',
        'GlobalGameJam': 'https://globalgamejam.org',
        'Ludum Dare': 'https://ldjam.com/',
    }

</script>

<a class="sm:flex sm:h-64 group w-full rounded-2xl overflow-hidden w-4/5" href={link}>
    <div class="sm:min-w-[16rem] min-w-[12rem] sm:w-2/4 overflow-hidden">
        <img src={img} alt={name} class="w-full h-full object-cover transition-scale duration-300 group-hover:scale-110  ">
    </div>

    <div class="flex flex-col w-full min-h-full text-base">
        <div class="font-bold text-xl px-4 py-2 bg-[color:var(--border)] group-hover:saturate-200">
            <span>{name}</span>
        </div>

        <div class="h-full p-4 text-gray-100 bg-neutral-800">
            <span>{description}</span>
        </div>

        <div class="flex flex-wrap gap-x-1 px-4 py-1 bg-[color:var(--border)]">
            {#each tags as tag}
                <a href={allTags[tag]}>
                    <span class="px-2 italic rounded hover:saturate-150 bg-raflou-green-light text-black">#{tag}</span>
                </a>
            {/each}
        </div>
    </div>
</a>
