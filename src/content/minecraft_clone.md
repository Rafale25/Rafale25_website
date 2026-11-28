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
]}/>


---

*C++* - *OpenGL* - *GLSL*
