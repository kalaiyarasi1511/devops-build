pipeline {
  agent any

  options {
    timestamps()
    disableConcurrentBuilds()
  }

  parameters {
    booleanParam(name: 'PUSH_LATEST', defaultValue: false, description: 'Also push :latest')
  }

  environment {
    IMAGE_REPO_DEV  = 'kalaiyarasi15/react-dev'
    IMAGE_REPO_PROD = 'kalaiyarasi15/react-prod'
    IMAGE_REPO      = ''
    IMAGE_TAG       = "${BUILD_NUMBER}"
  }

  triggers { pollSCM('@hourly') }

  stages {
    stage('Select Image Repo (by branch)') {
      steps {
        script {
          if (env.BRANCH_NAME == 'dev') {
            env.IMAGE_REPO = env.IMAGE_REPO_DEV
          } else if (env.BRANCH_NAME == 'main' || env.BRANCH_NAME == 'master') {
            env.IMAGE_REPO = env.IMAGE_REPO_PROD
          } else {
            env.IMAGE_REPO = env.IMAGE_REPO_DEV
          }
          echo "Repo: ${env.IMAGE_REPO}"
        }
      }
    }

    stage('Checkout Code') {
      steps {
        git branch: "${env.BRANCH_NAME ?: 'dev'}", url: 'https://github.com/kalaiyarasi1511/devops-build.git'
      }
    }

    stage('Docker Build') {
      steps {
        sh "docker build -t ${env.IMAGE_REPO}:${env.IMAGE_TAG} ."
      }
    }

    stage('Docker Login & Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
          sh 'echo "$DH_PASS" | docker login -u "$DH_USER" --password-stdin'
          sh "docker push ${env.IMAGE_REPO}:${env.IMAGE_TAG}"
          script {
            if (params.PUSH_LATEST) {
              sh """
                docker tag ${env.IMAGE_REPO}:${env.IMAGE_TAG} ${env.IMAGE_REPO}:latest
                docker push ${env.IMAGE_REPO}:latest
              """
            }
          }
        }
      }
    }

    stage('Deploy on EC2') {
      steps {
        script {
          def cname = (env.IMAGE_REPO == env.IMAGE_REPO_PROD) ? 'prod-app' : 'react-app'
          sh """
            docker rm -f ${cname} || true
            docker run -d --name ${cname} -p 80:80 ${env.IMAGE_REPO}:${env.IMAGE_TAG}
            docker image prune -f || true
          """
        }
      }
    }
  }

  post {
    success {
      script {
        def ip = sh(returnStdout: true, script: "curl -s http://169.254.169.254/latest/meta-data/public-ipv4 || true").trim()
        echo "✅ Deployed: http://${ip}/"
      }
    }
    failure { echo '❌ Pipeline failed.' }
    always { sh 'docker logout || true' }
  }
}
