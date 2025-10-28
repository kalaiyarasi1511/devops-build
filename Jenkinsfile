pipeline {
  agent any

  environment {
    // Jenkins credential with your Docker Hub username/password
    // -> Manage Jenkins > Credentials > (Global) > Username with password
    // ID must be: dockerhub-creds
    DOCKERHUB = credentials('dockerhub-creds')
  }

  options {
    timestamps()
  }

  stages {
    stage('Select Image Repo (by branch)') {
      steps {
        script {
          // BRANCH_NAME exists automatically in Multibranch pipelines.
          // Fallback to 'dev' if not present (e.g., classic pipeline).
          def branch = env.BRANCH_NAME ?: 'dev'

          // Map branch -> Docker Hub repo
          if (branch == 'dev') {
            env.IMAGE_REPO = 'kalaiyarasi15/react-dev'
          } else if (branch == 'main' || branch == 'master') {
            env.IMAGE_REPO = 'kalaiyarasi15/react-prod'
          } else {
            // Optional: treat all other branches as dev
            env.IMAGE_REPO = 'kalaiyarasi15/react-dev'
          }

          echo "Using image repo: ${env.IMAGE_REPO}"
        }
      }
    }

    stage('Checkout Code') {
      steps {
        // Adjust branch as needed; in Multibranch this is done for you.
        git branch: 'dev', url: 'https://github.com/kalaiyarasi1511/devops-build.git'
      }
    }

    stage('Docker Build') {
      steps {
        sh """
          docker build -t ${IMAGE_REPO}:${BUILD_NUMBER} .
        """
      }
    }

    stage('Docker Login & Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                                          usernameVariable: 'DH_USER',
                                          passwordVariable: 'DH_PASS')]) {
          sh """
            echo "\$DH_PASS" | docker login -u "\$DH_USER" --password-stdin
            docker push ${IMAGE_REPO}:${BUILD_NUMBER}
            # Try to tag/push :latest too; if your repo blocks 'latest', ignore the error
            docker tag ${IMAGE_REPO}:${BUILD_NUMBER} ${IMAGE_REPO}:latest || true
            docker push ${IMAGE_REPO}:latest || true
          """
        }
      }
    }

    stage('Deploy on EC2') {
      steps {
        // Runs container on the Jenkins node/EC2 where Docker is installed.
        // If you deploy elsewhere, replace with SSH or your deployment step.
        sh """
          docker rm -f react-app || true
          docker pull ${IMAGE_REPO}:${BUILD_NUMBER}
          docker run -d --name react-app -p 80:80 ${IMAGE_REPO}:${BUILD_NUMBER}
        """
        echo "Deployed ${IMAGE_REPO}:${BUILD_NUMBER} -> http://<65.2.167.227>"
      }
    }
  }

  post {
    always {
      sh 'docker logout || true'
    }
    success {
      echo '✅ Pipeline successful.'
    }
    failure {
      echo '❌ Pipeline failed.'
    }
  }
}
