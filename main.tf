# Déclaration du fournisseur AWS avec la région spécifiée
provider "aws" {
  region = "us-east-1"
}

# Déclaration d'un groupe de sécurité AWS
resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "Mon groupe de sécurité"

  # Règles entrantes pour le trafic TCP sur les ports 80, 443, 22 et 8080
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

  # Règles sortantes autorisant tout le trafic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Déclaration d'une instance EC2 avec l'AMI, le type d'instance, le groupe de sécurité, la clé SSH et les balises
resource "aws_instance" "fromJenkinsInstance" {
  ami                    = "ami-0fc5d935ebf8bc3bc"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  key_name               = "shunter_ubuntu_key"  # Le nom de la clé tel qu'enregistré dans AWS EC2

  tags = {
    Name = "MonInstanceEC2FromJenkins"
  }
}

# Sortie de l'adresse IP publique de l'instance EC2
output "instance_public_ip" {
  value = aws_instance.fromJenkinsInstance.public_ip
}