#!/usr/bin/env bash
# Render.com build script for Frontend

set -o errexit

echo "🔨 Building Frontend..."

# Install pnpm if not available
if ! command -v pnpm &> /dev/null; then
    echo "📦 Installing pnpm..."
    npm install -g pnpm
fi

# Install dependencies
echo "📦 Installing dependencies..."
pnpm install --frozen-lockfile

# Build the application
echo "🏗️ Building production bundle..."
pnpm run build

echo "✅ Frontend build complete!"
