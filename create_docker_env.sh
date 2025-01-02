# -----------------------------------------------------------------------------
# 
# DESCRIPTION: This script build a docker file and push it to dockerhub
# 
# USAGE: ./concat_filecreate_docker_envs.sh env [tag]
# 
# AUTHOR: Max Schubach
# DATE: 2023-10-05
# LICENSE: MIT License
# -----------------------------------------------------------------------------
#!/bin/bash

# Get the environment from arguments
if [ -z "$1" ]; then
    echo "No environment provided. Usage: $0 <env> [tag]"
    exit 1
fi
env=$1

# Get the tag from arguments or use 'latest' if not provided
if [ -z "$2" ]; then
    tag="latest"
else
    tag=$2
fi

# This script will build and run a Docker container

# Define the image name
IMAGE_NAME="visze/dockerize_envs_$env:$tag"

# Build the Docker image
echo "Building Docker image..."
docker build -f envs/$env/Dockerfile -t $IMAGE_NAME .

# Check if the build was successful
if [ $? -eq 0 ]; then
    echo "Docker image built successfully."
else
    echo "Failed to build Docker image."
    exit 1
fi

# Run the Docker container
echo "Running Docker container..."
docker run -d $IMAGE_NAME

# Check if the container started successfully
if [ $? -eq 0 ]; then
    echo "Docker container started successfully."
else
    echo "Failed to start Docker container."
    exit 1
fi

# Push the Docker image to the repository
echo "Pushing Docker image to repository..."
docker push $IMAGE_NAME

# Check if the push was successful
if [ $? -eq 0 ]; then
    echo "Docker image pushed successfully."
else
    echo "Failed to push Docker image."
    exit 1
fi