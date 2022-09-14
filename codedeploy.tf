###################### CODE DEPLOY ######################

resource "aws_codedeploy_app" "default" {
  name             = var.default_tags.Name
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "default" {
  app_name              = aws_codedeploy_app.default.name
  deployment_group_name = "${var.default_tags.Name}-group"
  service_role_arn      = aws_iam_role.codedeploy_service.arn

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "${var.default_tags.Name}-web"
    }
  }

  deployment_config_name = "CodeDeployDefault.OneAtATime"
}