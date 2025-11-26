variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "IDs subredes privadas"
}

variable "sg_backend_id" {
  type        = string
  description = "ID sg bbdd"
}
