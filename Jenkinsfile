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

    stage('Wait for SSH') {
      steps {
        script {
          def ip = sh(script: 'cd infra && terraform output -raw public_ip', returnStdout: true).trim()
          echo "Waiting for SSH on ${ip}..."
          sh """
            for i in {1..20}; do
              nc -zv ${ip} 22 && echo 'SSH is up!' && exit 0
              echo 'Waiting for SSH...'
              sleep 10
            done
            echo 'Timeout waiting for SSH'
            exit 1
          """
        }
      }
    }

    stage('Ansible Deploy') {
      steps {
        withCredentials([sshUserPrivateKey(
          credentialsId: 'my-ec2-ssh-key',
          keyFileVariable: 'SSH_KEY'
        )]) {
          script {
            def ip = sh(script: 'cd infra && terraform output -raw public_ip', returnStdout: true).trim()
            writeFile file: 'ansible/hosts.ini', text: """[app]
${ip} ansible_user=ubuntu ansible_ssh_private_key_file=${SSH_KEY}
"""
          }

          sh '''
            chmod 600 $SSH_KEY
            ANSIBLE_HOST_KEY_CHECKING=False \
            ansible-playbook -i ansible/hosts.ini ansible/deploy.yml
          '''
        }
      }
    }
  }
}
