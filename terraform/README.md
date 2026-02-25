# AWS Terraform Stack

This Terraform setup is organized by reusable modules and deployable components.

## Folder structure

- `modules/app_stack`: Reusable infrastructure module (VPC, security, IAM, S3, ECR, ECS, EC2, RDS).
- `components/dev`: Environment/component root module that configures providers and calls `app_stack`.

## Usage

1. Move into the component directory:

```bash
cd terraform/components/dev
```

2. Copy example variables file:

```bash
copy terraform.tfvars.example terraform.tfvars
```

3. Initialize and validate:

```bash
terraform init
terraform validate
```

4. Plan and apply:

```bash
terraform plan
terraform apply
```

## CI/CD

- GitHub Actions: `.github/workflows/terraform.yml`
- GitLab CI: `.gitlab-ci.yml`

Both pipelines run:

- `terraform fmt -check -recursive`
- `terraform init -backend=false` and `terraform validate` for each component in `terraform/components/*`
- `terraform plan` on main branch when AWS credentials are available
