# nasadmin-project-repo
Network and Systems Administration subject project 

🚀 AWS + Terraform + Ansible + Docker Deployment Pipeline
Automated EC2 provisioning and Docker‑based application deployment using Terraform, Ansible, and GitHub Actions.

This project delivers a fully automated CI/CD pipeline that:

Provisions an EC2 instance using Terraform

Copies the application (webapp/) from GitHub runner to EC2

Installs Docker on EC2

Builds a Docker image from the copied code

Stops any existing container

Deploys a fresh container with the updated application

📦 Project Structure
Code
project-root/
│
├── terraform/
│   ├── main.tf
│   ├── outputs.tf
│   ├── variables.tf
│   ├── inventory.ini
│   └── id_rsa.pem (downloaded from S3 during workflow)
│
├── ansible/
│   ├── playbook.yml
│   └── roles/
│       └── docker/
│           └── tasks/
│               └── main.yml
│
├── webapp/
│   ├── Dockerfile
│   └── app.py
│
└── .github/workflows/deploy.yml
🧩 Components Explained
1. Terraform
Terraform provisions the AWS infrastructure:

EC2 instance

Security groups

SSH access

Outputs the EC2 public IP

Generates an Ansible inventory file dynamically

Terraform ensures your infrastructure is consistent, repeatable, and version‑controlled.

2. GitHub Actions
GitHub Actions acts as the CI/CD orchestrator:

Runs on every push to the development branch

Authenticates with AWS

Executes Terraform

Downloads EC2 SSH key from S3

Installs Ansible + Docker collection

Runs Ansible playbook against the newly created EC2 instance

This creates a fully automated deployment pipeline.

3. Ansible
Ansible handles configuration and deployment on EC2:

Copies the webapp/ folder to EC2

Installs Docker

Builds Docker image

Stops old container

Deploys new container

Ansible ensures deployments are idempotent, predictable, and safe.

4. Docker
Docker runs your application inside a container:

Image built from webapp/Dockerfile

Container named webapp

Exposes port 80

This makes your application portable and easy to update.

🔄 End‑to‑End Execution Flow
Step 1 — Developer pushes code
Push to the development branch triggers GitHub Actions.

Step 2 — GitHub Actions starts
Checks out repository

Configures AWS credentials

Runs Terraform to create EC2

Retrieves EC2 public IP

Downloads SSH key from S3

Installs Ansible + Docker collection

Step 3 — Ansible connects to EC2
Using:

terraform/inventory.ini

terraform/id_rsa.pem

Step 4 — Ansible Docker role executes
Copies webapp/ to EC2

Installs Docker

Builds Docker image

Stops old container

Deploys new container

Step 5 — Application is live
Your updated app is now running inside a Docker container on EC2.

🛠 Key Logic in Deployment
Copy → Build → Deploy
1. Copy webapp folder
From GitHub runner → EC2:

yaml
copy:
  src: webapp/
  dest: /home/ec2-user/webapp/
2. Install Docker
Ensures Docker is available:

yaml
yum:
  name: docker
  state: present
3. Build Docker image
Builds image from Dockerfile:

yaml
community.docker.docker_image:
  name: mywebapp
  build:
    path: /home/ec2-user/webapp
4. Stop old container
Safe replacement:

yaml
community.docker.docker_container:
  name: webapp
  state: stopped
5. Deploy new container
Runs updated app:

yaml
community.docker.docker_container:
  name: webapp
  image: mywebapp:latest
  state: started
  published_ports:
    - "80:80"
▶️ How to Run Locally (Optional)
1. Provision EC2
bash
cd terraform
terraform init
terraform apply -auto-approve
2. Deploy using Ansible
bash
ansible-playbook -i terraform/inventory.ini ansible/playbook.yml
🌐 Deployment Output
After the pipeline completes:

EC2 instance is created

Docker is installed

Image is built

Container is deployed

Application is accessible via EC2 public IP on port 80

🧭 Summary
This project provides a complete automated deployment pipeline:

Component	Responsibility
Terraform	Provision EC2 + networking
GitHub Actions	CI/CD automation
Ansible	Configure EC2 + deploy app
Docker	Run application in container
