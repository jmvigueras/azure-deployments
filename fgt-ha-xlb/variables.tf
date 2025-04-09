// Azure configuration
//variable "client_id" {}
//variable "client_secret" {}
//variable "tenant_id" {}
variable "subscription_id" {}

variable "prefix" {
  description = "Prefix to be added to all resources as a prefix"
  type        = string
  default     = "fgt-xlb"
}

variable "location" {
  description = "Azure region where the solution is deployed"
  type        = string
  default     = "francecentral"
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
  default     = null
}

variable "storage-account_endpoint" {
  description = "Storage account endpoint"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to be added to all resources"
  type        = map(string)
  default = {
    "environment" = "demo"
    "project"     = "terraform-fortinet"
  }
}

variable "admin_port" {
  description = "Fortigate admin port"
  type        = string
  default     = "8443"
}

variable "admin_cidr" {
  description = "Fortigate HA port"
  type        = string
  default     = "0.0.0.0/0"
}

variable "admin_username" {
  description = "FortiGate of admin_username"
  type        = string
  default     = "azureadmin"
}

variable "admin_password" {
  description = "FortiGate admin password"
  type        = string
  default     = null
}

variable "license_type" {
  description = "value of license type"
  type        = string
  default     = "payg"
}

variable "fortiflex_tokens" {
  description = "List of FortiFlex licenses tokens"
  type        = list(string)
  default     = []
}

variable "fgt_size" {
  description = "FortiGate instance size"
  type        = string
  default     = "Standard_F4s"
}

variable "fgt_version" {
  description = "FortiGate version"
  type        = string
  default     = "7.4.7"
}

variable "fgt_vnet_cidr" {
  description = "FortiGate Vnet IP Space"
  type        = string
  default     = "172.30.0.0/24"
}

variable "ilb_ip" {
  description = "Private IP for internal Load Balancer"
  type        = string
  default     = null
}

variable "backend_probe_port" {
  description = "Private IP for internal Load Balancer"
  type        = string
  default     = null
}

variable "fgt_api_key_enabled" {
  description = "Create FortiGate API key"
  type        = bool
  default     = false
}
