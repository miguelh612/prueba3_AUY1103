# modules/ec2/variables.tf

variable "vpc_id" {
  type        = string
  description = "ID de la VPC principal"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Lista de IDs de subredes públicas para los servidores web"
}

variable "sg_frontend_id" {
  type        = string
  description = "ID del Security Group para las instancias EC2"
}

variable "alb_sg_ids" {
  type        = map(string)
  description = "Mapa de IDs de Security Groups para los balanceadores"
}

variable "ec2_specs" {
  description = "Configuraciones de instancias EC2"
  type = map(object({
    ami           = string
    instance_type = string
    disk_size     = number
    subnet_index  = number
    app_tag       = string
  }))

  default = {
    "app-1-a" = {
      ami           = "ami-0fa3fe0fa7920f68e"
      instance_type = "t3.micro"
      disk_size     = 50
      subnet_index  = 0
      app_tag       = "App1"
    },
    "app-1-b" = {
      ami           = "ami-0fa3fe0fa7920f68e"
      instance_type = "t3.micro"
      disk_size     = 50
      subnet_index  = 1
      app_tag       = "App1"
    },
    "app-1-c" = {
      ami           = "ami-0fa3fe0fa7920f68e"
      instance_type = "t3.micro"
      disk_size     = 50
      subnet_index  = 2
      app_tag       = "App1"
    },
    "app-2-a" = {
      ami           = "ami-0b4bc1e90f30ca1ec"
      instance_type = "t3.micro"
      disk_size     = 100
      subnet_index  = 0
      app_tag       = "App2"
    },
    "app-2-b" = {
      ami           = "ami-0b4bc1e90f30ca1ec"
      instance_type = "t3.micro"
      disk_size     = 100
      subnet_index  = 1
      app_tag       = "App2"
    }
  }
}
