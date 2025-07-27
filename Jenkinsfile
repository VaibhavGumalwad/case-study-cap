pipeline {
  agent any

  environment {
    GIT_COMMIT = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build & Push Docker') {
      steps {
        script {
          withCredentials([[$class: 'UsernamePasswordMultiBinding',
            credentialsId: 'aws-credentials',
            usernameVariable: 'AWS_ACCESS_KEY_ID',
            passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {

            sh 'docker buildx create --use || true'
            sh 'docker buildx inspect --bootstrap'
            sh 'docker buildx build --platform linux/amd64 -t pborade90/myapp:$GIT_COMMIT --push .'
          }
        }
      }
    }

    stage('Terraform Apply') {
      steps {
        dir('infra') {
          sh 'terraform init'
          sh 'terraform apply -auto-approve'
        }
      }
    }

    stage('Ansible Deploy') {
      steps {
        script {
          def ip = sh(script: 'cd infra && terraform output -raw aws_eip.ip.public_ip', returnStdout: true).trim()
          writeFile file: 'ansible/hosts.ini', text: "[app]\n${ip}"
        }
        sh 'ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ansible/hosts.ini ansible/deploy.yml'
      }
    }
  }
}
