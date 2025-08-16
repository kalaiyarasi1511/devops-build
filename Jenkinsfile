pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "kalaiyarasi15/dev:latest"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials-id')
        GIT_CREDENTIALS = credentials('github-credentials')
        EC2_USER = "ubuntu"
        EC2_IP = "3.80.23.124"   // replace with your EC2 public IP
        SSH_KEY = credentials('ec2-ssh-key') // Jenkins credential for EC2 private key
    }

    stages {
        stage('Checkout SCM') {
            steps {
                git branch: 'dev',
                    url: 'https://github.com/kalaiyarasi1511/devops-build.git',
                    credentialsId: 'github-credentials'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}"
                    sh "docker logout"
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    sh """
                    ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${EC2_USER}@${EC2_IP} '
                        docker pull ${DOCKER_IMAGE} &&
                        docker stop react-app || true &&
                        docker rm react-app || true &&
                        docker run -d -p 80:80 --name react-app ${DOCKER_IMAGE}
                    '
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline for DEV branch completed successfully!"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
