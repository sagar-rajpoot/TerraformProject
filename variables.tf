variable "vpc_cidr" {
  description = "choose cidr for vpc"
  type        = string
  default     = "10.20.0.0/16"
}

variable "region" {
  description = "Choose region for you Stack"
  type        = string
  default     = "us-east-1"
}

# AMI are specific to regions
/*map type means its have key and values in it.
for every region we have associated a AMI . As of now 2
if you want to maintane for all regions add here.
*/
variable "nat_amis" {
  type = map(string)
  default = {
    us-east-1 = "ami-00a9d4a05375b2763"
    us-east-2 = "ami-00d1f8201864cc10c"
  }
}

#Section 4 Started Ec2 instance

variable "web_instance_type" {
  description = "Choose instance type for your web"
  type        = string
  default     = "t2.micro"
}

variable "web_tags" {
  type = map(string)
  default = {
    Name = "webserver"
  }
}

variable "web_amis" {
  type = map(string)
  default = {
    us-east-1 = "ami-0b898040803850657"
    us-east-2 = "ami-0d8f6eb4f641ef691"
  }
}

variable "web_ec2_count" {
  description = "Choose number of ec2 instances for web"
  type        = string
  default     = "2"
}

variable "my_app_s3_bucket" {
  default = "sagar-app-dev"
}
