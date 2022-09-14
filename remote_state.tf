
########################## S3 BUCKET ##########################
resource "aws_s3_bucket" "remote-state-s3" {
  bucket = "${var.default_tags.Name}-remote"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "remote-state-versioning" {
  bucket = aws_s3_bucket.remote-state-s3.id

  versioning_configuration {    status = "Enabled"  }
}

########################## DYNAMODB TABLE ##########################
resource "aws_dynamodb_table" "remote-state-db" {
  name           = "${var.default_tags.Name}-remote"
  hash_key       = "LockID"

  read_capacity = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}