pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials-id')
        DEV_IMAGE = 'kalaiyarasi15/dev:latest'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'dev', url: 'https://github.com/sriram-k-krishnan/devops-build.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DEV_IMAGE .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sh 'docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PSW'
                sh 'docker push $DEV_IMAGE'
            }
        }

        stage('Deploy to EC2') {
            steps {
                sh 'ssh -i /path/to/key.pem ubuntu@<EC2-PUBLIC-IP> "docker pull $DEV_IMAGE && docker stop react-app || true && docker rm react-app || true && docker run -d -p 80:80 --name react-app $DEV_IMAGE"'
            }
        }
    }
}
