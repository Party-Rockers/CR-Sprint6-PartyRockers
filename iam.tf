resource "aws_iam_role" "jenkins" {
  name = "${var.default_tags.Name}-jenkins"

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

resource "aws_iam_policy" "jekins" {
  name        = "${var.default_tags.Name}-jenkins"
  description = "Jenkins policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",
          "codedeploy:*",
          "codebuild:*",
        ]
        Resource = [
          "*"
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins" {
  role       = aws_iam_role.jenkins.name
  policy_arn = aws_iam_policy.jekins.arn
}

resource "aws_iam_instance_profile" "jenkins" {
  name = "${var.default_tags.Name}-jenkins"
  role = aws_iam_role.jenkins.name
}

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