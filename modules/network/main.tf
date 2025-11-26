# VPC
resource "aws_vpc" "vpc_1" {
  cidr_block           = var.vpc_1_cidr
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_1_name
  }
}

# Subredes
resource "aws_subnet" "subnets" {
  count                   = length(var.subnets_cidr)
  vpc_id                  = aws_vpc.vpc_1.id
  cidr_block              = element(var.subnets_cidr, count.index)
  availability_zone       = element(var.availability_zone, count.index)
  map_public_ip_on_launch = length(regexall("pública", var.subnets_name[count.index])) > 0 ? true : false

  tags = {
    Name = var.subnets_name[count.index]
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_1.id

  tags = {
    Name = var.igw_name
  }
}

# NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnets[0].id

  tags = {
    Name = "nat-gateway-${var.vpc_1_name}"
  }

  depends_on = [aws_internet_gateway.igw]
}

# TABLAS DE ENRUTAMIENTO

# PÚBLICA
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_1.id

  route {
    cidr_block = var.ingress_cidr
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public_rtb_vpc_1"
  }
}

# PRIVADA
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc_1.id

  route {
    cidr_block = var.ingress_cidr
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "Private_rtb_vpc_1"
  }
}

# Asociaciones de tablas de enrutamiento
resource "aws_route_table_association" "rtb_associations" {
  count     = length(var.subnets_cidr)
  subnet_id = aws_subnet.subnets[count.index].id

  route_table_id = length(regexall("pública", var.subnets_name[count.index])) > 0 ? aws_route_table.public_rt.id : aws_route_table.private_rt.id
}

# Grupos de seguridad
resource "aws_security_group" "sg_frontend" {
  name        = "sg_frontend_app"
  description = "Acceso HTTP y SSH"
  vpc_id      = aws_vpc.vpc_1.id

  dynamic "ingress" {
    for_each = [80, 22]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-frontend"
  }
}

resource "aws_security_group" "sg_backend" {
  name        = "sg_backend_db"
  description = "Acceso a bbdd desde frontend"
  vpc_id      = aws_vpc.vpc_1.id

  ingress {
    description     = "Acceso MySQL"
    from_port       = 3306
    protocol        = "tcp"
    to_port         = 3306
    security_groups = [aws_security_group.sg_frontend.id]
  }

  ingress {
    description     = "Acceso PostgreSQL"
    from_port       = 5432
    protocol        = "tcp"
    to_port         = 5432
    security_groups = [aws_security_group.sg_frontend.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-backend-db"
  }
}

resource "aws_security_group" "alb_sgs" {
  for_each    = var.alb_sg_names
  name        = "${each.key}_alb_sg"
  description = "Grupo de seguridad para ${each.key} ALB"
  vpc_id      = aws_vpc.vpc_1.id

  ingress {
    description = "Acceso HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.ingress_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.ingress_cidr]
  }

  tags = {
    Name = "${each.key}-alb-sg"
  }
}