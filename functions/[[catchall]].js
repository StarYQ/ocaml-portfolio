// Cloudflare Pages Function for SPA routing
// This catches all routes and serves the appropriate content

export async function onRequest(context) {
  const { request, env, next } = context;
  const url = new URL(request.url);
  const pathname = url.pathname;
  
  // List of actual static assets that should be served directly
  const staticAssets = [
    '/_build/default/lib/client_main/main.bc.js',
    '/static/resume.pdf',
    '/_redirects',
    '/_headers',
    '/favicon.ico'
  ];
  
  // Check if the request is for a static asset
  const isStaticAsset = staticAssets.some(asset => pathname.startsWith(asset)) ||
                        pathname.includes('.js') ||
                        pathname.includes('.css') ||
                        pathname.includes('.pdf') ||
                        pathname.includes('.png') ||
                        pathname.includes('.jpg') ||
                        pathname.includes('.jpeg') ||
                        pathname.includes('.gif') ||
                        pathname.includes('.svg') ||
                        pathname.includes('.ico');
  
  // For static assets, pass through to the default handler
  if (isStaticAsset) {
    return next();
  }
  
  // For all other routes (SPA routes), serve index.html
  // This handles /about, /projects, /resume, etc.
  const response = await next();
  
  // If the response is 404 and it's not a static asset, serve index.html
  if (response.status === 404 && !isStaticAsset) {
    return env.ASSETS.fetch(new Request(new URL('/index.html', request.url)));
  }
  
  return response;
}