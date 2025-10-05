# Deployment Configuration

## GitHub Pages Setup

This repository uses GitHub Pages to serve the website from the `docs/` folder.

### Current Configuration

**Source:** Deploy from a branch
**Branch:** `main`
**Folder:** `/docs`

**Website URL:** https://big-life-lab.github.io/phes-ef-scope-private/

### How Deployment Works

1. **Manual workflow trigger** - Team member clicks "Run workflow" on GitHub
2. **GitHub Actions builds** - Extracts CSVs, validates, renders Quarto
3. **Commits to docs/** - Workflow commits updated HTML to `docs/` folder
4. **GitHub Pages serves** - Automatically detects `docs/` changes and deploys

### No Conflicts

- ✅ Manual workflow (`workflow_dispatch`) - Only runs when triggered
- ✅ No auto-deploy on push - Old workflow was deleted
- ✅ No concurrent builds - GitHub Actions queues workflows

### Verifying Configuration

To check GitHub Pages settings:
1. Go to repository Settings
2. Click "Pages" in left sidebar
3. Verify:
   - Source: "Deploy from a branch"
   - Branch: `main`
   - Folder: `/docs`

### Alternative: GitHub Actions Deployment

If you want to deploy directly from Actions (skip the commit step):

1. Change Pages source to "GitHub Actions"
2. Update workflow to use `actions/upload-pages-artifact`
3. Add `actions/deploy-pages` step

**Current approach is simpler and preserves git history of published content.**

---

## Troubleshooting

### Multiple workflows running?
- Check: https://github.com/Big-Life-Lab/phes-ef-scope-private/actions
- Our workflow: "Update Website" (manual trigger only)
- No other workflows should exist

### Website not updating?
1. Check workflow completed successfully (green checkmark)
2. Wait 2-3 minutes for Pages to rebuild
3. Hard refresh browser (Ctrl+Shift+R / Cmd+Shift+R)
4. Check Pages deployment: Settings → Pages → View deployments

### Want to disable manual workflow?
- Delete or rename `.github/workflows/update-website.yml`
