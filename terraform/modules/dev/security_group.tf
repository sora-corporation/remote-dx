resource "aws_security_group" "internet_access" {
  vpc_id      = module.vpc.vpc_id
  name        = "Internet Access"
  description = "Allow internet access"

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    #tfsec:ignore:aws-vpc-no-public-egress-sg
    #tfsec:ignore:aws-vpc-no-public-egress-sgr
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow anywhere"
  }
}

resource "aws_security_group" "tailscale_relay" {
  vpc_id      = module.vpc.vpc_id
  name        = "Tailscale Relay"
  description = "For Tailscale Relay"

  ingress {
    from_port   = 41641
    to_port     = 41641
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow Tailscale(Wireguard) port from anywhere"
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    #tfsec:ignore:aws-vpc-no-public-egress-sg
    #tfsec:ignore:aws-vpc-no-public-egress-sgr
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow anywhere"
  }

  tags = {
    Name    = "tailscale-relay"
    Project = local.project_name
  }
}

resource "aws_security_group" "under_tailscale" {
  vpc_id      = module.vpc.vpc_id
  name        = "Under Tailscale"
  description = "For Tailscale Network"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.tailscale_relay.id]
    description     = "Allow all from relay"
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    #tfsec:ignore:aws-vpc-no-public-egress-sg
    #tfsec:ignore:aws-vpc-no-public-egress-sgr
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow anywhere"
  }

  tags = {
    Name    = "tailscale-relay"
    Project = local.project_name
  }
}
