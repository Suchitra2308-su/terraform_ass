module "networking" {
  source       = "./modules/networking"
  project_name = var.project_name
}

module "ssh_key" {
  source       = "./modules/ssh-key"
  project_name = var.project_name
}

module "ec2" {
  source            = "./modules/ec2"
  project_name      = var.project_name
  public_subnet_id  = module.networking.public_subnet_id
  private_subnet_id = module.networking.private_subnet_id
  key_name         = module.ssh_key.key_name
  vpc_id           = module.networking.vpc_id
}
