pipeline {
    agent any

    environment {
        // Docker Hub credentials stored in Jenkins
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials-id')
        // GitHub credentials stored in Jenkins
        GITHUB_CREDENTIALS = credentials('github-credentials')
        REPO_URL = 'https://github.com/kalaiyarasi1511/devops-build.git'
        IMAGE_NAME = 'kalaiyarasi15/devops-react'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: "${env.BRANCH_NAME}", 
                    url: "${REPO_URL}", 
                    credentialsId: 'github-credentials'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        sh "docker build -t ${IMAGE_NAME}:dev ."
                    } else if (env.BRANCH_NAME == 'main') {
                        sh "docker build -t ${IMAGE_NAME}:prod ."
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin"
                    if (env.BRANCH_NAME == 'dev') {
                        sh "docker push ${IMAGE_NAME}:dev"
                    } else if (env.BRANCH_NAME == 'main') {
                        sh "docker push ${IMAGE_NAME}:prod"
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    // Example: You can use SSH + docker pull to deploy
                    if (env.BRANCH_NAME == 'dev') {
                        sh "ssh -i /path/to/dev-key.pem ubuntu@DEV_EC2_IP 'docker pull ${IMAGE_NAME}:dev && docker run -d -p 80:80 --name react-app ${IMAGE_NAME}:dev'"
                    } else if (env.BRANCH_NAME == 'main') {
                        sh "ssh -i /path/to/prod-key.pem ubuntu@PROD_EC2_IP 'docker pull ${IMAGE_NAME}:prod && docker run -d -p 80:80 --name react-app ${IMAGE_NAME}:prod'"
                    }
                }
            }
        }
    }

    post {
        always {
            sh "docker logout"
        }
        success {
            echo "Pipeline completed successfully for branch ${env.BRANCH_NAME}"
        }
        failure {
            echo "Pipeline failed for branch ${env.BRANCH_NAME}"
        }
    }
}
