/** @type {import('tailwindcss').Config} */
module.exports = {
    content: ['./src/**/*.{html,js,svelte,ts}'],
    theme: {
        extend: {
            colors: {
                'primary1': 'hsl(var(--customHue), 20%, 85%)',
                'primary2': 'hsl(var(--customHue), 20%, 70%)',
                'primary3': 'hsl(var(--customHue), 20%, 10%)',
                'primaryBorder': 'hsl(var(--customHue), 20%, 25%)',
            },
            screens: {
                '3xl': '3000px'
            }
        },
    },
    plugins: []
}
