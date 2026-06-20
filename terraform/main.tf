module "vpc" {

  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "security_groups" {

  source = "./modules/security-groups"

  vpc_id   = module.vpc.vpc_id
  vpc_cidr = var.vpc_cidr
}

module "aws_ebs_csi_driver_role" {

  source    = "./modules/role"
  role_name = "AWSEBSCSIDriverRole"

  tags = {
    Name = "AWSEBSCSIDriverRole"
  }
}

resource "aws_key_pair" "ssh_key" {

  key_name = "ssh_key"

  public_key = file("${path.module}/keys/ssh_key.pub")
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

  key_name = aws_key_pair.ssh_key.key_name
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

  iam_instance_profile = module.aws_ebs_csi_driver_role.instance_profile_name

  key_name = aws_key_pair.ssh_key.key_name
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

  iam_instance_profile = module.aws_ebs_csi_driver_role.instance_profile_name

  key_name = aws_key_pair.ssh_key.key_name
}

module "worker2" {

  source = "./modules/ec2"

  instance_name = "worker-2"

  instance_type = "t3.medium"

  subnet_id = module.vpc.private_subnet_ids[1]

  security_group_ids = [
    module.security_groups.nodes_sg_id
  ]

  associate_public_ip = false

  iam_instance_profile = module.aws_ebs_csi_driver_role.instance_profile_name

  key_name = aws_key_pair.ssh_key.key_name
}

module "nat" {

  source = "./modules/ec2"

  instance_name = "nat"

  instance_type = "t3.micro"

  subnet_id = module.vpc.public_subnet_ids[1]

  security_group_ids = [
    module.security_groups.nat_sg_id
  ]

  associate_public_ip = true

  source_dest_check = false

  key_name = aws_key_pair.ssh_key.key_name

  user_data = file("${path.module}/userdata/nat.sh")
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

resource "aws_eip_association" "nat" {
  instance_id   = module.nat.instance_id
  allocation_id = aws_eip.nat.id
}

resource "aws_route" "private_nat" {
  route_table_id         = module.vpc.private_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = module.nat.primary_network_interface_id
}
