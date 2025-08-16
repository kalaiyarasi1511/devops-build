pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "kalaiyarasi15/dev:latest"
        DOCKERHUB_CREDENTIALS = "dockerhub-creds" // Jenkins credentials ID for Docker Hub
        APP_PORT = "3001" // Change if needed
    }

    stages {
        stage('Clean Workspace') {
            steps {
                echo "Cleaning workspace..."
                deleteDir()  // Cleans the Jenkins workspace completely
            }
        }

        stage('Checkout Code') {
            steps {
                echo "Cloning dev branch..."
                git branch: 'dev', url: 'https://github.com/kalaiyarasi1511/devops-build.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Stop Existing Container') {
            steps {
                echo "Stopping existing container if running..."
                sh '''
                if [ $(docker ps -q -f name=dev-app) ]; then
                    docker stop dev-app
                    docker rm dev-app
                fi
                '''
            }
        }

        stage('Run Docker Container') {
            steps {
                echo "Running Docker container on port ${APP_PORT}..."
                sh "docker run -d --name dev-app -p ${APP_PORT}:80 ${DOCKER_IMAGE}"
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "Logging into Docker Hub and pushing image..."
                withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
