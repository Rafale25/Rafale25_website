<script>
    import Carousel from '#lib/components/carousel.svelte'

    let volume = $state(0.1);
</script>

# Minecraft Wish

[Github](https://github.com/Rafale25/minecraft-clone)

---

This is a *Minecraft* inspired *graphic programming* project focused on rendering techniques using *modern OpenGL*.\
It features multiplayer, 3D chunks, a large view distance, volumetric lighting and lua scripting.

## Technical features

- Multiplayer
- Ambiant occlusion (baked into vertices)
- Multithreaded chunk meshing
- Cascaded shadow mapping
- Vertex packing
- Frustum culling
- Indirect rendering + Vertex pulling
- Reversed Z-buffer (infinite view distance, aka no far-plane)
- Lua scripting
- Volumetrics Lighting (godrays)

---

Some screenshots at different point of time during development.

![](https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/minecraft_01.webp)
![](https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/minecraft_02.webp)
![](https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/minecraft_03.webp)
![](https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/Screenshot%20from%202024-06-02%2005-42-20.png)
![](https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/Screenshot%20from%202024-06-02%2022-26-00.png)
![](https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/minecraft_04.webp)
![](https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/minecraft_05.webp)
![](https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/minecraft_06.webp)
<video src="https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/mc_badapple.mp4" controls style="border-radius: 8px;" bind:volume></video>

<Carousel images={[
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/minecraft_01.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/minecraft_02.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/minecraft_03.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/minecraft_04.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/minecraft_06.webp",

    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image100.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image101.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image102.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image103.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image106.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image107.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image108.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image109.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image111.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image112.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image113.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image115.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image121.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image126.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image129.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image134.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image137.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image138.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image139.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image140.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image142.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image143.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image144.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image18.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image20.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image25.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image35.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image36.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image37.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image39.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image43.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image50.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image52.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image65.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image66.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image67.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image68.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image69.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image72.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image76.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image77.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image78.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image80.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image81.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image82.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image83.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image84.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image85.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image86.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image87.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image88.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image89.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image90.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image91.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image92.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image93.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image95.webp",
    "https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/minecraft_clone/bugs/image99.webp",
]}/>


---

*C++* - *OpenGL* - *GLSL*
