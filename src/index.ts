/**
 * Cloudflare Worker for OCaml Portfolio
 * Handles static asset serving and SPA routing
 */

interface Env {
  // ASSETS binding for serving static files
  ASSETS: Fetcher;
}

export default {
  /**
   * Main request handler for the Worker
   */
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);
    
    // Debug logging to understand what's happening
    console.log(`Request: ${request.method} ${url.pathname}`);
    console.log(`env.ASSETS available: ${!!env.ASSETS}`);
    console.log(`env.ASSETS type: ${typeof env.ASSETS}`);
    
    // Check if ASSETS binding is available
    if (!env.ASSETS) {
      return new Response(
        `ASSETS binding not available. Debug info:
- URL: ${url.href}
- Path: ${url.pathname}
- env keys: ${Object.keys(env).join(', ')}
- env.ASSETS: ${env.ASSETS}
Please check wrangler.toml configuration and deployment.`,
        {
          status: 500,
          headers: { 'Content-Type': 'text/plain' }
        }
      );
    }
    
    try {
      // Try to serve the requested asset directly
      const assetResponse = await env.ASSETS.fetch(request);
      
      // If asset exists (not 404), return it with appropriate headers
      if (assetResponse.status !== 404) {
        // Clone the response to add/modify headers
        const response = new Response(assetResponse.body, assetResponse);
        const headers = new Headers(response.headers);
        
        // Add caching headers based on file type
        if (url.pathname.includes('.js')) {
          // JavaScript files - cache for a long time (immutable with hash)
          headers.set('Cache-Control', 'public, max-age=31536000, immutable');
        } else if (url.pathname.includes('.pdf')) {
          // PDFs - cache for a day
          headers.set('Cache-Control', 'public, max-age=86400');
        } else if (url.pathname === '/' || url.pathname === '/index.html') {
          // HTML - shorter cache for updates
          headers.set('Cache-Control', 'public, max-age=3600');
        }
        
        // Add security headers
        headers.set('X-Content-Type-Options', 'nosniff');
        headers.set('X-Frame-Options', 'DENY');
        
        return new Response(response.body, {
          status: response.status,
          statusText: response.statusText,
          headers: headers
        });
      }
      
      // For all non-asset routes (SPA routing), serve index.html
      // This handles /about, /projects, /resume, /contact, etc.
      if (!url.pathname.includes('.') || url.pathname.endsWith('/')) {
        // Request the index.html file
        const indexRequest = new Request(new URL('/index.html', request.url).toString(), request);
        const indexResponse = await env.ASSETS.fetch(indexRequest);
        
        if (indexResponse.status === 200) {
          // Return index.html with proper headers for SPA
          const headers = new Headers(indexResponse.headers);
          headers.set('Cache-Control', 'public, max-age=3600');
          headers.set('X-Content-Type-Options', 'nosniff');
          headers.set('X-Frame-Options', 'DENY');
          
          return new Response(indexResponse.body, {
            status: 200,
            statusText: 'OK',
            headers: headers
          });
        }
      }
      
      // If we get here, return a 404
      return new Response('Not Found', {
        status: 404,
        headers: {
          'Content-Type': 'text/plain',
          'Cache-Control': 'no-cache'
        }
      });
      
    } catch (error) {
      // Log error and return detailed error for debugging
      console.error('Worker error:', error);
      const errorMessage = error instanceof Error ? error.message : String(error);
      const errorStack = error instanceof Error ? error.stack : '';
      
      return new Response(
        `Worker Error:
Message: ${errorMessage}
Stack: ${errorStack}
URL: ${url.href}
Path: ${url.pathname}`,
        {
          status: 500,
          headers: {
            'Content-Type': 'text/plain',
            'Cache-Control': 'no-cache'
          }
        }
      );
    }
  }
};