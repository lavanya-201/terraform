resource "aws_key_pair" "example_keypair" {
  key_name   = var.KEYNAME
  public_key = tls_private_key.example_keypair.public_key_openssh
}

resource "tls_private_key" "example_keypair" {
  algorithm = "RSA"
}

resource "local_file" "private_key_file" {
  content  = tls_private_key.example_keypair.private_key_pem
  filename = "satrun.pem"
}

resource "aws_security_group" "example_security_group" {
  name        = "satrun-security-group"
  description = "Example Security Group"

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


resource "aws_instance" "example_instance" {
  ami                    = "ami-08a0d1e16fc3f61ea" # Ubuntu 20.04 LTS in us-east-1 (N. Virginia) region
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.example_keypair.key_name
  vpc_security_group_ids = [aws_security_group.example_security_group.id]

  tags = {
    Name = "satrun-instance"
  }
}
