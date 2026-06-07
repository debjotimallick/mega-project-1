module "vpc" {

  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "security_groups" {

  source = "./modules/security-groups"

  vpc_id = module.vpc.vpc_id
}

resource "aws_key_pair" "project_1" {

  key_name = "project_1"

  public_key = file("${path.module}/keys/project_1.pub")
}

module "bastion" {

  source = "./modules/ec2"

  instance_name = "bastion"

  instance_type = "t3.micro"

  subnet_id = module.vpc.public_subnet_ids[0]

  security_group_ids = [
    module.security_groups.bastion_sg_id
  ]

  associate_public_ip = true

  key_name = aws_key_pair.project_1.key_name
}

module "control_plane" {

  source = "./modules/ec2"

  instance_name = "control-plane"

  instance_type = "t3.medium"

  subnet_id = module.vpc.private_subnet_ids[0]

  security_group_ids = [
    module.security_groups.nodes_sg_id
  ]

  associate_public_ip = false

  key_name = aws_key_pair.project_1.key_name
}

module "worker1" {

  source = "./modules/ec2"

  instance_name = "worker-1"

  instance_type = "t3.medium"

  subnet_id = module.vpc.private_subnet_ids[1]

  security_group_ids = [
    module.security_groups.nodes_sg_id
  ]

  associate_public_ip = false

  key_name = aws_key_pair.project_1.key_name
}
