provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "Mon groupe de securite"

  // Règles entrantes
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

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Règles sortantes
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "fromJenkinsInstance" {
  ami                    = "ami-0fc5d935ebf8bc3bc"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  key_name      = "shunter_ubuntu_key"  # Le nom de la clé telle qu'enregistrée dans AWS EC2

  tags = {
    Name = "MonInstanceEC2FromJenkins"
  }
}


output "instance_public_ip" {
  value = aws_instance.fromJenkinsInstance.public_ip
}