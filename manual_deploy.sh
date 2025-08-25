#!/bin/bash
# Manual deployment script for GitHub Pages

echo "Building Flutter web app..."
flutter build web

echo "Creating gh-pages branch with built files..."
git checkout --orphan gh-pages
git rm -rf .

# Copy built files
cp -r build/web/* .
rm -rf build/

echo "Adding files to git..."
git add .
git commit -m "Deploy to GitHub Pages"

echo "Pushing to gh-pages branch..."
git push origin gh-pages --force

echo "Switching back to master branch..."
git checkout master

echo "Deployment complete! Visit: https://arnold254-25.github.io/bahm/"
