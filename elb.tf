# Create new Load balancer..
resource "aws_elb" "sagar_elb" {
  name            = "sagar-elb-${terraform.workspace}"
  subnets         = "${local.pub_sub_id}"
  security_groups = ["${aws_security_group.elb_sg.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/index.html"
    interval            = 30
  }

  instances                   = "${aws_instance.web.*.id}"
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 30

  tags = {
    Name = "sagar_elb_${terraform.workspace}"
  }
}

# Now Security Group for ELB

resource "aws_security_group" "elb_sg" {
  name        = "elb_sg"
  description = "Allow traffic for web apps on elb"
  vpc_id      = "${aws_vpc.my_vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # ELB is PAAS so we cant connect to it by ssh or by IP
}
