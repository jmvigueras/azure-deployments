output "fgt_public_ip" {
  value = azurerm_public_ip.public-ip.ip_address
}

output "vnet" {
  value = {
    name = azurerm_virtual_network.vnet-fgt.name
    id   = azurerm_virtual_network.vnet-fgt.id
  }
}

output "vnet_names" {
  value = {
    vnet-fgt = azurerm_virtual_network.vnet-fgt.name
  }
}

output "fgt_ni_ids" {
  value = {
    public  = azurerm_network_interface.ni-public.id
    private = azurerm_network_interface.ni-private.id
  }
}

output "fgt_ni_names" {
  value = {
    public  = local.fgt_ni_public_name
    private = local.fgt_ni_private_name
  }
}

output "fgt_ni_ips" {
  value = {
    public  = local.fgt_ni_public_ip
    private = local.fgt_ni_private_ip
  }
}

output "subnet_cidrs" {
  value = {
    public  = azurerm_subnet.subnet-public.address_prefixes[0]
    private = azurerm_subnet.subnet-private.address_prefixes[0]
    bastion = azurerm_subnet.subnet-bastion.address_prefixes[0]
  }
}

output "subnet_names" {
  value = {
    public  = azurerm_subnet.subnet-public.name
    private = azurerm_subnet.subnet-private.name
    bastion = azurerm_subnet.subnet-bastion.name
  }
}

output "subnet_ids" {
  value = {
    public  = azurerm_subnet.subnet-public.id
    private = azurerm_subnet.subnet-private.id
    bastion = azurerm_subnet.subnet-bastion.id
  }
}

output "nsg_ids" {
  value = {
    public          = azurerm_network_security_group.nsg-public.id
    private         = azurerm_network_security_group.nsg-private.id
    bastion         = azurerm_network_security_group.nsg_bastion_admin_cidr.id
    bastion_default = azurerm_network_security_group.nsg_bastion_default.id
    public_default  = azurerm_network_security_group.nsg-public-default.id
  }
}

output "nsg-public_id" {
  value = azurerm_network_security_group.nsg-public.id
}

output "nsg-private_id" {
  value = azurerm_network_security_group.nsg-private.id
}