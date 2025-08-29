#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

// Create dist directory
const distDir = path.join(__dirname, '..', 'dist');
if (!fs.existsSync(distDir)) {
  fs.mkdirSync(distDir, { recursive: true });
}

// Create subdirectories
const dirs = [
  path.join(distDir, '_build', 'default', 'lib', 'client_main'),
  path.join(distDir, 'static')
];

dirs.forEach(dir => {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
});

// Copy index.html and modify for Cloudflare (no base path needed)
const indexPath = path.join(__dirname, '..', 'static', 'index.html');
let indexContent = fs.readFileSync(indexPath, 'utf8');

// Create a Cloudflare-specific version that always loads from root
const cfIndexContent = `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OCaml Portfolio</title>
    <style>
        /* Base styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            line-height: 1.6;
            color: #333;
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
            font-size: 1.2rem;
            color: #666;
        }
    </style>
</head>
<body class="light-theme">
    <div id="app">
        <div class="loading">Loading portfolio...</div>
    </div>
    <script src="/_build/default/lib/client_main/main.bc.js"></script>
</body>
</html>`;

fs.writeFileSync(path.join(distDir, 'index.html'), cfIndexContent);

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
    console.log(`✓ Copied JS bundle from ${jsPath}`);
    jsFound = true;
    break;
  }
}

if (!jsFound) {
  console.error('✗ Could not find main.bc.js bundle');
  process.exit(1);
}

// Copy static files
const resumePath = path.join(__dirname, '..', 'static', 'resume.pdf');
if (fs.existsSync(resumePath)) {
  fs.copyFileSync(resumePath, path.join(distDir, 'static', 'resume.pdf'));
  console.log('✓ Copied resume.pdf');
}

// Create _redirects file for Cloudflare Pages SPA routing
const redirectsContent = `# SPA fallback
/*    /index.html   200`;

fs.writeFileSync(path.join(distDir, '_redirects'), redirectsContent);
console.log('✓ Created _redirects file for SPA routing');

// Create _headers file for better caching
const headersContent = `# Cache static assets
/_build/*
  Cache-Control: public, max-age=31536000, immutable

/static/*
  Cache-Control: public, max-age=86400

/
  Cache-Control: public, max-age=3600`;

fs.writeFileSync(path.join(distDir, '_headers'), headersContent);
console.log('✓ Created _headers file for caching');

console.log('\n✅ Cloudflare build preparation complete!');
console.log(` Output directory: ${distDir}`);

// List files in dist
console.log('\n Files in dist:');
function listFiles(dir, prefix = '') {
  const files = fs.readdirSync(dir);
  files.forEach(file => {
    const filePath = path.join(dir, file);
    const stat = fs.statSync(filePath);
    if (stat.isDirectory()) {
      console.log(`${prefix} ${file}/`);
      listFiles(filePath, prefix + '  ');
    } else {
      const size = (stat.size / 1024).toFixed(2);
      console.log(`${prefix} ${file} (${size} KB)`);
    }
  });
}

listFiles(distDir);