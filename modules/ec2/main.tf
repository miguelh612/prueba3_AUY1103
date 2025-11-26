locals {
  app_names = toset(distinct([for k, v in var.ec2_specs : v.app_tag]))
}

# EC2
resource "aws_instance" "web_server" {
  for_each               = var.ec2_specs
  ami                    = each.value.ami
  instance_type          = each.value.instance_type
  subnet_id              = var.public_subnet_ids[each.value.subnet_index]
  vpc_security_group_ids = [var.sg_frontend_id]
  root_block_device {
    volume_size = each.value.disk_size
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = each.key
    App  = each.value.app_tag
  }
}

# ALB
resource "aws_lb" "app_albs" {
  for_each           = local.app_names
  name               = "alb-${lower(each.key)}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_ids[lower(each.key)]]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "alb-${lower(each.key)}"
  }
}

resource "aws_lb_target_group" "app_tgs" {
  for_each    = local.app_names
  name        = "tg-${lower(each.key)}"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "app_listeners" {
  for_each          = local.app_names
  load_balancer_arn = aws_lb.app_albs[each.key].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tgs[each.key].arn
  }
}

resource "aws_lb_target_group_attachment" "web_alb_attachment" {
  for_each         = aws_instance.web_server
  target_group_arn = aws_lb_target_group.app_tgs[each.value.tags.App].arn
  target_id        = each.value.id
  port             = 80
}

output "elb_dns_names" {
  description = "DNS ALB"
  value       = { for k, alb in aws_lb.app_albs : k => alb.dns_name }
}