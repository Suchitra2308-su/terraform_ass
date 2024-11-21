resource "aws_security_group" "public" {
  name        = "${var.project_name}-public-sg"
  description = "Public security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private" {
  name        = "${var.project_name}-private-sg"
  description = "Private security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "public" {
  ami           = "ami-0b0ea68c435eb488d" # ami-0b0ea68c435eb488d Amazon Linux 2 AMI (free tier eligible)
  instance_type = "t2.micro"

  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.public.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y nginx
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = {
    Name = "${var.project_name}-public"
  }
}

resource "aws_instance" "private" {
  ami           = "ami-0b0ea68c435eb488d" 
  instance_type = "t2.micro"

  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.private.id]
  key_name              = var.key_name

  tags = {
    Name = "${var.project_name}-private"
  }
}
