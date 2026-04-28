

# Terraform state bucket
resource "aws_s3_bucket" "tf_state" {
  bucket = "ecs-v2-terraform-state"

 
}

resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# CodeDeploy bucket
resource "aws_s3_bucket" "codedeploy" {
  bucket = var.codedeploy_revisions_bucket_name

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "codedeploy_versioning" {
  bucket = aws_s3_bucket.codedeploy.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "dynamodb-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_iam_openid_connect_provider" "default" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list =["sts.amazonaws.com"] 

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_role" "test_role_2" {
  name = "test_role_v2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Principal = {
          Federated = aws_iam_openid_connect_provider.default.arn
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_repo}:*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "policies-allow" {
  name        = "test_policy"
  path        = "/"
  description = "My policy in which I allow "

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action =  [
          "s3:*",
          "ecr:*",
          "ecs:*",
          "codedeploy:*",
          "dynamodb:*",
          "ec2:*",
          "elasticloadbalancing:*",
          "logs:*",
          "cloudwatch:*",
          "acm:*",
          "route53:*",
          "wafv2:*",
          "iam:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_actions_attach" {
  role       = aws_iam_role.test_role_2.name
  policy_arn = aws_iam_policy.policies-allow.arn
}

resource "aws_ecr_repository" "ecsv2" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}