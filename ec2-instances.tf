 # Choose your provider and put your access aws

provider "aws" {
  access_key = "ACCESS_KEY_HERE"
  secret_key = "SECRET_KEY_HERE"
  region     = "eu-west-3"
}

# Declare variable for number of instances
variable "count" {
default=3
}

#Create multiple ec2 instances and put your image, subnet, security group

resource "aws_instance" "test" {
count="${var.count}"
ami = "ami-04992646d54c69ef4"
instance_type = "t2.micro"
subnet_id = "subnet-0de7fc588b0b6a4e9"
vpc_security_group_ids = ["sg-07c3dc51388a2eaad"]
tags { Name="${format("test-%01d",count.index+1)}" }
}

 # Create load balancer on port 443 only 

resource "aws_elb" "test-lb" {
  name               = "test-terraform-elb"
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]

  listener {
    instance_port      = 8000
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
 
 # Put your id iam and the name of your certificate
 
    ssl_certificate_id = "arn:aws:iam::(id-iam):server-certificate/certName"
  }
 
# Select your instances 

  instances                   = ["${aws_instance.test.*.id}"]
  tags {
    Name = "test-terraform-elb"
  }
}
}




