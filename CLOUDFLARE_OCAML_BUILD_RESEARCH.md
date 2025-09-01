# OCaml on Cloudflare Pages Build Environment Research Report

## Executive Summary

Cloudflare Pages does NOT natively support OCaml/opam in their build environment. However, there are multiple viable approaches to deploy OCaml projects using workarounds or alternative strategies.

## Cloudflare Pages Build Environment

### Pre-installed Tools (Build v2/v3)
- **Languages**: Node.js, Python, Ruby, Go, PHP
- **Package Managers**: npm, yarn, pnpm, pip
- **System**: Ubuntu 22.04.2 (x86_64) in gVisor container
- **Key Limitation**: Runs in restricted gVisor container (limited system modifications)

### What's NOT Available
- ❌ OCaml compiler
- ❌ opam package manager  
- ❌ System package manager access (apt-get with sudo)
- ❌ Ability to install system-level dependencies

## Viable Approaches (Ranked by Feasibility)

### 🥇 Approach 1: Pre-build and Direct Upload (RECOMMENDED)

**Strategy**: Build locally or in CI, upload only static assets to Cloudflare

**Implementation**:
```bash
# Build locally or in GitHub Actions
make build-prod

# Use Cloudflare Direct Upload or Wrangler
wrangler pages deploy _site --project-name=ocaml-portfolio
```

**Pros**:
- 100% reliable - no build environment issues
- Fastest deployment (no build step on Cloudflare)
- Full control over build process
- Can use any OCaml version/packages

**Cons**:
- Requires external build step
- No automatic builds from Git pushes (unless using CI)

### 🥈 Approach 2: GitHub Actions + Cloudflare Pages Direct Upload

**Strategy**: Use GitHub Actions for building, Cloudflare for hosting only

**Implementation**:
```yaml
name: Build and Deploy to Cloudflare Pages

on:
  push:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup OCaml
        uses: ocaml/setup-ocaml@v3
        with:
          ocaml-compiler: 5.2.1
      
      - name: Build
        run: |
          opam install . --deps-only -y
          opam exec -- make build-prod
      
      - name: Deploy to Cloudflare Pages
        uses: cloudflare/pages-action@v1
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          projectName: ocaml-portfolio
          directory: _site
          gitHubToken: ${{ secrets.GITHUB_TOKEN }}
```

**Pros**:
- Automated deployment on Git push
- Full OCaml toolchain support
- Can run tests before deployment
- GitHub provides status checks

**Cons**:
- Requires GitHub Actions setup
- Build happens outside Cloudflare

### 🥉 Approach 3: Install opam During Build (EXPERIMENTAL)

**Strategy**: Download and install opam binary in build command

**Implementation**:
```bash
# In Cloudflare Pages build configuration:
# Build command:
curl -L https://github.com/ocaml/opam/releases/download/2.1.5/opam-2.1.5-x86_64-linux -o opam && \
chmod +x opam && \
./opam init --bare --disable-sandboxing -y && \
eval $(./opam env) && \
./opam switch create 5.2.1 && \
eval $(./opam env) && \
./opam install dune js_of_ocaml ppx_css -y && \
make build-prod

# Output directory: _site
```

**Challenges**:
- ⚠️ gVisor container restrictions may block execution
- ⚠️ No guarantee curl is available
- ⚠️ Build timeout risks (opam init/switch can be slow)
- ⚠️ Cannot install system dependencies (libgmp-dev, m4)

**Workaround Attempt**:
```bash
# More conservative approach using Node.js to download
node -e "
const https = require('https');
const fs = require('fs');
const file = fs.createWriteStream('opam');
https.get('https://github.com/ocaml/opam/releases/download/2.1.5/opam-2.1.5-x86_64-linux', 
  response => response.pipe(file));
" && \
sleep 5 && \
chmod +x opam && \
./opam init --bare --disable-sandboxing --no-setup -y && \
# ... rest of build
```

### 🔄 Approach 4: Use npm-based OCaml Toolchain (LIMITED)

**Strategy**: Use ReScript/Melange which have npm packages

**Note**: This would require significant code rewrite from Bonsai to ReScript/Melange. NOT recommended for existing projects.

## Recommended Solution

### For This Project: Approach 2 (GitHub Actions + Direct Upload)

**Rationale**:
1. Project already has GitHub Actions workflow for Pages
2. OCaml build requirements (libgmp-dev, m4) need system access
3. Build is complex (dune, js_of_ocaml, ppx preprocessors)
4. Reliability is critical for portfolio site

**Implementation Steps**:

1. **Modify existing GitHub workflow** (`.github/workflows/pages.yml`):
   - Keep OCaml build steps as-is
   - Replace GitHub Pages deployment with Cloudflare Pages Direct Upload

2. **Add Cloudflare deployment action**:
```yaml
- name: Deploy to Cloudflare Pages
  uses: cloudflare/pages-action@v1
  with:
    apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
    accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
    projectName: ocaml-portfolio
    directory: _site
```

3. **Configure Cloudflare Pages**:
   - Set deployment source to "Direct Upload"
   - Disable Git integration builds
   - Keep custom domain configuration

4. **Add GitHub Secrets**:
   - `CLOUDFLARE_API_TOKEN`: From Cloudflare dashboard
   - `CLOUDFLARE_ACCOUNT_ID`: From Cloudflare dashboard

## Alternative: Quick Local Deploy Script

For manual deployments without CI:

```bash
#!/bin/bash
# deploy-to-cloudflare.sh

echo "Building OCaml project..."
make clean
make build-prod

echo "Preparing deployment..."
rm -rf _site
mkdir -p _site/_build/default/lib/client_main
mkdir -p _site/static

cp static/index.html _site/
cp static/404.html _site/
cp static/resume.pdf _site/static/
cp _build/default/lib/client_main/main.bc.js _site/_build/default/lib/client_main/

echo "Deploying to Cloudflare Pages..."
npx wrangler pages deploy _site \
  --project-name=ocaml-portfolio \
  --branch=main

echo "Deployment complete!"
```

## Testing Approach 3 (For Experimentation)

If you want to test native Cloudflare build support:

1. **Create test branch** with simplified build:
```json
{
  "build_command": "curl -L https://github.com/ocaml/opam/releases/download/2.1.5/opam-2.1.5-x86_64-linux -o opam && chmod +x opam && ./opam --version",
  "build_output_directory": "static"
}
```

2. **If opam executes**, progressively add:
   - opam init
   - switch creation
   - package installation
   - actual build

3. **Monitor for**:
   - Execution permissions issues
   - Timeout problems (10-minute limit)
   - Missing system dependencies

## Conclusion

**Recommended**: Use GitHub Actions for building + Cloudflare Pages for hosting (Approach 2)

**Rationale**:
- ✅ 100% reliable
- ✅ Full OCaml toolchain support
- ✅ Automated on Git push
- ✅ No Cloudflare build environment limitations
- ✅ Can run tests and checks before deployment

**Not Recommended**: Trying to install OCaml in Cloudflare's build environment
- ❌ Uncertain if binaries can execute in gVisor
- ❌ Cannot install system dependencies
- ❌ Risk of build timeouts
- ❌ No official support

## Action Items

1. **Immediate**: Continue using GitHub Pages OR
2. **Migration Path**: 
   - Keep GitHub Actions build process
   - Add Cloudflare Pages deployment step
   - Configure Direct Upload in Cloudflare dashboard
   - Test deployment pipeline

This approach gives you the benefits of Cloudflare's CDN and features while maintaining a reliable OCaml build process.