pipeline {
  agent any

  environment {
    DOCKERHUB_USER = 'pborade90'
    IMAGE_NAME = 'myapp'
    GIT_COMMIT = ''
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        script {
          GIT_COMMIT = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
        }
      }
    }

    stage('Docker Build & Push') {
      steps {
        script {
          sh """
            docker buildx create --use || true
            docker buildx build --platform linux/amd64 \
              -t ${DOCKERHUB_USER}/${IMAGE_NAME}:${GIT_COMMIT} . \
              --push
          """
        }
      }
    }

    stage('Deploy with Ansible') {
      steps {
        script {
          sh """
            ansible-playbook -i ansible/hosts.ini ansible/deploy.yml -e git_commit=${GIT_COMMIT}
          """
        }
      }
    }
  }

  post {
    failure {
      echo "❌ Pipeline failed"
    }
    success {
      echo "✅ Deployed to EC2 at IP: 34.234.124.139"
    }
  }
}
