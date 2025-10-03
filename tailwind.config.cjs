/** @type {import('tailwindcss').Config} */
module.exports = {
    content: ['./src/**/*.{html,js,svelte,ts}'],
    theme: {
        extend: {
            colors: {
                'primary1':         'hsl(var(--customHue), var(--customSaturation), 85%)',
                'primary2':         'hsl(var(--customHue), var(--customSaturation), 70%)',
                'primary3':         'hsl(var(--customHue), var(--customSaturation), 10%)',
                'primary3lighter':  'hsl(var(--customHue), var(--customSaturation), 20%)',
                'primary3light':    'hsl(var(--customHue), var(--customSaturation), 14%)',
                'primary3dark':     'hsl(var(--customHue), var(--customSaturation),  5%)',
                'primaryBorder':    'hsl(var(--customHue), var(--customSaturation), 25%)',
            },
            screens: {
                '3xl': '3000px'
            }
        },
    },
    plugins: []
}
