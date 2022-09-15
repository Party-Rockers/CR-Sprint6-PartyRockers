resource "aws_codedeploy_app" "cd" {
  name = "${var.default_tags.Name}-cd-app"
}

resource "aws_codedeploy_deployment_group" "cd-group" {
  app_name              = aws_codedeploy_app.cd.name
  deployment_group_name = "${var.default_tags.Name}-cd-deployment-group"
  service_role_arn      = aws_iam_role.code-deploy.arn

  ec2_tag_set {
    ec2_tag_filter {
      type  = "KEY_AND_VALUE"
      key   = "Name"
      value = "${var.default_tags.Name}-web"
    }
  }

#   trigger_configuration {
#     trigger_events     = ["DeploymentFailure"]
#     trigger_name       = "example-trigger"
#     trigger_target_arn = aws_sns_topic.example.arn
#   }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}