# Forigate standalone deployment
## Introduction

This deployment will create two Fortigate instance. 

## Module use

### Variables

- `prefix`: Prefix to be used for resource naming
- `location`: Azure region where resources will be deployed
- `admin_cidr`: CIDR range for admin access
- `admin_username`: Administrator username for FortiGate instances
- `admin_password`: Administrator password for FortiGate instances
- `fgt_vnet_cidr`: CIDR block for the FortiGate VNet
- `resource_group_name`: Name of existing resource group (will create new if not specified)
- `license_type`: FortiGate license type (BYOL or PAYG)
- `fgt_version`: FortiGate version to deploy
- `fgt_size`: Azure VM size for FortiGate instances
- `tags`: Map of tags to apply to resources

> [!NOTE]
> Those variables have a default value and if not provided, Azure related resources will be deployed or default values will be used. 

### Terraform code

```hcl
module "fgt-ha_onramp_xlb" {
    source = "./"

    resource_group_name = "<Resource Group Name>" // (optional)
    location = "francecentral"

    prefix = "fgt-standalone"

    admin_cidr = "0.0.0.0/0"
    admin_username = "azureadmin"
    admin_password = "your-secret-password"

    fgt_vnet_cidr = "172.30.0.0/23"
}
```

## Deployment Overview

- New VNet with necessary subents: Public and Private
- Fortigate standalone.

## Requirements
* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) >= 1.0.0
* Check particulars requiriments for each deployment (Azure) 

## Support
This a personal repository with goal of testing and demo Fortinet solutions on the Cloud. No support is provided and must be used by your own responsability. Cloud Providers will charge for this deployments, please take it in count before proceed.

