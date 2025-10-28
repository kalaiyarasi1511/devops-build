pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        IMAGE_NAME = "kalaiyarasi15/react-dev"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'dev', url: 'https://github.com/kalaiyarasi1511/devops-build.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "📦 Building Docker image..."
                    sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} ."
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    echo "🔑 Logging in to DockerHub..."
                    sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin"

                    echo "⬆️ Pushing image to DockerHub..."
                    sh """
                        docker push ${IMAGE_NAME}:${BUILD_NUMBER}
                        docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${IMAGE_NAME}:latest
                        docker push ${IMAGE_NAME}:latest
                    """
                }
            }
        }

        stage('Deploy Container (Dev)') {
            steps {
                script {
                    echo "🚀 Deploying new container..."
                    sh """
                        docker rm -f react-app || true
                        docker run -d --name react-app -p 80:80 ${IMAGE_NAME}:latest
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ Dev Deployment successful! App is live at http://<EC2-PUBLIC-IP>"
        }
        failure {
            echo "❌ Deployment failed. Check logs."
        }
    }
}
