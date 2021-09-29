# Create Target Group
resource "aws_lb_target_group" "radius-1812" {
  name        = "radius-1812"
  port        = 1812
  protocol    = "UDP"
  target_type = "ip"
  deregistration_delay = 60
  stickiness {
    enabled = "true"
    type = "source_ip"
  }
  health_check {
    enabled = "true"
    port = 443
    protocol = "TCP"
  }
  vpc_id      = aws_vpc.main.id
}
resource "aws_lb_target_group" "radius-1813" {
  name        = "radius-1813"
  port        = 1813
  protocol    = "UDP"
  target_type = "ip"
  deregistration_delay = 60
  stickiness {
    enabled = "true"
    type = "source_ip"
  }
  health_check {
    enabled = "true"
    port = 443
    protocol = "TCP"
  }
  vpc_id      = aws_vpc.main.id
}
resource "aws_lb_target_group" "tacacs-49" {
  name        = "tacacs-49"
  port        = 49
  protocol    = "TCP"
  target_type = "ip"
  deregistration_delay = 60
  
  stickiness {
    enabled = "true"
    type = "source_ip"
  }
  health_check {
    enabled = "true"
    port = 49
    protocol = "TCP"
  }
  vpc_id      = aws_vpc.main.id
}

# Attach Target Group 
resource "aws_lb_target_group_attachment" "a" {
  target_group_arn = aws_lb_target_group.radius-1812.arn
  target_id        = aws_network_interface.ppan-nic.private_ip
  port             = 1812
}
resource "aws_lb_target_group_attachment" "b" {
  target_group_arn = aws_lb_target_group.radius-1813.arn
  target_id        = aws_network_interface.ppan-nic.private_ip
  port             = 1813
}
resource "aws_lb_target_group_attachment" "c" {
  target_group_arn = aws_lb_target_group.tacacs-49.arn
  target_id        = aws_network_interface.ppan-nic.private_ip
  port             = 49
}
resource "aws_lb_target_group_attachment" "d" {
  target_group_arn = aws_lb_target_group.radius-1812.arn
  target_id        = aws_network_interface.span-nic.private_ip
  port             = 1812
}
resource "aws_lb_target_group_attachment" "e" {
  target_group_arn = aws_lb_target_group.radius-1813.arn
  target_id        = aws_network_interface.span-nic.private_ip
  port             = 1813
}
resource "aws_lb_target_group_attachment" "f" {
  target_group_arn = aws_lb_target_group.tacacs-49.arn
  target_id        = aws_network_interface.span-nic.private_ip
  port             = 49
}

# Create Load balancer
resource "aws_lb" "ise-lb" {
  name               = "ise-lb"
  internal           = true
  load_balancer_type = "network"
  enable_cross_zone_load_balancing = true
  subnet_mapping {
    subnet_id            = aws_subnet.subnet-1.id
    private_ipv4_address = "10.0.1.20"
  }

  subnet_mapping {
    subnet_id            = aws_subnet.subnet-2.id
    private_ipv4_address = "10.0.2.20"
  }
}

# Create LB listener
resource "aws_lb_listener" "radius-1812" {
  load_balancer_arn = aws_lb.ise-lb.arn
  port              = "1812"
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.radius-1812.arn
  }
}
resource "aws_lb_listener" "radius-1813" {
  load_balancer_arn = aws_lb.ise-lb.arn
  port              = "1813"
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.radius-1813.arn
  }
}
resource "aws_lb_listener" "radius-1645" {
  load_balancer_arn = aws_lb.ise-lb.arn
  port              = "1645"
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.radius-1812.arn
  }
}
resource "aws_lb_listener" "radius-1646" {
  load_balancer_arn = aws_lb.ise-lb.arn
  port              = "1646"
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.radius-1813.arn
  }
}
resource "aws_lb_listener" "tacacs-49" {
  load_balancer_arn = aws_lb.ise-lb.arn
  port              = "49"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tacacs-49.arn
  }
}
