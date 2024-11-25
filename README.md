## Write Terraform script to create a custom VPC and deploy two EC2 VMs on AWS using Terraform.
<pre><b>
 The code should be broken into three different parts:
 Networking (define the VPC and all of its components)
 SSH-Key (dynamically create an SSH-key pair for connecting to VMs)
 EC2 (deploy a VM in the public subnet, and deploy another VM in a private subnet)
 NGINX should be accessed for all the internet
 Automate Terraform Deployment with Jenkins Pipelines
</b></pre>


# Networking Module

<b> VPC Creation: <b>
1. Creates an AWS VPC with a CIDR block of 10.0.0.0/16.
2. Enables DNS hostnames and DNS support for seamless instance connectivity.
3. Tags the VPC with the project name for easy identification.
4. Internet Gateway Setup: Provisions an Internet Gateway to allow external network connectivity. Attaches the Internet Gateway to the created VPC.

5. Subnet Configuration: <br>
 Public Subnet:
     CIDR Block: 10.0.1.0/24.
    > Enables automatic public IP assignment for instances in this subnet.
    > Properly tagged for identification.
6. Private Subnet:
    CIDR Block: 10.0.2.0/24.
     No public IP assignment, ensuring internal-only connectivity.
7. Route Table for Public Subnet:

     Creates a route table with a route directing 0.0.0.0/0 traffic through the Internet Gateway.<br>
8. Associates the route table with the public subnet.


_________________________________________________________________________________________________________________________________________________

# SSH-Key Module

Dynamically generates an SSH key pair for secure connections to EC2 instances.
Automatically stores the private key locally and uploads the public key to AWS.

# EC2 Module
Public EC2 Instance:

1. Deployed in the public subnet for internet access.
2. Installs and configures NGINX, accessible from the internet on port 80.
Private EC2 Instance:

1. Deployed in the private subnet, inaccessible directly from the internet.
2. Can communicate with the public instance for internal operations.


# Automation with Jenkins

To automate the deployment, a Jenkins pipeline has been configured with the following stages:

1. Initialization: Runs terraform init to initialize the working directory and modules.
   > terraform init
2. Plan: Executes terraform plan to review the changes and ensure no unintended modifications.
   > terraform plan
3. Apply:Deploys the infrastructure using terraform apply.
   > terraform apply
4. NGINX Validation: Ensures NGINX is running and accessible from the public EC2 instance.


<b>After running the Jenkinsfile, the tfstate file is stored in an AWS S3 bucket.</b>

jenkin file
<pre>
pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-terraform-credentials')  // Update credentials ID
        AWS_SECRET_ACCESS_KEY = credentials('aws-terraform-credentials')
        AWS_DEFAULT_REGION    = 'us-east-1'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', credentialsId: 'github-credentials-id', url: 'https://github.com/VikasKR123/terraform_assignment.git'
                sh 'ls -la'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}

</pre>


snapshot:

## Jenkins: 
![jenkins-02](https://github.com/user-attachments/assets/304ebf46-96b3-46c6-a383-6fb8a05d86d6)

![jenkins-01](https://github.com/user-attachments/assets/0f997bc3-bc9f-4663-94f2-0e138b6bbf3d)

![jenkins-03](https://github.com/user-attachments/assets/d8a1a616-f0e7-42ef-8585-8d34b7ff3b56)

## AWS

![aws-01](https://github.com/user-attachments/assets/57c18298-d5df-45e1-bfad-670a27e7b740)

![security-group](https://github.com/user-attachments/assets/b2e175dc-1d2f-4021-9805-5cceb3402516)

![key-pair](https://github.com/user-attachments/assets/72d1e13e-cbe1-4e3f-a909-b5500444e497)

![s3-terraform-assignemnt](https://github.com/user-attachments/assets/89a786cf-0edf-43b8-8a41-b040560a156f)


## Nginx

![nginx-01](https://github.com/user-attachments/assets/f951ea2d-9e57-4347-b13d-e9c6f33dd161)

