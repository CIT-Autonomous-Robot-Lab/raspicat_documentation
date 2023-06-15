#!/bin/bash

if ! command -v docker &> /dev/null; then
    echo "Docker is not installed on your system."
    echo "Please install Docker"
    echo "\n"

else
    :
fi

docker run --rm -p 8000:8000 --name mkdocs-serve -v $(pwd):/app ghcr.io/uhobeike/mkdocs-serve:latest