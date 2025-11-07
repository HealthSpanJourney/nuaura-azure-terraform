# Azure Hub-Spoke Network Terraform Configuration

This Terraform configuration deploys a hub-spoke network architecture in Azure with the following components:

## Architecture Overview

- Hub VNet with:
  - Gateway subnet
  - Runner subnet
  - DNS Resolver subnets (optional)
- Spoke VNet with:
  - App Service Integration subnet
  - Azure Container Apps Environment subnet
- VNet peering between hub and spoke
- Azure Private DNS Resolver (optional)

## Prerequisites

- Terraform >= 1.5.0
- Azure CLI or Service Principal with appropriate permissions
- Azure subscription

## Quick Start

1. **Initialize Terraform**
   ```bash
   terraform init
   ```

2. **Configure Variables**
   Copy `dev.tfvars.example` to `dev.tfvars` and adjust values:
   ```bash
   cp dev.tfvars.example dev.tfvars
   ```

3. **Authenticate to Azure**
   ```bash
   az login
   # OR use Service Principal
   export ARM_CLIENT_ID="your-client-id"
   export ARM_CLIENT_SECRET="your-client-secret"
   export ARM_SUBSCRIPTION_ID="your-subscription-id"
   export ARM_TENANT_ID="your-tenant-id"
   ```

4. **Plan and Apply**
   ```bash
   terraform plan -out=plan.tfplan -var-file=dev.tfvars
   terraform apply "plan.tfplan"
   ```

## Module Structure

```
.
├── main.tf           # Main configuration
├── variables.tf      # Input variables
├── outputs.tf        # Output values
└── modules/
    └── hub_spoke_network/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Input Variables

| Name | Description | Type | Required |
|------|-------------|------|----------|
| environment | Environment name (dev/staging/prod) | string | yes |
| resource_group | Resource group configuration | object | yes |
| hub | Hub VNet configuration | object | yes |
| spoke | Spoke VNet configuration | object | yes |
| dns_resolver_enabled | Enable/disable DNS resolver | bool | no |
| peering_options | VNet peering options | object | no |
| tags | Resource tags | map(string) | no |

## Resource Naming

Resources follow this naming convention:
- Resource Group: `rg-nuaura-tech-{env}`
- Hub VNet: `vnet-nuau-{env}-hub`
- Spoke VNet: `vnet-nuau-{env}-spoke`

## Network Address Spaces

- Hub VNet: 10.0.0.0/16
  - Gateway Subnet: 10.0.0.0/27
  - Runner Subnet: 10.0.0.32/27
  - DNS Resolver Inbound: 10.0.0.96/27
  - DNS Resolver Outbound: 10.0.0.128/27

- Spoke VNet: 10.1.0.0/16
  - App Service Integration: 10.1.0.0/26
  - ACA Environment: 10.1.0.64/26

## Maintenance

### Adding New Subnets

1. Add subnet CIDR to the appropriate VNet variable block
2. Update module variables.tf
3. Modify module main.tf to create subnet

### Importing Existing Resources

To import an existing resource group:
```bash
terraform import module.hub_spoke_network.azurerm_resource_group.this[0] /subscriptions/<sub-id>/resourceGroups/<rg-name>
```

## Security Notes

- Ensure proper RBAC permissions for service principals
- Review peering options before enabling gateway transit
- Monitor subnet delegation permissions

## Contributing

1. Create feature branch
2. Make changes
3. Run `terraform fmt -recursive`
4. Test with `terraform plan`
5. Submit PR

## License

Copyright (c) 2023 Nuaura Technologies