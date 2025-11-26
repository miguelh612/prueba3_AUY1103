module "network" {
  source = "./modules/network"
}

module "ec2" {
  source            = "./modules/ec2"
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  sg_frontend_id    = module.network.sg_frontend_id
  alb_sg_ids        = module.network.alb_sg_ids
}

module "rds" {
  source             = "./modules/rds"
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  sg_backend_id      = module.network.sg_backend_id
}