#AWS launch Configuration ...autoscaling use this
#launch configuration for launching AWS
#instances in Autoscaling Group
resource "aws_launch_configuration" "web_lc" {
  name                 = "web_lc"
  image_id             = "${var.web_amis[var.region]}"
  instance_type        = "t2.micro"
  key_name             = "${aws_key_pair.web.key_name}"
  user_data            = "${file("scripts/apache.sh")}"
  iam_instance_profile = "${aws_iam_instance_profile.s3_ec2_profile.name}"
  security_groups      = ["${aws_security_group.web_sg.id}"]
}

# Now Create AutoScaling Group
resource "aws_autoscaling_group" "sagar_asg" {
  name                      = "sagar_asg"
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 60
  health_check_type         = "ELB"
  load_balancers            = ["${aws_elb.sagar_elb.name}"]
  vpc_zone_identifier       = "${local.pub_sub_id}"
  launch_configuration      = "${aws_launch_configuration.web_lc.name}"
}

# AutoScaling Policies 2 one for adding instances
#and one for removing instances

resource "aws_autoscaling_policy" "AddInstancePolicy" {
  name                   = "AddInstancePolicy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = "${aws_autoscaling_group.sagar_asg.name}"
}

resource "aws_autoscaling_policy" "RemoveInstancePolicy" {
  name                   = "RemoveInstancePolicy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = "${aws_autoscaling_group.sagar_asg.name}"
}

#Now Create Matric Alarm and call required policy

resource "aws_cloudwatch_metric_alarm" "avg_cpu_ge_80" {
  alarm_name          = "avg_cpu_ge_80"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.sagar_asg.name}"
  }
  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.AddInstancePolicy.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "avg_cpu_le_30" {
  alarm_name          = "avg_cpu_le_30"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.sagar_asg.name}"
  }
  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.RemoveInstancePolicy.arn}"]
}
