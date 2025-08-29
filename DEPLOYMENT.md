# Deployment Guide

This OCaml portfolio site can be deployed to both GitHub Pages and Cloudflare Pages simultaneously.

## Dual Deployment Architecture

- **GitHub Pages**: Serves at `https://[username].github.io/ocaml-portfolio/`
- **Cloudflare Pages**: Serves at `https://ocaml-portfolio.pages.dev` (or your custom domain)

Both deployments are triggered automatically when you push to the `main` branch.

## GitHub Pages Deployment (Already Active)

GitHub Pages deployment is already configured and working. It:
- Builds the OCaml project
- Serves the site at a subpath (`/ocaml-portfolio/`)
- Handles client-side routing with a 404.html fallback

No additional setup needed - this continues to work as before.

## Cloudflare Pages Deployment (New)

### Initial Setup

1. **Create Cloudflare Account**
   - Sign up at [Cloudflare Pages](https://pages.cloudflare.com)
   - Note your Account ID from the dashboard

2. **Create API Token**
   - Go to Profile → API Tokens
   - Create a token with these permissions:
     - Cloudflare Pages:Edit
     - Account:Read
   - Save the token securely

3. **Add GitHub Secrets**
   
   In your GitHub repository, go to Settings → Secrets and add:
   - `CLOUDFLARE_API_TOKEN`: Your API token from step 2
   - `CLOUDFLARE_ACCOUNT_ID`: Your account ID from step 1

4. **First Deployment**
   
   The first deployment will happen automatically on your next push to `main`.
   
   Alternatively, trigger manually:
   - Go to Actions → "Deploy to Cloudflare Pages"
   - Click "Run workflow"

### Local Testing

Test the Cloudflare build locally:

```bash
# Build the project
make build-prod

# Prepare for Cloudflare
node scripts/prepare-cloudflare.js

# Preview with Wrangler (optional, requires wrangler CLI)
npx wrangler pages dev dist
```

### Custom Domain (Optional)

To use a custom domain with Cloudflare Pages:

1. Go to your Cloudflare Pages project
2. Navigate to Custom domains
3. Add your domain
4. Follow DNS configuration instructions

## Key Differences Between Deployments

### GitHub Pages
- URL includes repository name: `/ocaml-portfolio/`
- Uses base path detection in JavaScript
- 404.html fallback for SPA routing

### Cloudflare Pages  
- Serves from root: `/`
- No base path needed
- Uses _redirects file and edge functions for SPA routing
- Generally faster due to Cloudflare's global CDN
- Supports custom domains easily

## Build Process

Both deployments use the same OCaml build:

```bash
opam exec -- make build-prod
```

The difference is in post-processing:
- **GitHub Pages**: Copies files maintaining structure for subpath serving
- **Cloudflare**: Prepares files for root-level serving with proper routing

## Files Overview

- `.github/workflows/pages.yml` - GitHub Pages deployment
- `.github/workflows/cloudflare.yml` - Cloudflare Pages deployment  
- `wrangler.toml` - Cloudflare configuration
- `scripts/prepare-cloudflare.js` - Build preparation for Cloudflare
- `functions/[[catchall]].js` - Edge function for SPA routing
- `static/index.html` - Main HTML (GitHub Pages version)
- `dist/` - Cloudflare build output (git-ignored)

## Monitoring Deployments

- **GitHub Pages**: Check Actions tab for "Deploy OCaml Portfolio to Pages" workflow
- **Cloudflare Pages**: Check Actions tab for "Deploy to Cloudflare Pages" workflow

Both should show green checkmarks when successful.

## Troubleshooting

### GitHub Pages Issues
- Ensure GitHub Pages is enabled in repository settings
- Check that the site is set to deploy from GitHub Actions
- Verify the base path detection in browser console

### Cloudflare Pages Issues  
- Verify secrets are set correctly
- Check Cloudflare dashboard for deployment logs
- Ensure `dist/` directory is created properly
- Test locally with `node scripts/prepare-cloudflare.js`

## Benefits of Dual Deployment

1. **Redundancy**: If one service is down, the other still works
2. **Performance Testing**: Compare performance between platforms
3. **Different URLs**: Can share different links for different purposes
4. **Learning**: Experience with both deployment platforms