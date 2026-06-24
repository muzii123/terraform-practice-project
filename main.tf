# provider "aws" {
#   region = "eu-north-1"
# }

# resource "aws_instance" "my_ec2" {
#   ami = "ami-023b6eace47afd3b4"
#   instance_type = "t3.micro"

#   tags = {
#     Name = "MyFirstEC2"
#   }
# }



# VARIABLES

provider "aws" {
  region = var.aws_region
}
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] 

  filter {
    name   = "AWS"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
  tags = {
    Name = "MyS3BUCKET"
  }
}

resource "aws_instance" "my_ec2" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
  depends_on = [aws_s3_bucket.my_bucket]
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "null_resource" "test" {

  provisioner "local-exec" {
    command = "echo Terraform Executed"
  }

}