<script>
    // import { onMount } from "svelte"
    import UnityWebGame from '$lib/components/unityWebGame.svelte'

    export let data

    console.log(data.publicUrl)
</script>

<UnityWebGame url={data.publicUrl + "/Bleh"} name="Bleh"/>
