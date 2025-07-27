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
          withCredentials([usernamePassword(
            credentialsId: 'docker-hub-creds',
            usernameVariable: 'DOCKER_USERNAME',
            passwordVariable: 'DOCKER_PASSWORD'
          )]) {
            sh '''
              echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
              docker buildx create --use || true
              docker buildx inspect --bootstrap
              docker buildx build --platform linux/amd64 -t pborade90/myapp:$GIT_COMMIT --push .
            '''
          }
        }
      }
    }

    stage('Terraform Apply') {
      steps {
        dir('infra') {
          withCredentials([usernamePassword(
            credentialsId: 'aws-credentials',
            usernameVariable: 'AWS_ACCESS_KEY_ID',
            passwordVariable: 'AWS_SECRET_ACCESS_KEY'
          )]) {
            sh '''
              export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
              export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
              terraform init
              terraform apply -auto-approve
            '''
          }
        }
      }
    }

    stage('Ansible Deploy') {
      steps {
        script {
          def ip = sh(script: 'cd infra && terraform output -raw public_ip', returnStdout: true).trim()
          writeFile file: 'ansible/hosts.ini', text: "[app]\n${ip}"
        }

        sh '''
          ANSIBLE_HOST_KEY_CHECKING=False \
          ansible-playbook -i ansible/hosts.ini ansible/deploy.yml \
          --private-key /var/lib/jenkins/.ssh/my-new-key.pem \
          -u ubuntu \
          -o StrictHostKeyChecking=no
        '''
      }
    }
  }
}
