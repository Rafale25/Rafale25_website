<script>
    import UnityWebGame from '#lib/components/unityWebGame.svelte'

    let { params, data } = $props();

    // Bleh
    // BlehPathOfPain
</script>

<UnityWebGame url={data.publicUrl + "/" + params.game} name={params.game}/>
