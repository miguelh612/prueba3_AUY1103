output "vpc_id" {
  value = aws_vpc.vpc_1.id
}

output "public_subnet_ids" {
  description = "IDs de subredes públicas"
  value       = [for s in aws_subnet.subnets : s.id if length(regexall("pública", s.tags.Name)) > 0]
}

output "private_subnet_ids" {
  description = "IDs de subredes privadas"
  value       = [for s in aws_subnet.subnets : s.id if length(regexall("pública", s.tags.Name)) == 0]
}

output "sg_frontend_id" {
  value = aws_security_group.sg_frontend.id
}

output "sg_backend_id" {
  value = aws_security_group.sg_backend.id
}

output "alb_sg_ids" {
  description = "IDs de sg para ALBs"
  value       = { for k, sg in aws_security_group.alb_sgs : k => sg.id }
}