#!/bin/sh

# Build script with optional conditional build
# Usage:
#   ./build.sh        - Force rebuild (clean first)
#   ./build.sh fast   - Only build if dist doesn't exist

FORCE_BUILD=true

# Check if "fast" mode is enabled
if [ "$1" = "fast" ]; then
    if [ -d "./dist/web" ]; then
        echo "Dist directory exists, skipping build..."
        exit 0
    fi
    FORCE_BUILD=false
fi

# Clean dist directory if force build
if [ "$FORCE_BUILD" = "true" ]; then
    echo "Cleaning dist directory..."
    rm -rf ./dist
fi

# Create dist directory
mkdir -p dist/web

# Build Next.js app
echo "Building Next.js app..."
echo "Installing dependencies..."
npm install
echo "Building..."
npm run build

# Copy Next.js build output to dist/web
cp -r out/* dist/web/

# Ensure config.js placeholder is copied (will be replaced at runtime)
cp public/config.js dist/web/config.js

echo "Build completed successfully!"
