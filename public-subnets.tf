locals {
  az_names   = "${data.aws_availability_zones.azs.names}"
  pub_sub_id = "${aws_subnet.public.*.id}"
}

resource "aws_subnet" "public" {
  count      = "${length(local.az_names)}"
  vpc_id     = "${aws_vpc.my_vpc.id}"
  cidr_block = "${cidrsubnet(var.vpc_cidr, 8, count.index)}"

  # above means - 10.20.1.0/24 -> 10.20.2.0/24 etc
  availability_zone = "${local.az_names[count.index]}"

  #Below command for auto assigning a public IP for the subnet..
  map_public_ip_on_launch = true

  # Boolean values can be in quotes or without quotes

  tags = {
    Name = "publicSubnet-${count.index + 1}"
  }
}

/*
inbuilt cidr function we can use for getting
dynamic cidr for Public subnets in all avilability zone.
cidrsubnet("10.20.0.0/16", 8 , 1 )
16 bit + 8 bit = 24 bit and give the 1st cidr from the network
*/

# Adding internet getway

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  tags = {
    Name = "sagarIgw"
  }
}

# Seperate route table for public subnet association

resource "aws_route_table" "publicrt" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  # adding below route to this route table ..means
  # integrating internet getway with route table
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  /*  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = "${aws_egress_only_internet_gateway.foo.id}"
  }
  */

  tags = {
    Name = "sagarVpcPublicRT"
  }
}

# next Step is assciate this route table with subnets
#by subnet association in terraform

resource "aws_route_table_association" "pub_sub_association" {
  count     = "${length(local.az_names)}"
  subnet_id = "${local.pub_sub_id[count.index]}"

  #"${aws_subnet.public.*.id}" - will retuen list of subnet ID
  # but we need to pic one at a time for loop
  route_table_id = "${aws_route_table.publicrt.id}"
}
