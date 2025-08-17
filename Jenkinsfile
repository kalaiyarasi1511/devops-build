pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-cred')   // change ID to your DockerHub credentials ID
        IMAGE_NAME = "kalaiyarasi1511/devops-build"             // change to your repo name
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: "${env.BRANCH_NAME}", url: 'https://github.com/kalaiyarasi1511/devops-build.git'
            }
        }

        stage('Build') {
            steps {
                script {
                    echo "Building Docker image for branch: ${env.BRANCH_NAME}"
                    sh "docker build -t ${IMAGE_NAME}:${env.BRANCH_NAME}-${BUILD_NUMBER} ."
                }
            }
        }

        stage('Login to DockerHub') {
            steps {
                script {
                    sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin"
                }
            }
        }

        stage('Push Image') {
            steps {
                script {
                    echo "Pushing Docker image to DockerHub"
                    sh "docker push ${IMAGE_NAME}:${env.BRANCH_NAME}-${BUILD_NUMBER}"

                    // Latest tag only for main/master
                    if (env.BRANCH_NAME == "main" || env.BRANCH_NAME == "master") {
                        sh "docker tag ${IMAGE_NAME}:${env.BRANCH_NAME}-${BUILD_NUMBER} ${IMAGE_NAME}:latest"
                        sh "docker push ${IMAGE_NAME}:latest"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline executed successfully ✅"
        }
        failure {
            echo "Pipeline failed ❌"
        }
    }
}
