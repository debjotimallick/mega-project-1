resource "aws_security_group" "bastion" {

  name        = "bastion-sg"
  description = "SSH access to bastion"
  vpc_id      = var.vpc_id

  ingress {

    from_port = 22
    to_port   = 22

    protocol = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "bastion-sg"
  }
}

resource "aws_security_group" "nodes" {

  name        = "nodes-sg"
  description = "Kubernetes Nodes"
  vpc_id      = var.vpc_id

  ingress {

    from_port = 22
    to_port   = 22

    protocol = "tcp"

    security_groups = [
      aws_security_group.bastion.id
    ]
  }

  ingress {

    from_port = 6443
    to_port   = 6443

    protocol = "tcp"

    self = true
  }

  ingress {

    from_port = 10250
    to_port   = 10250

    protocol = "tcp"

    self = true
  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "nodes-sg"
  }
}

