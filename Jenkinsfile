pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-cred')   // Jenkins credentials ID for DockerHub
        DOCKERHUB_REPO = "kalaiyarasi1511/devops-build"         // Replace with your DockerHub repo
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: "${env.BRANCH_NAME}", url: 'https://github.com/kalaiyarasi1511/devops-build.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image..."
                    sh "docker build -t ${DOCKERHUB_REPO}:${env.BRANCH_NAME}-${BUILD_NUMBER} ."
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    echo "Pushing image to DockerHub..."
                    sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin"
                    sh "docker push ${DOCKERHUB_REPO}:${env.BRANCH_NAME}-${BUILD_NUMBER}"
                }
            }
        }

        stage('Deploy Container') {
            when {
                branch 'dev'
            }
            steps {
                script {
                    echo "Running container for DEV environment..."
                    sh '''
                    docker rm -f dev-container || true
                    docker run -d --name dev-container -p 3000:80 ${DOCKERHUB_REPO}:${BRANCH_NAME}-${BUILD_NUMBER}
                    '''
