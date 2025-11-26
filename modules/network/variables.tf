variable "vpc_1_cidr" {
  description = "CIDR_prueba3"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_1_name" {
  description = "Nombre de la VPC"
  type        = string
  default     = "vpc-prueba3"
}

variable "subnets_cidr" {
  type        = list(string)
  description = "CIDR subredes"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", ]
}

variable "subnets_name" {
  type        = list(string)
  description = "Nombre de subredes"
  default     = ["Subred pública 1", "Subred pública 2", "Subred pública 3", "Subred privada 1", "Subred privada 2"]
}

variable "availability_zone" {
  type        = list(string)
  description = "Zonas de disponibilidad"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1a", "us-east-1b"] # CORREGIR
}

variable "igw_name" {
  type        = string
  description = "Nombre IGW"
  default     = "igw-us-east-1"
}

variable "ingress_cidr" {
  type        = string
  description = "CIDR IGW"
  default     = "0.0.0.0/0"
}

variable "rtb_association" {
  type = map(object({
    subnet_id      = string
    route_table_id = string
  }))
  default = {}
}

variable "alb_sg_names" {
  description = "Grupos de seguridad ALB"
  type        = set(string)
  default     = ["app1", "app2"]
}