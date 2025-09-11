/// <reference types="node" />

import { defineConfig } from "vite";
import viteReact from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite";

import { TanStackRouterVite } from "@tanstack/router-plugin/vite";
import { resolve, dirname } from "path";
import { fileURLToPath } from "url";

// __dirname is not available in ESM; derive it from import.meta.url
const __dirname = dirname(fileURLToPath(import.meta.url));

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [TanStackRouterVite({ autoCodeSplitting: true }), viteReact(), tailwindcss()],
  resolve: {
    alias: {
      "@": resolve(__dirname, "./src"),
    },
  },
});
