resource "aws_codedeploy_app" "cd" {
  name = "${var.default_tags.Name}-cd-app"
}

###################### WEB deployment group ######################

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

###################### GITHUB WEB deployment group ######################

resource "aws_codedeploy_deployment_group" "github-cd-group" {
  app_name              = aws_codedeploy_app.cd.name
  deployment_group_name = "${var.default_tags.Name}-cd-github-deployment-group"
  service_role_arn      = aws_iam_role.code-deploy.arn

  ec2_tag_set {
    ec2_tag_filter {
      type  = "KEY_AND_VALUE"
      key   = "Name"
      value = "${var.default_tags.Name}-github-web"
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  trigger_configuration {
    trigger_events     = ["DeploymentFailure", "DeploymentSuccess"]
    trigger_name       = "${var.default_tags.Name}-github-trigger"
    trigger_target_arn = aws_sns_topic.sns.arn
  }
}

resource "aws_codestarnotifications_notification_rule" "github-deployment-failure" {
  name     = "${var.default_tags.Name}-github-deployment"
  detail_type = "FULL"
  status   = "ENABLED"
  event_type_ids = ["codedeploy-application-deployment-succeeded", "codedeploy-application-deployment-failed"]
  resource = aws_codedeploy_deployment_group.github-cd-group.arn
  target {
    address = aws_sns_topic.sns.arn
  }
}

###################### BITBUCKET WEB deployment group ######################

resource "aws_codedeploy_deployment_group" "bitbucket-cd-group" {
  app_name              = aws_codedeploy_app.cd.name
  deployment_group_name = "${var.default_tags.Name}-cd-bitbucket-deployment-group"
  service_role_arn      = aws_iam_role.code-deploy.arn

  ec2_tag_set {
    ec2_tag_filter {
      type  = "KEY_AND_VALUE"
      key   = "Name"
      value = "${var.default_tags.Name}-bitbucket-web"
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  trigger_configuration {
    trigger_events     = ["DeploymentFailure", "DeploymentSuccess"]
    trigger_name       = "${var.default_tags.Name}-bitbucket-trigger"
    trigger_target_arn = aws_sns_topic.sns.arn
  }
}

resource "aws_codestarnotifications_notification_rule" "bitbucket-deployment-failure" {
  name     = "${var.default_tags.Name}-bitbucket-deployment"
  detail_type = "FULL"
  status   = "ENABLED"
  event_type_ids = ["codedeploy-application-deployment-succeeded", "codedeploy-application-deployment-failed"]
  resource = aws_codedeploy_deployment_group.bitbucket-cd-group.arn
  target {
    address = aws_sns_topic.sns.arn
  }
}