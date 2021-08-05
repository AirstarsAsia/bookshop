import path from 'path';
import fs from 'fs';
import { filterBookshops, loadConfig } from './lib/bookshopHelper.js';
import bookshopComponentPlugin from './lib/plugins/bookshopComponentPlugin.js';
import bookshopConfigPlugin from './lib/plugins/bookshopConfigPlugin.js';
import bookshopFilePlugin from './lib/plugins/bookshopFilePlugin.js';
import bookshopGlobPlugin from './lib/plugins/bookshopGlobPlugin.js'
import bookshopStylesPlugin from '@bookshop/styles';
import esbuild from 'esbuild';

export default async (options) => {
    options = {
        bookshopDirs: [],
        ...options
    }
    const esbuildOptions = {
        write: true,
        watch: false,
        plugins: [],
        ...(options.esbuild || {})
    }

    options.bookshopDirs = filterBookshops(options.bookshopDirs);
    options.bookshopConfig = await loadConfig(options.bookshopDirs[0]);
    console.log(options.bookshopConfig);

    const plugins = esbuildOptions.plugins || [];
    plugins.push(bookshopComponentPlugin(options));
    plugins.push(bookshopConfigPlugin(options));
    plugins.push(bookshopFilePlugin(options));
    plugins.push(bookshopGlobPlugin(options));
    plugins.push(bookshopStylesPlugin(options));

    return await esbuild.build({
        ...esbuildOptions,
        bundle: true,
        plugins: plugins,
    });
}
