provider "aws" {
  version = "~> 2.50"
  region  = "eu-central-1"
}


##########################VARIABLES##################################


variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}


#############################EC2 INSTANCE#############################


resource "aws_instance" "example" {
  ami                    = "ami-0df0e7600ad0913a9"
  instance_type          = "t2.micro"
  key_name               = "test-key-Frankfurt"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              mkdir busybox_app && cd busybox_app
              wget https://busybox.net/downloads/binaries/1.28.1-defconfig-multiarch/busybox-x86_64
              mv busybox-x86_64 busybox
              chmod +x busybox
              echo "Hello, World from $(hostname)" > index.html
              nohup ./busybox httpd -f -p ${var.server_port} &
              EOF
  tags = {
    Name = "terraform-devops"
  }
}


resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["176.120.237.0/24"]
  }


  ingress {
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = ["176.120.224.0/19"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


###################REMOTE BACKEND S3######################


terraform {
  backend "s3" {
    bucket = "terraform-sample-project-04052020"
    key    = "devops/terraform.tfstate"
    region = "eu-central-1"

    dynamodb_table = "terraform-sample-project-locks"
    encrypt        = true
  }
}


#######################OUTPUTS###########################


output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP address of the web server"
}

output "public_dns" {
  value       = aws_instance.example.public_dns
  description = "DNS name of the web server"
}
