resource "aws_s3_bucket" "deployment" {
  bucket = "${var.default_tags.Name}-deployment-artifacts"
}

resource "aws_s3_bucket_acl" "deployment" {
  bucket = aws_s3_bucket.deployment.id
  acl    = "private"
}

resource "aws_iam_role" "example" {
  name = "${var.default_tags.Name}-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "example" {
  role = aws_iam_role.example.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Resource = [
          "*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:*",
        ]
        Resource = [
          aws_s3_bucket.deployment.arn,
          "${aws_s3_bucket.deployment.arn}/*",
        ]
      },
    ]
  })
}

resource "aws_codebuild_project" "project-with-cache" {
  name           = "${var.default_tags.Name}-codebuild"
  build_timeout  = "5"
  queued_timeout = "5"

  service_role = aws_iam_role.example.arn

  artifacts {
    type           = "S3"
    namespace_type = "BUILD_ID"
    packaging      = "ZIP"
    location       = aws_s3_bucket.deployment.id
  }

  secondary_artifacts {
    artifact_identifier = "reports"
    type                = "S3"
    namespace_type      = "BUILD_ID"
    packaging           = "ZIP"
    location            = aws_s3_bucket.deployment.id
    name                = "reports"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.deployment.id
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/kyle-slalom/cr-sprint6-test"
    git_clone_depth = 1
  }
}