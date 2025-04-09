#------------------------------------------------------------------
# Create FGT HUB 
# - Create cluster FGCP config
# - Create FGCP instances
# - Create VNet
# - Create LB
#------------------------------------------------------------------
module "fgt_config" {
  source = "./modules/fgt-config"

  admin_cidr     = var.admin_cidr
  admin_port     = var.admin_port
  rsa-public-key = tls_private_key.ssh.public_key_openssh
  api_key        = var.fgt_api_key_enabled ? random_string.api_key.result : ""

  subnet_cidrs       = module.fgt_vnet.subnet_cidrs
  fgt-active-ni_ips  = module.fgt_vnet.fgt-active-ni_ips
  fgt-passive-ni_ips = module.fgt_vnet.fgt-passive-ni_ips

  license_type      = var.license_type
  fortiflex_token_1 = try(var.fortiflex_tokens[0], "")
  fortiflex_token_2 = try(var.fortiflex_tokens[1], "")

  config_fgcp    = true
  vpc-spoke_cidr = [module.fgt_vnet.subnet_cidrs["bastion"]]
}

// Create FGT cluster spoke
// (Example with a full scenario deployment with all modules)
module "fgt" {
  source = "./modules/fgt-ha"

  prefix              = var.prefix
  location            = var.location
  resource_group_name = var.resource_group_name == null ? azurerm_resource_group.rg[0].name : var.resource_group_name
  tags                = var.tags

  admin_username = var.admin_username
  admin_password = local.admin_password

  fgt-active-ni_ids  = module.fgt_vnet.fgt-active-ni_ids
  fgt-passive-ni_ids = module.fgt_vnet.fgt-passive-ni_ids
  fgt_config_1       = module.fgt_config.fgt_config_1
  fgt_config_2       = module.fgt_config.fgt_config_2

  fgt_passive  = true
  license_type = var.license_type
  fgt_version  = var.fgt_version
  size         = var.fgt_size
}

// Module VNET for FGT
// - This module will generate VNET and network intefaces for FGT cluster
module "fgt_vnet" {
  source = "./modules/vnet-fgt"

  prefix              = var.prefix
  location            = var.location
  resource_group_name = var.resource_group_name == null ? azurerm_resource_group.rg[0].name : var.resource_group_name
  tags                = var.tags

  vnet-fgt_cidr = var.fgt_vnet_cidr
  admin_port    = var.admin_port
  admin_cidr    = var.admin_cidr

  config_xlb = true // module variable to associate a public IP to fortigate's public interface (when using External LB, true means not to configure a public IP)
}

// Create load balancers
module "xlb" {
  depends_on = [module.fgt_vnet]
  source     = "./modules/xlb"

  prefix              = var.prefix
  location            = var.location
  resource_group_name = var.resource_group_name == null ? azurerm_resource_group.rg[0].name : var.resource_group_name
  tags                = var.tags

  config_gwlb        = local.config_gwlb
  ilb_ip             = local.ilb_ip
  backend-probe_port = local.backend_probe_port

  vnet-fgt           = module.fgt_vnet.vnet
  subnet_ids         = module.fgt_vnet.subnet_ids
  subnet_cidrs       = module.fgt_vnet.subnet_cidrs
  fgt-active-ni_ips  = module.fgt_vnet.fgt-active-ni_ips
  fgt-passive-ni_ips = module.fgt_vnet.fgt-passive-ni_ips
}



#-----------------------------------------------------------------------
# Necessary Resources
#-----------------------------------------------------------------------
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
resource "local_file" "ssh_private_key_pem" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "./ssh-key/${var.prefix}-ssh-key.pem"
  file_permission = "0600"
}

# Create new random API key to be provisioned in FortiGates.
resource "random_string" "api_key" {
  length  = 30
  special = false
  numeric = true
}

# Create ramdom password for FortiGates
resource "random_string" "admin_password" {
  length           = 20
  special          = true
  override_special = "#?!&"
}

// Create Resource Group if it is null
resource "azurerm_resource_group" "rg" {
  count    = var.resource_group_name == null ? 1 : 0
  name     = "${var.prefix}-rg"
  location = var.location

  tags = var.tags
}