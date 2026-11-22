<script>
    import UnityWebGame from '#lib/components/unityWebGame.svelte'
    export let data
</script>

<UnityWebGame url={data.publicUrl + "/Bleh"} name="Bleh"/>
