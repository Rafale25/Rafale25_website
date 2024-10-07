<script lang='ts'>
    export let bindValue

    function hex2rgb(hex) {
        const r = parseInt(hex.slice(1, 3), 16) / 255.0;
        const g = parseInt(hex.slice(3, 5), 16) / 255.0;
        const b = parseInt(hex.slice(5, 7), 16) / 255.0;
        return [ r, g, b ];
    }

    function rgbToHex(r, g, b) {
        return '#' + [r, g, b].map(x => {
            const hex = x.toString(16)
            return hex.length === 1 ? '0' + hex : hex
        }).join('')
    }

    let color = rgbToHex(
        Math.round(bindValue[0]*255),
        Math.round(bindValue[1]*255),
        Math.round(bindValue[2]*255)
    )

    $: color, bindValue = hex2rgb(color)

</script>

<input class="p-0" type="color" bind:value={color}/>
