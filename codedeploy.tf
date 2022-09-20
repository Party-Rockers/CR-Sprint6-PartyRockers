resource "aws_codedeploy_app" "cd" {
  name = "${var.default_tags.Name}-cd-app"
}

resource "aws_sns_topic" "sns" {
  name = "${var.default_tags.Name}-sns"
}

resource "aws_sns_topic_subscription" "email-target1" {
  topic_arn = aws_sns_topic.sns.arn
  protocol  = "email"
  endpoint  = "sarah.moreland@slalom.com"
}

resource "aws_sns_topic_subscription" "email-target2" {
  topic_arn = aws_sns_topic.sns.arn
  protocol  = "email"
  endpoint  = "kyle.lierer@slalom.com"
}

resource "aws_sns_topic_subscription" "email-target3" {
  topic_arn = aws_sns_topic.sns.arn
  protocol  = "email"
  endpoint  = "maya.rao@slalom.com"
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

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  trigger_configuration {
    trigger_events     = ["DeploymentFailure", "DeploymentSuccess"]
    trigger_name       = "${var.default_tags.Name}-trigger"
    trigger_target_arn = aws_sns_topic.sns.arn
  }
}

resource "aws_codestarnotifications_notification_rule" "deployment-failure" {
  name     = "${var.default_tags.Name}-deployment"
  detail_type = "FULL"
  status   = "ENABLED"
  event_type_ids = ["codedeploy-application-deployment-succeeded", "codedeploy-application-deployment-failed"]
  resource = aws_codedeploy_deployment_group.cd-group.arn
  target {
    address = aws_sns_topic.sns.arn
  }
}
