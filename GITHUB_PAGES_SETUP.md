# GitHub Pages Setup Guide

## Your Live Site URL
Your Flutter web app will be available at: **https://arnold254-25.github.io/bahm/**

## Steps to Enable GitHub Pages:

1. **Go to your GitHub repository**: https://github.com/Arnold254-25/bahm

2. **Click on "Settings"** (top right of repository page)

3. **Scroll down to "Pages"** in the left sidebar

4. **Configure GitHub Pages**:
   - **Source**: Select "GitHub Actions" from the dropdown menu
   - **Workflow**: After selecting GitHub Actions, a second dropdown will appear below it. Click this dropdown and select "Deploy to GitHub Pages" from the list of available workflows
   - **Branch**: Leave as default (it will use the built files from the workflow)

   **Visual Guide**:
   - First dropdown: Change from "Deploy from a branch" to "GitHub Actions"
   - Second dropdown: Appears below - this is where you select "Deploy to GitHub Pages"
   - No need to change branch selection as it uses the workflow output

5. **Wait for Deployment**:
   - The GitHub Actions workflow will automatically build and deploy your Flutter app when you push to master
   - You can monitor progress in the "Actions" tab of your repository

6. **Access Your Live Site**:
   - Once deployment is complete, visit: https://arnold254-25.github.io/bahm/
   - It may take a few minutes for the site to become available after deployment

## Manual Testing (Optional):
If you want to test locally before deployment:
```bash
flutter build web
flutter run -d chrome
```

## Troubleshooting:
- If the site doesn't load immediately, wait 5-10 minutes and refresh
- Check the GitHub Actions tab for any deployment errors
- Ensure all required files are committed to the master branch
- If you get "No such file or directory @ dir_chdir0 - /github/workspace/docs" error, make sure the GitHub Actions workflow is properly configured
