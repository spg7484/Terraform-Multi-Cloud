# AWS Terraform State Bootstrap

Creates the S3 bucket used for Terraform remote state.

This bootstrap is intentionally local-state based because it creates the remote backend itself.

## Usage

1. Authenticate to the target AWS account.
2. Review `terraform.tfvars.example` and create a local `terraform.tfvars`.
3. Run:

```bash
terraform init
terraform fmt -check
terraform validate
terraform plan
terraform apply
```

4. Record the bucket name/output.
5. Configure the environment backend in `environments/aws/dev` to use the created bucket.

Do not commit `terraform.tfvars` if it contains account-specific or sensitive values.
