#!/bin/bash
set -e
TAG=$1
PYVERSIONS=$2

mkdir -p wheelhouse
docker run --rm --privileged tonistiigi/binfmt --install all

git clone https://github.com/abetlen/llama-cpp-python.git
cd llama-cpp-python
BASE_TAG="${TAG%-*}"
git checkout "$BASE_TAG" || git checkout "$TAG" || git checkout main

CIBW_BUILD="${PYVERSIONS:-cp38-* cp39-* cp310-* cp311-* cp312-*}" CIBW_ARCHS="x86_64 aarch64" CIBW_SKIP="*-musllinux*" CIBW_ENVIRONMENT="CMAKE_ARGS='-DLLAMA_CUBLAS=OFF -DLLAMA_METAL=OFF -DLLAMA_OPENBLAS=ON -DLLAMA_NATIVE=OFF'" CMAKE_ARGS="-DLLAMA_CUBLAS=OFF -DLLAMA_METAL=OFF -DLLAMA_OPENBLAS=ON -DLLAMA_NATIVE=OFF"     cibuildwheel --output-dir ../wheelhouse
