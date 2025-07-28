# DevOps Case Study: CI/CD Pipeline for Node.js App on AWS

This project demonstrates a full DevOps pipeline for a Node.js application using GitHub, Jenkins, Docker, Terraform, Ansible, and AWS EC2.

## 📄 Report

Detailed technical report is available in [REPORT.md](./REPORT.md).

---

## Tech Stack

- **Git & GitHub** – Version control and collaboration
- **Jenkins** – Continuous Integration and Deployment
- **Docker & DockerHub** – Containerization and image registry
- **Terraform** – Infrastructure as Code (IaC) on AWS
- **Ansible** – Configuration management and deployment
- **AWS EC2** – Compute resources on the cloud

---

## Project Structure

```
.
├── ansible/
│   ├── deploy.yml
│   └── hosts.ini
├── infra/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── scripts/
│   ├── build_and_push.sh
│   └── cleanup.sh
├── src/
│   └── index.js
├── Dockerfile
├── Jenkinsfile
├── REPORT.md
├── README.md
└── screenshots/
```

---

## Features

- GitHub branching and pull request strategy
- Dockerized Node.js app pushed to DockerHub
- Terraform-based provisioning of AWS VPC and EC2
- Ansible deployment with Docker container
- Jenkins pipeline automating the full workflow

---

## Setup Instructions

### Prerequisites

- AWS Free Tier account
- Installed: Git, Docker, Terraform, Ansible, Jenkins
- DockerHub account

### Run the Project

1. Clone the repo:
   ```bash
   git clone https://github.com/yourusername/devops-case-study.git
   git checkout develop
   cd devops-case-study
   ```

2. Build and push Docker image:
   ```bash
   ./scripts/build_and_push.sh
   ```

3. Provision infra using Terraform:
   ```bash
   cd infra
   terraform init
   terraform apply -auto-approve
   ```

4. Deploy app with Ansible:
   ```bash
   ansible-playbook -i ansible/hosts.ini ansible/deploy.yml
   ```

5. Trigger the Jenkins pipeline or push a change to `develop` branch.

---


## Cleanup

Run the cleanup script to prune unused Docker resources:
```bash
./scripts/cleanup.sh
```

---

## License

This project is for educational purposes.
