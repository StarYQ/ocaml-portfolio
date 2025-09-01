# GitHub Secrets Configuration for Cloudflare Workers Deployment

This document describes the required GitHub secrets for the automated Cloudflare Workers deployment pipeline.

## Required Secrets

The following secrets must be configured in your GitHub repository settings:

### 1. `CLOUDFLARE_API_TOKEN`
**Required:** Yes  
**Type:** Cloudflare API Token  
**Purpose:** Authenticates with Cloudflare API for Workers deployment

#### How to Create:
1. Go to [Cloudflare Dashboard](https://dash.cloudflare.com/profile/api-tokens)
2. Click "Create Token"
3. Use the "Custom token" template with these permissions:
   - **Account:** `Cloudflare Workers Scripts:Edit`
   - **Zone:** `Workers Routes:Edit` (if using custom domain)
4. Set IP filtering (optional but recommended for security)
5. Copy the generated token

#### Token Permissions Required:
- Account - Cloudflare Workers Scripts:Edit
- Account - Account Settings:Read
- User - User Details:Read
- Zone - Workers Routes:Edit (for custom domain routing)

### 2. `CLOUDFLARE_ACCOUNT_ID`
**Required:** Yes  
**Type:** String  
**Purpose:** Identifies your Cloudflare account for deployment

#### How to Find:
1. Go to [Cloudflare Dashboard](https://dash.cloudflare.com)
2. Select your domain
3. On the right sidebar, find "Account ID"
4. Copy the ID (looks like: `a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6`)

## Setting Up GitHub Secrets

### Via GitHub Web Interface:
1. Navigate to your repository on GitHub
2. Go to **Settings** → **Secrets and variables** → **Actions**
3. Click "New repository secret"
4. Add each secret:
   - Name: `CLOUDFLARE_API_TOKEN`
   - Value: Your Cloudflare API token
5. Repeat for `CLOUDFLARE_ACCOUNT_ID`

### Via GitHub CLI:
```bash
# Install GitHub CLI if needed
# brew install gh (macOS)
# or see: https://cli.github.com/

# Authenticate
gh auth login

# Set secrets
gh secret set CLOUDFLARE_API_TOKEN
gh secret set CLOUDFLARE_ACCOUNT_ID
```

## Verifying Configuration

After setting up the secrets, you can verify the deployment works by:

1. **Manual Workflow Trigger:**
   - Go to Actions tab
   - Select "Deploy to Cloudflare Workers"
   - Click "Run workflow"
   - Choose environment (production/preview)

2. **Automatic Deployment:**
   - Push to `main` branch
   - Workflow will automatically trigger

## Security Best Practices

1. **Token Scope:** Create tokens with minimal required permissions
2. **IP Restrictions:** Configure IP allowlists for API tokens when possible
3. **Token Rotation:** Rotate tokens periodically (every 90 days recommended)
4. **Audit Logs:** Monitor Cloudflare audit logs for unauthorized access
5. **Environment Separation:** Use different tokens for production/staging if needed

## Troubleshooting

### Common Issues:

#### "Authentication error" during deployment
- Verify `CLOUDFLARE_API_TOKEN` is correctly set
- Ensure token has required permissions
- Check token hasn't expired

#### "Account not found" error
- Verify `CLOUDFLARE_ACCOUNT_ID` is correct
- Ensure it's the Account ID, not Zone ID

#### "Worker not found" error
- Ensure `wrangler.toml` has correct worker name
- Verify worker exists or will be created

#### "Route conflict" error
- Check existing routes in Cloudflare dashboard
- Ensure no conflicting routes exist
- Verify domain is active in Cloudflare

## Environment-Specific Configuration

The workflow supports two environments:

### Production
- **Trigger:** Push to `main` branch
- **URL:** https://arnabb.dev
- **Worker Name:** ocaml-portfolio
- **Routes:** arnabb.dev/*, www.arnabb.dev/*

### Preview
- **Trigger:** Manual workflow dispatch
- **URL:** https://ocaml-portfolio-preview.workers.dev
- **Worker Name:** ocaml-portfolio-preview
- **Routes:** None (uses workers.dev subdomain)

## Additional Resources

- [Cloudflare Workers Documentation](https://developers.cloudflare.com/workers/)
- [Wrangler CLI Documentation](https://developers.cloudflare.com/workers/wrangler/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Encrypted Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)

## Support

For issues with:
- **Cloudflare Workers:** Check [Cloudflare Status](https://www.cloudflarestatus.com/)
- **GitHub Actions:** Check [GitHub Status](https://www.githubstatus.com/)
- **This Project:** Open an issue in the repository