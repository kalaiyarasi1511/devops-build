pipeline {
    agent any

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'dev', url: 'https://github.com/kalaiyarasi1511/devops-build.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t kalaiyarasi15/dev:latest .'
            }
        }

        stage('Push Docker Image') {
            steps {
                sh 'docker login -u kalaiyarasi15 -p dckr_pat_TmOqRtmE8ukIaiCBII0akszyN58'
                sh 'docker push kalaiyarasi15/dev:latest'
            }
        }

        stage('Run Container') {
            steps {
                sh 'docker stop dev || true'
                sh 'docker rm dev || true'
                sh 'docker run -d --name dev -p 3000:80 kalaiyarasi15/dev:latest'
            }
        }
    }
}
