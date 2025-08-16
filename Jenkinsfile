pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials-id')
        SSH_KEY = credentials('ec2-ssh-key-id')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'dev', url: 'https://github.com/kalaiyarasi1511/devops-build.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t kalaiyarasi15/dev:latest .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sh '''
                    echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS --password-stdin
                    docker push kalaiyarasi15/dev:latest
                '''
            }
        }

        stage('Deploy to EC2') {
            steps {
                sh '''
                    ssh -i /var/jenkins_home/.ssh/id_rsa -o StrictHostKeyChecking=no ubuntu@YOUR_EC2_PUBLIC_IP '
                        docker pull kalaiyarasi15/dev:latest
                        docker stop react-app || true
                        docker rm react-app || true
                        docker run -d -p 3000:3000 --name react-app kalaiyarasi15/dev:latest
                    '
                '''
            }
        }
    }

    post {
        failure {
            echo "Pipeline failed!"
        }
    }
}
