data "terraform_remote_state" "bootstrap" {
  backend = "s3"

  config = {
    bucket = "my ecsv2 bucket"
    key    = "bootstrap/terraform.tfstate"
    region = "eu-west-2"
  }
}



# 2. ECS EXECUTION ROLE




data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_execution_role" {
  name               = var.ecs_execution_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
}



resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# 3. ECS TASK ROLE




resource "aws_iam_role" "ecs_task_role" {
  name               = var.ecs_task_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
}

data "aws_iam_policy_document" "ecs_task_dynamodb_permissions" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:Query"
    ]

    resources = [
      data.terraform_remote_state.bootstrap.outputs.dynamodb_table_arn

    ]
  }
}

resource "aws_iam_role_policy" "ecs_task_dynamodb_policy" {
  name   = "${var.ecs_task_role_name}-dynamodb-policy"
  role   = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.ecs_task_dynamodb_permissions.json
}

# 4. CODEDEPLOY ROLE

data "aws_iam_policy_document" "codedeploy_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codedeploy_role" {
  name               = var.codedeploy_role_name
  assume_role_policy = data.aws_iam_policy_document.codedeploy_assume_role.json
}

resource "aws_iam_role_policy_attachment" "codedeploy_policy" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

# 5 Github actions :

data "aws_iam_policy_document" "github_assume_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.github_oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${  data.terraform_remote_state.bootstrap.outputs.github_repo}:*"]
    }
  }
}

resource "aws_iam_role" "github_actions_role" {
  name               = var.github_actions_role_name
  assume_role_policy = data.aws_iam_policy_document.github_assume_role.json
}

data "aws_iam_policy_document" "github_actions_permissions" {
  statement {
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",

      "ecs:RegisterTaskDefinition",
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:UpdateService",

      "codedeploy:CreateDeployment",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:GetApplication",
      "codedeploy:GetDeploymentGroup",

      "s3:PutObject",
      "s3:GetObject",

      "iam:PassRole"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "github_actions_policy" {
  name   = "${var.github_actions_role_name}-policy"
  role   = aws_iam_role.github_actions_role.id
  policy = data.aws_iam_policy_document.github_actions_permissions.json
}