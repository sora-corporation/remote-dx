data "aws_ssm_parameter" "amazon_linux2_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "template_file" "tailscale_user_data" {
  template = file("${path.module}/tailscale_user_data.sh.tpl")

  vars = {
    tailscale_authkey = var.tailscale_authkey
  }
}

resource "aws_key_pair" "developer" {
  key_name   = "developer"
  public_key = var.developer_pubkey
}

resource "aws_instance" "relay" {
  ami                         = data.aws_ssm_parameter.amazon_linux2_ami.value
  instance_type               = "t3.nano"
  iam_instance_profile        = var.default_ec2_profile_id
  subnet_id                   = element(module.vpc.public_subnets, 0)
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.tailscale_relay.id
  ]

  user_data = data.template_file.tailscale_user_data.rendered

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted   = true
    volume_size = 30
  }

  tags = {
    Name    = "tailscale-relay"
    Project = local.project_name
  }
}

resource "aws_instance" "dev_1" {
  ami                         = data.aws_ssm_parameter.amazon_linux2_ami.value
  instance_type               = "t3.large"
  iam_instance_profile        = var.default_ec2_profile_id
  subnet_id                   = element(module.vpc.private_subnets, 0)
  associate_public_ip_address = false

  key_name = aws_key_pair.developer.key_name
  vpc_security_group_ids = [
    aws_security_group.under_tailscale.id
  ]

  user_data = file("${path.module}/tiny_user_data.sh")

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted   = true
    volume_size = 100
  }

  tags = {
    Name    = "under-tailscale"
    Project = local.project_name
  }
}
