<script>
    const { name, link, img, description, date, tags } = $props();

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
        'MicroJam': 'https://itch.io/jam/micro-jam-042',
        'L-System': 'https://en.wikipedia.org/wiki/L-system',
        'OpenCV': 'https://opencv.org/',
        'Mediapipe': 'https://github.com/google-ai-edge/mediapipe'
    }
</script>

<!-- <div class="flex flex-col h-full md:w-2/5 xl:w-1/4 3xl:w-[450px] group rounded-xl overflow-hidden"> -->
<div class="flex flex-col h-full group rounded-xl overflow-hidden">
    <div class="w-full aspect-[10/6] overflow-hidden shrink-0">
        <a href={link} class="w-full">
            <img src={img} alt={name} class="w-full h-full object-cover transition-scale duration-300 group-hover:scale-110">
        </a>
    </div>

    <div class="flex flex-col h-full w-full p-4 bg-gradient-to-br from-primary3light to-primary3dark group-hover:brightness-125 transition-all">
        <a href={link} class="font-bold text-xl flex items-center gap-2">
            <span class="text-primary1">{name}</span>
        </a>

        <div class="flex">
            <span class="text-sm text-primary-muted">{date}</span>
        </div>

        <div class="flex flex-col gap-2 h-full py-3 text-primary2 text-base leading-5">
            <span class="">{description}</span>
        </div>

        <div class="flex flex-wrap gap-2 pt-4">
            {#each tags as tag}
                <a href={allTags[tag]}>
                    <span class="py-1 px-3 italic text-base rounded-lg text-primary1 border border-primaryBorder bg-primary3 duration-150 {allTags[tag] ? 'hover:invert' : ''}">{tag}</span>
                </a>
            {/each}
        </div>
    </div>
</div>
