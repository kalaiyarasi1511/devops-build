pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "kalaiyarasi15/dev:latest"
        DOCKERHUB_CREDENTIALS = "dockerhub-creds" // Add your Docker Hub credentials in Jenkins
    }

    stages {

        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Code') {
            steps {
                checkout([$class: 'GitSCM',
                          branches: [[name: '*/dev']],
                          userRemoteConfigs: [[url: 'https://github.com/kalaiyarasi1511/devops-build.git']]])
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", 
                                                  usernameVariable: 'DOCKER_USER', 
                                                  passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Run Docker Container (Optional)') {
            steps {
                script {
                    // Stop and remove any running container using this image
                    sh "docker ps -q --filter ancestor=${DOCKER_IMAGE} | xargs -r docker stop"
                    sh "docker ps -aq --filter ancestor=${DOCKER_IMAGE} | xargs -r docker rm"

                    // Run the container on port 3001
                    sh "docker run -d -p 3001:80 ${DOCKER_IMAGE}"
                }
            }
        }

    }

    post {
        always {
            echo 'Pipeline finished!'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
