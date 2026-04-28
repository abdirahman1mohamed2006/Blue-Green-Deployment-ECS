variable "codedeploy_revisions_bucket_name" {
    type = string
    description = "S3 bucket name that stores appspec.yml revisions for CodeDeploy"
    default     = "bucket-v2"
  
}

variable "github_repo" {
    type = string
    default = "Blue-Green Deployment ECS"
  
}

variable "ecr_repository_name" {
    type = string
    default = "ECSv2Repo"
  
}