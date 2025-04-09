locals {
  # ----------------------------------------------------------------------------------
  # Subnet cidrs (UPDATE IF NEEDED)
  # ----------------------------------------------------------------------------------
  subnet_public_cidr      = cidrsubnet(var.vnet-fgt_cidr, 2, 0)
  subnet_private_cidr     = cidrsubnet(var.vnet-fgt_cidr, 2, 1)
  subnet_bastion_cidr     = cidrsubnet(var.vnet-fgt_cidr, 2, 2)

  # ----------------------------------------------------------------------------------
  # FGT (UPDATE IF NEEDED)
  # ----------------------------------------------------------------------------------
  fgt_ni_public_ip  = cidrhost(local.subnet_public_cidr, 10)
  fgt_ni_private_ip = cidrhost(local.subnet_private_cidr, 10)

  fgt_ni_public_name  = "${var.prefix}-ni-public"
  fgt_ni_private_name = "${var.prefix}-ni-private"

  fgt_public_ip_name = "${var.prefix}-public-ip"
}