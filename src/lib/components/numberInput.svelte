<script lang='ts'>
    export let bindValue: number
    export let min: number = -16384
    export let max: number = 16384
    export let step: number = 1.0

    function onScroll(e) {
        //NOTE: Just binding the event enables scrolling the value by its step when focused
        e.target.focus()

        if (typeof Number(step) === 'number') {
            e.preventDefault()
            bindValue += e.wheelDeltaY > 0 ? step : -step
            clamp()
        }
    }

    function onChange() {
        if (bindValue === null) bindValue = min
        clamp()
    }

    function clamp() {
        if (!Number.isInteger(bindValue)) {
            bindValue = parseFloat(bindValue.toFixed(2))
        }
        bindValue = Math.max(Math.min(bindValue, Number(max)), Number(min))
    }

</script>

<!-- svelte-ignore a11y-mouse-events-have-key-events -->
<input
    class="w-16 text-center rounded-sm notSpinButton"
    type="number"
    min={min}
    max={max}
    step={step}
    bind:value={bindValue}
    on:wheel={onScroll}
    on:input={onChange}
/>

<style>
    .notSpinButton {
        @apply [appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none
    }
</style>
