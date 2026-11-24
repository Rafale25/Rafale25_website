import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';
import adapter from '@sveltejs/adapter-vercel';
import { mdsvex } from 'mdsvex';
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
	plugins: [
		tailwindcss(),
		sveltekit({
			adapter: adapter()
		}),
		mdsvex({
			extensions: ['.svx', '.md']
		})
	]
});
