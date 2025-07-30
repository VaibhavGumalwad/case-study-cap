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
              docker build -t pborade90/myapp:$GIT_COMMIT .
              docker push pborade90/myapp:$GIT_COMMIT
            '''
          }
        }
      }
    }

    stage('Fetch Instance IP from Terraform') {
      steps {
        dir('infra') {
          script {
            withCredentials([usernamePassword(
              credentialsId: 'aws-credentials',
              usernameVariable: 'AWS_ACCESS_KEY_ID',
              passwordVariable: 'AWS_SECRET_ACCESS_KEY'
            )]) {
              sh '''
                export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                terraform init -input=false
              '''
              env.INSTANCE_IP = sh(
                script: 'terraform output -raw public_ip',
                returnStdout: true
              ).trim()
            }
          }
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
            writeFile file: 'ansible/hosts.ini', text: """
[app]
44.209.57.203 ansible_user=ubuntu ansible_ssh_private_key_file=${SSH_KEY}
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
