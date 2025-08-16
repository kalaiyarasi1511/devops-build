pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: 'dev', url: 'https://github.com/kalaiyarasi1511/devops-build.git'
            }
        }
        stage('Build Docker') {
            steps {
                sh 'docker build -t kalaiyarasi15/dev:latest .'
            }
        }
        stage('Run Docker') {
            steps {
                sh 'docker run -d -p 3000:80 kalaiyarasi15/dev:latest || true'
            }
        }
    }
}
