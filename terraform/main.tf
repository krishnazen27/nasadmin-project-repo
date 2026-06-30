resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "web" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "krishna-ec2-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_s3_object" "ssh_private_key" {
  bucket = "skr-backend-terraform-state-bucket"   # replace with your bucket name
  key    = "keys/krishna-ec2-key.pem"
  content = tls_private_key.ssh_key.private_key_pem

  server_side_encryption = "AES256"
}

resource "aws_instance" "web" {
  ami                    = "ami-05cbf8a8aa4e4b755"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]

  key_name = aws_key_pair.generated_key.key_name

  tags = {
    Name = "docker-web-server"
  }
}

