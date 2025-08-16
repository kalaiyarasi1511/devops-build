pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "kalaiyarasi15/dev:latest"
        DOCKERHUB_CREDENTIALS = "dockerhub-creds" // Jenkins Docker Hub credentials ID
        GIT_REPO = "https://github.com/kalaiyarasi1511/devops-build.git"
        GIT_BRANCH = "dev"
    }

    stages {

        stage('Clean Workspace') {
            steps {
                echo "Cleaning workspace..."
                deleteDir() // removes all files in workspace
            }
        }

        stage('Checkout Code') {
            steps {
                echo "Checking out ${GIT_BRANCH} branch from GitHub..."
                git branch: "${GIT_BRANCH}", url: "${GIT_REPO}"
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "Logging in and pushing Docker image..."
                withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning workspace after build..."
            deleteDir()
        }
        success {
            echo "Pipeline finished successfully!"
        }
        failure {
            echo "Pipeline failed. Check logs."
        }
    }
}
