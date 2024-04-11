import adapter from '@sveltejs/adapter-auto';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	kit: {
		adapter: adapter()
	},
	preprocess: vitePreprocess(),
	// compilerOptions: {
	// 	types: ["@webgpu/types"],
	// 	"typeRoots": ["./node_modules/@webgpu/types", "./node_modules/@types"]

	//   }
};

export default config;
