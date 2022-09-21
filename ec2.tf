###################### KEY PAIR ######################

# Here, a single key pair will be used to access
# all of the EC2 as part of the autoscaling group.
# Note: this is not best practice, but since this is a
# prototype it is fine.

resource "tls_private_key" "main" {
  algorithm = "RSA"
}

resource "aws_key_pair" "default" {
  key_name   = "${var.default_tags.Name}-key"
  public_key = tls_private_key.main.public_key_openssh
}

###################### EC2 INSTANCE DATA ######################

data "aws_ami" "ubuntu_web" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

data "aws_ami" "ubuntu_jenkins" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

###################### JENKINS Server ######################

resource "aws_instance" "jenkins" {
  ami                  = data.aws_ami.ubuntu_jenkins.id
  instance_type        = "t3.small"
  subnet_id            = aws_subnet.public.id
  security_groups      = [aws_security_group.jenkins.id]
  key_name             = aws_key_pair.default.key_name
  iam_instance_profile = aws_iam_instance_profile.jenkins.name
  user_data            = file("scripts/jenkins-ec2.sh")

  lifecycle {
    ignore_changes = [
      disable_api_termination, ebs_optimized, hibernation, security_groups,
      credit_specification, network_interface, ephemeral_block_device
    ]
  }

  tags = merge(
    var.default_tags,
    { Name = "${var.default_tags.Name}-jenkins" }
  )
}

###################### WEB Server ######################

resource "aws_instance" "web" {
  ami                  = data.aws_ami.ubuntu_web.id
  instance_type        = "t3.micro"
  subnet_id            = aws_subnet.public.id
  security_groups      = [aws_security_group.web.id]
  iam_instance_profile = aws_iam_instance_profile.codedeploy.name
  key_name             = aws_key_pair.default.key_name
  user_data            = file("scripts/web-ec2.sh")

  lifecycle {
    ignore_changes = [
      disable_api_termination, ebs_optimized, hibernation, security_groups,
      credit_specification, network_interface, ephemeral_block_device
    ]
  }

  tags = merge(
    var.default_tags,
    { Name = "${var.default_tags.Name}-web" }
  )
}

###################### GITHUB WEB Server ######################

resource "aws_instance" "github-web" {
  ami                  = data.aws_ami.ubuntu_web.id
  instance_type        = "t3.micro"
  subnet_id            = aws_subnet.public.id
  security_groups      = [aws_security_group.web.id]
  iam_instance_profile = aws_iam_instance_profile.codedeploy.name
  key_name             = aws_key_pair.default.key_name
  user_data            = file("scripts/web-ec2.sh")

  lifecycle {
    ignore_changes = [
      disable_api_termination, ebs_optimized, hibernation, security_groups,
      credit_specification, network_interface, ephemeral_block_device
    ]
  }

  tags = merge(
    var.default_tags,
    { Name = "${var.default_tags.Name}-github-web" }
  )
}

###################### BITBUCKET WEB Server ######################

resource "aws_instance" "bitbucket-web" {
  ami                  = data.aws_ami.ubuntu_web.id
  instance_type        = "t3.micro"
  subnet_id            = aws_subnet.public.id
  security_groups      = [aws_security_group.web.id]
  iam_instance_profile = aws_iam_instance_profile.codedeploy.name
  key_name             = aws_key_pair.default.key_name
  user_data            = file("scripts/web-ec2.sh")

  lifecycle {
    ignore_changes = [
      disable_api_termination, ebs_optimized, hibernation, security_groups,
      credit_specification, network_interface, ephemeral_block_device
    ]
  }

  tags = merge(
    var.default_tags,
    { Name = "${var.default_tags.Name}-bitbucket-web" }
  )
}