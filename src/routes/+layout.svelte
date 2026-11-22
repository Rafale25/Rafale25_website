<script>
    import "../app.css";

    import { dev } from '$app/env';
    import { inject } from '@vercel/analytics'

    inject({ mode: dev ? 'development' : 'production' });
</script>

<svelte:head>
    <title>Rafale25</title>
</svelte:head>

<slot />
