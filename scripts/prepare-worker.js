#!/usr/bin/env node

/**
 * Prepare build for Cloudflare Workers deployment
 * This script prepares the static assets to be served by the Worker
 */

const fs = require('fs');
const path = require('path');

console.log('🚀 Preparing Cloudflare Workers deployment...\n');

// Create dist directory if it doesn't exist
const distDir = path.join(__dirname, '..', 'dist');
fs.rmSync(distDir, { recursive: true, force: true });
fs.mkdirSync(distDir, { recursive: true });

// Create necessary subdirectories
const dirs = [
  path.join(distDir, '_build', 'default', 'lib', 'client_main'),
  path.join(distDir, 'static')
];

dirs.forEach(dir => {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
    console.log(`✓ Created directory: ${dir.replace(distDir, 'dist')}`);
  }
});

// Create index.html optimized for Workers (no base path needed)
const indexContent = `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Portfolio Website created using functional web development with Bonsai and Dream">
    <title>arnab bhowmik</title>
    <script>
        (function() {
            var theme = 'dark';
            try {
                var storedTheme = window.localStorage && window.localStorage.getItem('theme');
                if (storedTheme === 'light' || storedTheme === 'sunset' || storedTheme === 'dark') {
                    theme = storedTheme;
                }
            } catch (_) {}
            document.documentElement.classList.add(theme + '-theme');
        })();
    </script>
    <style>
        @font-face {
            font-family: 'JetBrains Mono';
            font-style: normal;
            font-weight: 100 800;
            font-display: swap;
            src: url('/static/fonts-jetbrains-mono-latin.woff2') format('woff2');
        }

        :root, .light-theme {
            --bg-primary: #f5f2ea;
            --text-primary: #111111;
            --text-secondary: rgba(17, 17, 17, 0.76);
            --border-strong: rgba(17, 17, 17, 0.72);
            --spinner-track: rgba(17, 17, 17, 0.1);
        }

        .dark-theme {
            --bg-primary: #0f0f10;
            --text-primary: #f4f1ea;
            --text-secondary: rgba(244, 241, 234, 0.8);
            --border-strong: rgba(244, 241, 234, 0.8);
            --spinner-track: rgba(255, 255, 255, 0.1);
        }

        .sunset-theme {
            --bg-primary: oklch(0.18 0.02 45);
            --text-primary: oklch(0.85 0.08 55);
            --text-secondary: oklch(0.85 0.08 55 / 0.8);
            --border-strong: oklch(0.7 0.12 50);
            --spinner-track: oklch(0.7 0.12 50 / 0.16);
        }

        /* Base styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'JetBrains Mono', monospace;
            line-height: 1.6;
            color: var(--text-primary);
            background: var(--bg-primary);
            min-height: 100vh;
            transition: background-color 0.3s ease, color 0.3s ease;
        }
        
        #app {
            min-height: 100vh;
        }
        
        /* Loading state */
        .loading {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            gap: 1rem;
            font-size: 0.72rem;
            letter-spacing: 0.22em;
            text-transform: uppercase;
            color: var(--text-primary);
        }
        
        /* Loading spinner */
        .spinner {
            border: 3px solid var(--spinner-track);
            border-radius: 50%;
            border-top: 3px solid var(--border-strong);
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
    </style>
</head>
<body>
    <div id="app">
        <div class="loading">
            <div class="spinner"></div>
            <span>Loading arnabb.dev...</span>
        </div>
    </div>
    <!-- Load the OCaml compiled JavaScript -->
    <script src="/_build/default/lib/client_main/main.bc.js"></script>
</body>
</html>`;

// Write index.html
fs.writeFileSync(path.join(distDir, 'index.html'), indexContent);
console.log('✓ Created index.html for Workers');

// Copy the JavaScript bundle
const jsSourcePaths = [
  path.join(__dirname, '..', '_build', 'default', 'lib', 'client_main', 'main.bc.js'),
  path.join(__dirname, '..', '_build', 'default', 'lib', 'client', 'main_client', 'main.bc.js')
];

let jsFound = false;
for (const jsPath of jsSourcePaths) {
  if (fs.existsSync(jsPath)) {
    const destPath = path.join(distDir, '_build', 'default', 'lib', 'client_main', 'main.bc.js');
    fs.copyFileSync(jsPath, destPath);

    // Get file size
    const stats = fs.statSync(destPath);
    const fileSizeInMB = (stats.size / (1024 * 1024)).toFixed(2);

    console.log(`✓ Copied JS bundle (${fileSizeInMB} MB)`);

    // Warn if bundle is too large
    if (stats.size > 5 * 1024 * 1024) {
      console.log(`⚠️  Warning: Bundle size is ${fileSizeInMB} MB - consider optimization`);
    }

    jsFound = true;
    break;
  }
}

if (!jsFound) {
  console.error('\n' + '='.repeat(60));
  console.error('❌ ERROR: Could not find main.bc.js bundle');
  console.error('='.repeat(60));
  console.error('\nThe OCaml JavaScript bundle was not found at any of these locations:');
  jsSourcePaths.forEach(path => {
    console.error(`  - ${path}`);
  });
  console.error('\nThis usually means the OCaml build has not been run.');
  console.error('\nTo fix this issue:');
  console.error('  1. Run "make build-prod" to build the OCaml code');
  console.error('  2. Or use "npm run build:worker" which runs both steps');
  console.error('\nNote: The build:worker script should automatically run "make build-prod"');
  console.error('If you\'re seeing this in CI/CD, ensure OCaml/opam dependencies are installed.');
  console.error('='.repeat(60) + '\n');
  process.exit(1);
}

// Copy all static assets used by the app.
const staticSourceDir = path.join(__dirname, '..', 'static');
const staticDestDir = path.join(distDir, 'static');

function copyStaticAssets(sourceDir, destDir, relativeDir = '') {
  if (!fs.existsSync(sourceDir)) {
    console.log('⚠️  Skipping static assets (static/ directory not found)');
    return;
  }

  const entries = fs.readdirSync(sourceDir, { withFileTypes: true });

  entries.forEach(entry => {
    const relativePath = path.join(relativeDir, entry.name);
    const srcPath = path.join(sourceDir, entry.name);
    const destPath = path.join(destDir, entry.name);

    if (entry.isDirectory()) {
      fs.mkdirSync(destPath, { recursive: true });
      copyStaticAssets(srcPath, destPath, relativePath);
      return;
    }

    fs.mkdirSync(path.dirname(destPath), { recursive: true });
    fs.copyFileSync(srcPath, destPath);

    const stats = fs.statSync(destPath);
    const fileSizeInKB = (stats.size / 1024).toFixed(2);
    const displayPath = path.posix.join('static', relativePath.replace(/\\/g, '/'));
    console.log(`✓ Copied ${displayPath} (${fileSizeInKB} KB)`);
  });
}

copyStaticAssets(staticSourceDir, staticDestDir);

// Create a manifest file for debugging
const manifest = {
  timestamp: new Date().toISOString(),
  files: []
};

function scanDirectory(dir, basePath = '') {
  const files = fs.readdirSync(dir);
  files.forEach(file => {
    const filePath = path.join(dir, file);
    const relativePath = path.join(basePath, file);
    const stat = fs.statSync(filePath);

    if (stat.isDirectory()) {
      scanDirectory(filePath, relativePath);
    } else {
      manifest.files.push({
        path: '/' + relativePath.replace(/\\/g, '/'),
        size: stat.size,
        modified: stat.mtime
      });
    }
  });
}

scanDirectory(distDir);
fs.writeFileSync(
  path.join(distDir, 'manifest.json'),
  JSON.stringify(manifest, null, 2)
);

// Summary
console.log('\n' + '='.repeat(60));
console.log('Cloudflare Workers build preparation complete!\n');
console.log(`Output directory: ${distDir}`);
console.log(`Total files: ${manifest.files.length}`);

const totalSize = manifest.files.reduce((sum, file) => sum + file.size, 0);
console.log(`Total size: ${(totalSize / (1024 * 1024)).toFixed(2)} MB`);

console.log('\nFiles prepared for deployment:');
manifest.files.forEach(file => {
  const sizeStr = file.size > 1024 * 1024
    ? `${(file.size / (1024 * 1024)).toFixed(2)} MB`
    : `${(file.size / 1024).toFixed(2)} KB`;
  console.log(`   ${file.path} (${sizeStr})`);
});

console.log('\nNext steps:');
console.log('   1. Test locally: npm run dev:worker');
console.log('   2. Deploy: npm run deploy:worker');
console.log('='.repeat(60));
