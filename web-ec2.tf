locals {
  env_tag = {
    environmen = terraform.workspace
  }
  # mearge fuction - take multiple map and create one map
  web_tags = merge(var.web_tags, local.env_tag)
}


resource "aws_instance" "web" {
  /*I wana open 2 instances in 2 AZ but i want it
  variable . According to need we can increse the no
  of ec2 instances
  */
  count = "${var.web_ec2_count}"
  ami   = "${var.web_amis[var.region]}"
  # Above passing key - region ..key pair
  instance_type = "${var.web_instance_type}"
  subnet_id     = "${local.pub_sub_id[count.index]}"
  tags          = "${local.web_tags}"

  # if we want to run ome bash Script run in EC2 for
  # Set up we can use user data Script
  user_data              = "${file("scripts/apache.sh")}"
  iam_instance_profile   = "${aws_iam_instance_profile.s3_ec2_profile.name}"
  vpc_security_group_ids = ["${aws_security_group.web_sg.id}"]
  #when you apply  User Data Script on any ec2 , Terraform
  #will recreate those instances after deploying because
  #user Data Scripts are Launch time Scripts.
  #
  key_name = "${aws_key_pair.web.key_name}"
}

resource "aws_key_pair" "web" {
  key_name   = "sagar-web"
  public_key = "${file("scripts/web.pub")}"
}
