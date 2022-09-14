###################### SECURITY GROUPS ######################

resource "aws_security_group" "jenkins" {
  name   = "${var.default_tags.Name}-jenkins"
  vpc_id = aws_vpc.main.id

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allows whitelisted clients to access over SSH.
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.allowed_cidr_blocks
    ipv6_cidr_blocks = var.allowed_cidr_blocks_ipv6
  }

  # Allows whitelisted clients to access over port 80.
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = var.allowed_cidr_blocks
    ipv6_cidr_blocks = var.allowed_cidr_blocks_ipv6
  }

  tags = merge(
    var.default_tags,
    { Name = "${var.default_tags.Name}-jenkins" }
  )
}

resource "aws_security_group" "web" {
  name   = "${var.default_tags.Name}-web"
  vpc_id = aws_vpc.main.id

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allows whitelisted clients to access over SSH.
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.allowed_cidr_blocks
    ipv6_cidr_blocks = var.allowed_cidr_blocks_ipv6
  }

  # Allows whitelisted clients to access over port 80.
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = var.allowed_cidr_blocks
    ipv6_cidr_blocks = var.allowed_cidr_blocks_ipv6
  }

  tags = merge(
    var.default_tags,
    { Name = "${var.default_tags.Name}-web" }
  )
}