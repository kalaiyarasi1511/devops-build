pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-cred')   // corrected
        DEV_IMAGE = "kalaiyarasi15/dev"
        PROD_IMAGE = "kalaiyarasi15/prod"
    }

    triggers {
        githubPush()
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: "${env.BRANCH_NAME}",
                    url: 'https://github.com/kalaiyarasi1511/devops-build.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image for branch: ${env.BRANCH_NAME}"
                    sh "docker build -t ${env.BRANCH_NAME}-app ."
                }
            }
        }

        stage('Login to DockerHub') {
            steps {
                script {
                    sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin"
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        echo "Pushing to DEV repo..."
                        sh """
                            docker tag ${env.BRANCH_NAME}-app ${DEV_IMAGE}:latest
                            docker push ${DEV_IMAGE}:latest
                        """
                    } else if (env.BRANCH_NAME == 'main') {
                        echo "Pushing to PROD repo..."
                        sh """
                            docker tag ${env.BRANCH_NAME}-app ${PROD_IMAGE}:latest
                            docker push ${PROD_IMAGE}:latest
                        """
                    } else {
                        echo "Not pushing, branch is not dev or main."
                    }
                }
            }
        }

        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                echo "🚀 Deploy step for PROD (add deployment script here)"
            }
        }
    }

    post {
        always {
            script {
                sh 'docker logout || true'
            }
            cleanWs()
        }
    }
}
