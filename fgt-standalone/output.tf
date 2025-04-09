output "fgt" {
  value = {
    admin    = var.admin_username
    pass     = local.admin_password
    mgmt_url = "https://${module.fgt_vnet.fgt_public_ip}:${var.admin_port}"
  }
}

output "fgt_ips" {
  value = module.fgt_vnet.fgt_ni_ips
}

output "subnet_cidrs" {
  value = module.fgt_vnet.subnet_cidrs
}

output "resource_group_name" {
  value = var.resource_group_name == null ? azurerm_resource_group.rg[0].name : var.resource_group_name
}