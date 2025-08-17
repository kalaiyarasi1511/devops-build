pipeline {
    agent any

    environment {
        // Change this to your repo details
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-cred')  
        DOCKERHUB_USER = 'kalaiyarasi1511'   // your DockerHub username
        IMAGE_NAME = 'react-app'             // app name
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: "${env.BRANCH_NAME}", url: 'https://github.com/kalaiyarasi1511/devops-build.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME}:${env.BRANCH_NAME} ."
                }
            }
        }

        stage('Login to DockerHub') {
            steps {
                script {
                    sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_USER} --password-stdin"
                }
            }
        }

        stage('Push Image') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        sh "docker tag ${IMAGE_NAME}:${env.BRANCH_NAME} ${DOCKERHUB_USER}/${IMAGE_NAME}:dev"
                        sh "docker push ${DOCKERHUB_USER}/${IMAGE_NAME}:dev"
                    } else if (env.BRANCH_NAME == 'main' || env.BRANCH_NAME == 'master') {
                        sh "docker tag ${IMAGE_NAME}:${env.BRANCH_NAME} ${DOCKERHUB_USER}/${IMAGE_NAME}:latest"
                        sh "docker push ${DOCKERHUB_USER}/${IMAGE_NAME}:latest"
                    }
                }
            }
        }
    }

    post {
        always {
            sh "docker logout"
        }
    }
}
