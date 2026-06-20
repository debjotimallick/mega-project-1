data "aws_ami" "ubuntu" {

  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-resolute-26.04-amd64-server-*"]
  }
}

resource "aws_instance" "this" {

  ami = data.aws_ami.ubuntu.id

  instance_type = var.instance_type

  subnet_id = var.subnet_id

  vpc_security_group_ids = var.security_group_ids

  associate_public_ip_address = var.associate_public_ip

  key_name = var.key_name

  iam_instance_profile = var.iam_instance_profile

  source_dest_check = var.source_dest_check

  user_data_base64 = base64encode(var.user_data)

  tags = {
    Name = var.instance_name
  }
}
