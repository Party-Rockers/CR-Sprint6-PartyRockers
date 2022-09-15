resource "aws_s3_bucket" "code-build-output" {
  bucket = "${var.default_tags.Name}-codebuild-output"
}

resource "aws_s3_bucket_versioning" "code-build-output-versioning" {
  bucket = aws_s3_bucket.code-build-output.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "code-build-output-acl" {
  bucket = aws_s3_bucket.code-build-output.id
  acl    = "private"
}