#----------------------------------------------------------------------------------
# Create VNET FGT and subnets
#----------------------------------------------------------------------------------
# Create VNet
resource "azurerm_virtual_network" "vnet-fgt" {
  name                = "${var.prefix}-vnet-fgt"
  address_space       = [var.vnet-fgt_cidr]
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}
# Create subnets
resource "azurerm_subnet" "subnet-public" {
  name                 = "${var.prefix}-subnet-public"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [local.subnet_public_cidr]
}
resource "azurerm_subnet" "subnet-private" {
  name                 = "${var.prefix}-subnet-private"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [local.subnet_private_cidr]
}
resource "azurerm_subnet" "subnet-bastion" {
  name                 = "${var.prefix}-subnet-bastion"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [local.subnet_bastion_cidr]
}
#----------------------------------------------------------------------------------
# Create public IPs and interfaces (Active and passive FGT)
#----------------------------------------------------------------------------------
// Active service public IP
resource "azurerm_public_ip" "public-ip" {
  name                = local.fgt_public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"

  tags = var.tags
}
//  FGT Network Interface Public
resource "azurerm_network_interface" "ni-public" {
  name                           = local.fgt_ni_public_name
  location                       = var.location
  resource_group_name            = var.resource_group_name
  ip_forwarding_enabled          = true
  accelerated_networking_enabled = var.accelerate

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-public.id
    private_ip_address_allocation = "Static"
    private_ip_address            = local.fgt_ni_public_ip
    public_ip_address_id          = azurerm_public_ip.public-ip.id
  }

  tags = var.tags
}
// FGT Network Interface Private
resource "azurerm_network_interface" "ni-private" {
  name                           = local.fgt_ni_private_name
  location                       = var.location
  resource_group_name            = var.resource_group_name
  ip_forwarding_enabled          = true
  accelerated_networking_enabled = var.accelerate

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-private.id
    private_ip_address_allocation = "Static"
    private_ip_address            = local.fgt_ni_private_ip
  }

  tags = var.tags
}