variable "codedeploy_revisions_bucket_name" {
    type = string
    description = "S3 bucket name that stores appspec.yml revisions for CodeDeploy"
    default     = "blue-green-848153448908-codedeploy-revisions-v2"
  
}

variable "github_repo" {
    type = string
    default = "abdirahman1mohamed2006/Blue-Green-Deployment-ECS"
  
}

variable "ecr_repository_name" {
    type = string
    default = "ecsv2repo"
  
}