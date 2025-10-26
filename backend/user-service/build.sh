#!/usr/bin/env bash
# Render.com build script for User Service

set -o errexit

echo "🔨 Building User Service..."

# Install Maven if not available
if ! command -v mvn &> /dev/null; then
    echo "📦 Installing Maven..."
    curl -sL https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz | tar xz
    export PATH="$PWD/apache-maven-3.9.6/bin:$PATH"
fi

# Build the application
echo "📦 Running Maven build..."
mvn clean package -DskipTests

echo "✅ User Service build complete!"
