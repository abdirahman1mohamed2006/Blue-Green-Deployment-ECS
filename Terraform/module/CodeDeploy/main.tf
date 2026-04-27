resource "aws_codedeploy_app" "ecs_v2" {
  compute_platform = "ECS"
  name             = "example"
}

resource "aws_codedeploy_deployment_group" "deployment_gc" {
  app_name               = aws_codedeploy_app.ecs_v2.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "example"
  service_role_arn       = var.service_role_arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.cluster_name
    service_name = var.service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.listener-ecsv2]
      }

      target_group {
        name = var.blue_tg_name
      }

      target_group {
        name = var.green_tg_name
      }
    }
  }
}