# Azure Terraform State Bootstrap

Creates the Azure Storage Account and blob container used for Terraform remote state.

The bootstrap is intentionally local-state based because it creates the remote backend itself.

## Usage

1. Authenticate with Azure.
2. Review `terraform.tfvars.example` and create a local `terraform.tfvars`.
3. Run:

```bash
az login
terraform init
terraform fmt -check
terraform validate
terraform plan
terraform apply
```

4. Record the storage account/container outputs.
5. Configure `environments/azure/dev` to use the created `azurerm` backend.

Do not commit `terraform.tfvars`.
