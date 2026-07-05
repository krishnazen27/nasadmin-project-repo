resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "project-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "project-vpc-igw"
  }
}


resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "project-vpc-subnet-public"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "project-vpc-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
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

  tags = {
    Name = "project-vpc-sg-web"
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
  bucket = "kar-backend-terraform-state-bucket"   # replace with your bucket name
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

resource "aws_instance" "app" {
  ami                    = "ami-05cbf8a8aa4e4b755"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]

  key_name = aws_key_pair.generated_key.key_name

  tags = {
    Name = "docker-app-server"
  }
}

resource "local_file" "ansible_inventory" {
  content = <<EOF
[web]
${aws_instance.web.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=terraform/id_rsa.pem
EOF

  filename = "${path.module}/inventory.ini"
}



