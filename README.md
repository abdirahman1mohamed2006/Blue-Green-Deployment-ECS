# Blue-Green-Deployment-ECS

This is a production-grade platform for a FastAPI-based URL shortener running on AWS. The infrastructure is provisioned using Terraform, and deployments are handled securely without static credentials via GitHub OIDC. Updates are rolled out using blue-green deployments with CodeDeploy to ECS Fargate, all sitting behind an Application Load Balancer (ALB). TLS is terminated at the ALB using ACM, with additional protection from AWS WAF. The architecture keeps services private by using VPC endpoints and avoids NAT gateways to minimise costs. Access control is enforced through least-privilege IAM policies, ensuring any potential impact is tightly contained. 

## Architecture :

### Github OIDC:

## Prerequisites

You’ll need an AWS account with sufficient permissions to create resources across IAM, ECR, ECS, ALB, ACM, Route 53, DynamoDB, and CodeDeploy. A public domain name and a corresponding Route 53 hosted zone are also required so ACM can complete DNS validation and traffic can be routed to the ALB.

Also , You must declare this Github Repo secret :

`AWS_ROLE_ARN` which points to the IAM role that trusts OIDC

### Setting up:

- Run the bootstrap from `/bootstrap` so the state bucket , ECR repository , IAM role and the OIDC can be set up
- Then add the `IAM role arn` to the repo 
- Then run the remainder of the terraform infra from the `/Terraform` either manually or via CI 
- Trigger the deploy workflow to register a new task definition and initiate a blue-green deployment via AWS CodeDeploy.

 ### CI/CD and Deployment Flow :

 - The  `Docker-workflow` builds a Docker Image and scans it using trivy
 - The `Deploy workflow` determines the image URI from the given tag, or falls back to the most recent image in ECR. It then registers a new ECS task definition, updates the appspec.yml file with the new task     definition ARN, and triggers a blue-green deployment via AWS CodeDeploy, waiting until the process completes.

   #### CodeDeploy lifecycle visuals:







   ## Repo layout :

   ### Infrastructure Design :


   - `Terraform module`
     The modules are split into  ACM,ALB,CodeDeploy,ECS,IAM,VPC,WAF . This is to create scruture rather than all in the same main.tf file .
   -  `Bootstrap`
     Bootstrap contains all the fundamentals that are needed such as the IAM role , the State Bucket and the ECR repository

    ### Network and Security :

   - **VPC-ENDPOINTS**
     The ECS tasks are run on the Private subnets using VPC endpoints so they can directly interact with AWS

   - **OIDC-Short lived Keys**
     I have used OIDC instead of long-lived key to enhance security .

   - **ALB+WAF**
      Traffic enters the ALB then it's filtered via the WAF to detect for any unwanted traffic     
    



