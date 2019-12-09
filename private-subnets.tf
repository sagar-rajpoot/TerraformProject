/*
Its not Harmful to get private subnets in each
availability zone means 6 here but
we will only create 2 private subnet here
because we need max 2 private subnet for enable
multi AZ with RDS.
use Slice funtion which will create sublist
"${length(slice(local.az_names),0,2)}"
Sublist - from index 0 to index (2-1)
*/

locals {
  pri_sub_id = "${aws_subnet.private.*.id}"
}

resource "aws_subnet" "private" {
  count      = "${length(slice(local.az_names, 0, 2))}"
  vpc_id     = "${aws_vpc.my_vpc.id}"
  cidr_block = "${cidrsubnet(var.vpc_cidr, 8, count.index + length(local.az_names))}"

  # above means - 10.20.6.0/24 -> 10.20.7.0/24 etc
  availability_zone = "${local.az_names[count.index]}"

  tags = {
    Name = "privateSubnet-${count.index + 1}"
  }
}

# Seperate route table for public subnet association

resource "aws_route_table" "privatert" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  # integrating  with route table - add nat instance
  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = "${aws_instance.nat.id}"
  }

  tags = {
    Name = "sagarVpcPrivateRT"
  }
}

# next Step is assciate this route table with subnets
#by subnet association in terraform

resource "aws_route_table_association" "pri_sub_association" {
  count     = "${length(slice(local.az_names, 0, 2))}"
  subnet_id = "${local.pri_sub_id[count.index]}"

  #"${aws_subnet.public.*.id}" - will retuen list of subnet ID
  # but we need to pic one at a time for loop
  route_table_id = "${aws_route_table.privatert.id}"
}

#NAT instance Created
#we created a NAT_ami map variable at variable file

resource "aws_instance" "nat" {
  ami           = "${var.nat_amis[var.region]}"
  instance_type = "t2.micro"

  # Extra 2 arguments
  subnet_id         = "${local.pub_sub_id[0]}"
  source_dest_check = false

  #extra 1 more argument Security group ID .it will be list
  vpc_security_group_ids = ["${aws_security_group.nat_sg.id}"]
  tags = {
    Name = "sagarNat"
  }
}

# After above step created route table and add this NAT instance into it.
#i created rount table ealier up add it there

# Security group for NAT instance
#after making this please associate this NAT instance.
resource "aws_security_group" "nat_sg" {
  name        = "nat_sg"
  description = "Allow only egress traffic for private subnet"
  vpc_id      = "${aws_vpc.my_vpc.id}"

  /* we dont want ingress traffic for Nat because
Private subnet are connected to rout table and that rout
table can rout to this nat instance so we want only
egreee traffic_type
*/
  /*
  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }
  */
  /* from port 0 means all port
protocol -1 means its all protocol
*/
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
