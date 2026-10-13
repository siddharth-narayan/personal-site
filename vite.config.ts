import { defineConfig } from 'vite';
import tailwindcss from '@tailwindcss/vite'
import { sveltekit } from '@sveltejs/kit/vite';

import adapter from '@sveltejs/adapter-node';

export default defineConfig({
<<<<<<< HEAD
	plugins: [sveltekit(), tailwindcss()],
	server: {
		"port": 7000
	},
	preview: { port: 3000 }
=======
	plugins: [sveltekit({
		adapter: adapter(),
		paths: {
			origin: 'http://localhost:3000'
		}
	}), tailwindcss()],
>>>>>>> repro
});
