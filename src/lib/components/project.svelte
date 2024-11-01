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
        'Unity': 'https://unity.com/',
    }
</script>

<div class="flex flex-col h-min md:w-2/5 xl:w-1/4 3xl:w-[450px] group rounded-xl overflow-hidden">
    <div class="w-full overflow-hidden">
        <a href={link} class="w-full">
            <img src={img} alt={name} class="w-full h-full object-cover transition-scale duration-300 group-hover:scale-110">
        </a>
    </div>

    <div class="flex flex-col w-full text-base">
        <a href={link} class="font-bold text-xl px-4 py-2 bg-raflou-border group-hover:saturate-200">
            <span class="text-raflou-green-dark">{name}</span>
        </a>

        <div class="h-full p-4 text-gray-100 bg-neutral-800">
            <span>{description}</span>
        </div>

        <div class="flex flex-wrap gap-x-2 px-4 py-1 bg-raflou-border">
            {#each tags as tag}
                <a href={allTags[tag]}>
                    <span class="px-2 italic rounded hover:bg-green-500 bg-raflou-green-light text-black font-bold">{tag}</span>
                </a>
            {/each}
        </div>
    </div>
</div>
