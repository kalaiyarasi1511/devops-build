pipeline {
  agent any

  options {
    timestamps()
    ansiColor('xterm')
    disableConcurrentBuilds()
  }

  parameters {
    booleanParam(name: 'PUSH_LATEST', defaultValue: false, description: 'Also push the :latest tag (turn on only if Docker Hub allows it).')
  }

  environment {
    // Map branches to repos
    IMAGE_REPO_DEV  = 'kalaiyarasi15/react-dev'
    IMAGE_REPO_PROD = 'kalaiyarasi15/react-prod'
    // Will be set dynamically below
    IMAGE_REPO      = ''
    IMAGE_TAG       = "${BUILD_NUMBER}"
  }

  triggers {
    // Use webhook if configured; Poll SCM is a safe fallback
    pollSCM('@hourly')
  }

  stages {

    stage('Select Image Repo (by branch)') {
      steps {
        script {
          if (env.BRANCH_NAME == 'dev') {
            env.IMAGE_REPO = env.IMAGE_REPO_DEV
          } else if (env.BRANCH_NAME == 'main' || env.BRANCH_NAME == 'master') {
            env.IMAGE_REPO = env.IMAGE_REPO_PROD
          } else {
            // Default to dev repo for any other branch
            env.IMAGE_REPO = env.IMAGE_REPO_DEV
          }
          echo "Target Docker repository: ${env.IMAGE_REPO}"
        }
      }
    }

    stage('Checkout Code') {
      steps {
        // If this is a Multibranch job, Jenkins provides BRANCH_NAME automatically.
        // For single pipeline jobs, lock to dev or main as needed.
        git branch: "${env.BRANCH_NAME ?: 'dev'}", url: 'https://github.com/kalaiyarasi1511/devops-build.git'
      }
    }

    stage('Docker Build') {
      steps {
        script {
          echo "📦 Building image ${env.IMAGE_REPO}:${env.IMAGE_TAG}"
          sh """
            docker build -t ${env.IMAGE_REPO}:${env.IMAGE_TAG} .
          """
        }
      }
    }

    stage('Docker Login & Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                                          usernameVariable: 'DH_USER',
                                          passwordVariable: 'DH_PASS')]) {
          sh '''
            echo "$DH_PASS" | docker login -u "$DH_USER" --password-stdin
          '''
          sh """
            echo "⬆️ Pushing tag: ${IMAGE_REPO}:${IMAGE_TAG}"
            docker push ${IMAGE_REPO}:${IMAGE_TAG}
          """
          script {
            if (params.PUSH_LATEST) {
              sh """
                echo "Tagging and pushing :latest"
                docker tag ${IMAGE_REPO}:${IMAGE_TAG} ${IMAGE_REPO}:latest
                docker push ${IMAGE_REPO}:latest
              """
            } else {
              echo "Skipping :latest push (PUSH_LATEST=false)."
            }
          }
        }
      }
    }

    stage('Deploy on EC2') {
      steps {
        script {
          // Container name based on branch
          def cname = (env.IMAGE_REPO == env.IMAGE_REPO_PROD) ? 'prod-app' : 'react-app'

          echo "🚀 Deploying container ${cname} from ${IMAGE_REPO}:${IMAGE_TAG}"

          sh """
            # stop & remove old container if exists
            docker rm -f ${cname} || true

            # run fresh container on port 80
            docker run -d --name ${cname} -p 80:80 ${IMAGE_REPO}:${IMAGE_TAG}

            # optional: clean up dangling images
            docker image prune -f || true
          """
        }
      }
    }
  }

  post {
    success {
      script {
        def url = sh(returnStdout: true, script: "curl -s http://169.254.169.254/latest/meta-data/public-ipv4 || true").trim()
        echo "✅ Deployed successfully!"
        echo "App URL: http://${url}/"
      }
    }
    failure {
      echo '❌ Pipeline failed. Check the stage logs above.'
    }
    always {
      sh 'docker logout || true'
    }
  }
}
