provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "fromJenkinsInstance" {
  ami           = "ami-0fc5d935ebf8bc3bc"  # Remplacez par l'AMI approprié
  instance_type = "t2.micro"

  tags = {
    Name = "MonInstanceEC2FromJenkins"
  }
}
