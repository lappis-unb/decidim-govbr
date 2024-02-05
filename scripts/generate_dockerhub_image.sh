#!/bin/sh

# Script to Generate the DockerHub base image do decidim-govbr
# This script is meant to bem run from the base projetc directory with the command
# `bash scripts//generate_dockerhub_image.sh`

docker build -f Dockerfile.DockerHub -t lappis/decidim-govbr:v1 .
docker tag lappis/decidim-govbr:v1 lappis/decidim-govbr:v1-release


# After building the image, login to the DOckerHub account
# and push the image usign:
# `docker push lappis/decidim-govbr:v1-release`