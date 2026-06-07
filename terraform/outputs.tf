output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnet_ids
}

output "private_subnets" {
  value = module.vpc.private_subnet_ids
}

output "bastion_public_ip" {
  value = module.bastion.public_ip
}

output "control_plane_private_ip" {
  value = module.control_plane.private_ip
}

output "worker1_private_ip" {
  value = module.worker1.private_ip
}

output "worker2_private_ip" {
  value = module.worker2.private_ip
}

output "nat_public_ip" {
  value = module.nat.public_ip
}
