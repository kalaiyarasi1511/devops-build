#!/bin/bash
IMAGE_NAME="your-dockerhub-username/devops-react"
docker run -d -p 80:80 --name react-app $IMAGE_NAME:latest
