# KEY PAIR
resource "aws_key_pair" "my_key" {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

# DEFAULT VPC
resource "aws_default_vpc" "default" {}

# SECURITY GROUP
resource "aws_security_group" "my_security_group" {
  name        = "automate-sg"
  description = "EC2 Security Group"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Flask App"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound"
  }

  tags = {
    Name = "automate-sg"
  }
}

# EC2 INSTANCE
resource "aws_instance" "my_instance" {

  ami           = var.ec2_ami_id
  instance_type = var.aws_instance_type

  key_name = aws_key_pair.my_key.key_name

  # IMPORTANT FIX: replace security_groups with vpc_security_group_ids
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  user_data = file("install_nginx.sh")

  root_block_device {
    volume_size = var.env == "prd" ? 20 : var.ec2_default_root_storage_size
    volume_type = "gp3"
  }

  depends_on = [
    aws_security_group.my_security_group,
    aws_key_pair.my_key
  ]

  tags = {
    Name = "raj-creations"
  }
