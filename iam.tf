#################### WEB SERVER ####################

# Creates a service role for ec2
resource "aws_iam_role" "web_ec2" {
  name = "${var.default_tags.Name}-codedeploy-instance-profile"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy_ec2" {
  role       = aws_iam_role.web_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
}

resource "aws_iam_instance_profile" "codedeploy" {
  name = "${var.default_tags.Name}-codedeploy-instance-profile"
  role = aws_iam_role.web_ec2.name
}

#################### CODE DEPLOY ####################

resource "aws_iam_role" "code-deploy" {
  name = "${var.default_tags.Name}-code-deploy-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.code-deploy.name
}


#####CODEBUILD#####
resource "aws_iam_role" "code-build" {
  name = "${var.default_tags.Name}-code-build-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "AWSCodeBuildRole" {
  role = aws_iam_role.code-build.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.code-build-output.arn}",
        "${aws_s3_bucket.code-build-output.arn}/*"
      ]
    }
  ]
}
POLICY
}