
resource "aws_codebuild_project" "cb" {
  name          = "${var.default_tags.Name}-cb-app"
  build_timeout = "5"
  service_role  = aws_iam_role.code-build.arn

  artifacts {
    type = "S3"
    namespace_type = "BUILD_ID"
    packaging = "ZIP"
    location = aws_s3_bucket.code-build-output.id

  }

  secondary_artifacts {

    artifact_identifier = "reports"

    type           = "S3"

    namespace_type = "BUILD_ID"

    packaging      = "ZIP"

    location       = aws_s3_bucket.code-build-output.id

    name           = "reports"

  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"


  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/Party-Rockers/CR-Sprint6-PartyRockers.git"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

}

