import indexHtml from '../dist/index.html';
import mainJs from '../dist/_build/default/lib/client_main/main.bc.js';
import resumePdf from '../dist/static/resume.pdf';

// Map of static assets
const assets = new Map([
  ['/', indexHtml],
  ['/index.html', indexHtml],
  ['/_build/default/lib/client_main/main.bc.js', mainJs],
  ['/static/resume.pdf', resumePdf],
]);

// MIME types for different file extensions
const mimeTypes = {
  'html': 'text/html; charset=utf-8',
  'js': 'application/javascript; charset=utf-8',
  'pdf': 'application/pdf',
  'json': 'application/json',
  'css': 'text/css; charset=utf-8',
};

function getMimeType(path) {
  const ext = path.split('.').pop();
  return mimeTypes[ext] || 'text/plain';
}

export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    let path = url.pathname;
    
    // Remove trailing slash except for root
    if (path !== '/' && path.endsWith('/')) {
      path = path.slice(0, -1);
    }
    
    // Try to serve the exact path first
    if (assets.has(path)) {
      return new Response(assets.get(path), {
        headers: {
          'Content-Type': getMimeType(path),
          'Cache-Control': path.includes('main.bc.js') ? 
            'public, max-age=31536000, immutable' : 
            'public, max-age=3600',
        },
      });
    }
    
    // For SPA routing, serve index.html for all other routes
    // This handles client-side routing for /about, /projects, /resume, etc.
    if (!path.includes('.')) {
      return new Response(indexHtml, {
        headers: {
          'Content-Type': 'text/html; charset=utf-8',
          'Cache-Control': 'public, max-age=3600',
        },
      });
    }
    
    // Return 404 for missing assets
    return new Response('Not Found', { status: 404 });
  },
};