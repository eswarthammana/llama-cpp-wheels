#!/bin/bash
set -euo pipefail

# Usage: ./build-wheels.sh <TAG> <PYVERSIONS>
# Example: ./build-wheels.sh v0.3.4-cu121 "cp38-* cp39-*"

TAG="${1:-main}"
PYVERSIONS="${2:-cp38-* cp39-* cp310-* cp311-* cp312-*}"

# Output directory
WHEEL_DIR="wheelhouse"
mkdir -p "$WHEEL_DIR"

# Enable cross-compilation for aarch64 and other platforms
echo "🔧 Enabling binfmt for cross-platform builds..."
docker run --rm --privileged tonistiigi/binfmt --install all

# Clone llama-cpp-python repo
echo "📥 Cloning llama-cpp-python..."
rm -rf llama-cpp-python
git clone https://github.com/abetlen/llama-cpp-python.git
cd llama-cpp-python

# Checkout the correct tag or branch
BASE_TAG="${TAG%-*}"
echo "🔀 Checking out tag: $TAG (base: $BASE_TAG)..."
git checkout "$BASE_TAG" || git checkout "$TAG" || git checkout main

# Build configuration
export CIBW_BUILD="$PYVERSIONS"
export CIBW_ARCHS="x86_64 aarch64"
export CIBW_SKIP="*-musllinux*"
export CIBW_ENVIRONMENT="CMAKE_ARGS='-DLLAMA_CUBLAS=OFF -DLLAMA_METAL=OFF -DLLAMA_OPENBLAS=ON -DLLAMA_NATIVE=OFF'"
export CMAKE_ARGS="-DLLAMA_CUBLAS=OFF -DLLAMA_METAL=OFF -DLLAMA_OPENBLAS=ON -DLLAMA_NATIVE=OFF"

# Optional: Set repair command if needed
# export CIBW_REPAIR_WHEEL_COMMAND="auditwheel repair -w {dest_dir} {wheel}"

# Optional: Print config before build
echo "🧱 Building wheels with configuration:"
echo "  CIBW_BUILD=$CIBW_BUILD"
echo "  CIBW_ARCHS=$CIBW_ARCHS"
echo "  TAG=$TAG"

# Run cibuildwheel
cibuildwheel --output-dir "../$WHEEL_DIR"

echo "✅ Build completed. Wheels are in ./$WHEEL_DIR/"
