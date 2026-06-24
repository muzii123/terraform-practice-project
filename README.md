# 🚀 Terraform AWS Infrastructure Project

A beginner-friendly Terraform project to automate AWS infrastructure including **EC2 Ubuntu VM**, **S3 Bucket**, and more — all managed as code.

---

## 📋 Table of Contents

- [About the Project](#about-the-project)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
- [Usage](#usage)
- [Outputs](#outputs)
- [SSH into Ubuntu VM](#ssh-into-ubuntu-vm)
- [Remote State (S3 Backend)](#remote-state-s3-backend)
- [Recovering Lost State](#recovering-lost-state)
- [Contributing](#contributing)

---

## 📖 About the Project

This project uses **Terraform** (Infrastructure as Code) to automatically create and manage AWS resources. Instead of clicking around in the AWS Console, everything is defined in code and created with a single command.

### What This Project Creates

| Resource | Description |
|---|---|
| 🖥️ EC2 Instance | Ubuntu 22.04 Virtual Machine |
| 🪣 S3 Bucket | Storage bucket with versioning & encryption |
| 🔐 Security Group | Firewall rules (SSH access on port 22) |
| 🔑 Key Pair | SSH key for secure VM access |

---

## 📁 Project Structure

```
Terraform-pratice/
├── main.tf                      # Main resources (EC2, S3, Security Group)
├── providers.tf                 # AWS provider configuration
├── variables.tf                 # Variable definitions
├── terraform.tfvars             # Variable values (DO NOT commit to GitHub!)
├── outputs.tf                   # Output values after apply
├── terraform.tfstate            # Terraform state file (auto-generated)
├── terraform.tfstate.backup     # Backup state file (auto-generated)
├── .terraform.lock.hcl          # Provider version lock file
├── .gitignore                   # Files to exclude from Git
└── README.md                    # This file
```

---

## ✅ Prerequisites

Make sure you have these installed before starting:

| Tool | Version | Install |
|---|---|---|
| Terraform | >= 1.0 | [terraform.io/downloads](https://terraform.io/downloads) |
| AWS CLI | >= 2.0 | [aws.amazon.com/cli](https://aws.amazon.com/cli) |
| Git | Any | [git-scm.com](https://git-scm.com) |
| AWS Account | - | [aws.amazon.com](https://aws.amazon.com) |

---

## 🚀 Getting Started

### Step 1: Clone the Repository

```bash
git clone https://github.com/muzii123/terraform-practice-project.git
cd terraform-practice-project
```

### Step 2: Set Up AWS Credentials

```bash
aws configure
```

Enter your details:
```
AWS Access Key ID:     YOUR_ACCESS_KEY
AWS Secret Access Key: YOUR_SECRET_KEY
Default region name:   us-east-1
Default output format: json
```

### Step 3: Create Your `terraform.tfvars` File

```bash
# Create the file (never commit this to GitHub!)
nano terraform.tfvars
```

Add your values:
```hcl
region        = "us-east-1"
env           = "dev"
instance_type = "t2.micro"
key_name      = "your-key-pair-name"
bucket_prefix = "my-app-bucket"
```

### Step 4: Generate SSH Key Pair

```bash
# On Windows (PowerShell)
ssh-keygen -t rsa -b 4096 -f $HOME\.ssh\terraform-key

# On Linux/Mac
ssh-keygen -t rsa -b 4096 -f ~/.ssh/terraform-key
```

### Step 5: Initialize Terraform

```bash
terraform init
```

You should see:
```
Terraform has been successfully initialized! ✅
```

### Step 6: Preview Changes

```bash
terraform plan
```

### Step 7: Create Infrastructure

```bash
terraform apply
```

Type `yes` when prompted. After completion you will see your outputs like:

```
Apply complete! Resources: 4 added.

Outputs:
instance_public_ip = "54.123.45.67"
environment        = "dev"
generated_string   = "ab3x9z"
bucket_name        = "my-app-bucket-ab3x9z"
```

---

## ⚙️ Configuration

### Variables Reference

| Variable | Description | Default |
|---|---|---|
| `region` | AWS region to deploy in | `us-east-1` |
| `env` | Environment name (dev/staging/prod) | `dev` |
| `instance_type` | EC2 instance size | `t2.micro` |
| `key_name` | AWS Key Pair name for SSH | required |
| `bucket_prefix` | Prefix for S3 bucket name | `my-app-bucket` |

---

## 📤 Outputs

After `terraform apply`, these values are displayed:

| Output | Description |
|---|---|
| `instance_public_ip` | Public IP of your Ubuntu VM |
| `environment` | Environment name used |
| `generated_string` | Random suffix for unique naming |
| `bucket_name` | Full name of created S3 bucket |

To view outputs anytime:
```bash
terraform output
```

---

## 🔐 SSH into Ubuntu VM

After `terraform apply`, connect to your VM:

```bash
# On Windows (PowerShell)
ssh -i $HOME\.ssh\terraform-key ubuntu@<instance_public_ip>

# On Linux/Mac
ssh -i ~/.ssh/terraform-key ubuntu@<instance_public_ip>
```

Replace `<instance_public_ip>` with the IP from your outputs.

### Common SSH Issues

| Error | Fix |
|---|---|
| `Permission denied` | Check key path and use `ubuntu` as username |
| `Connection timed out` | Wait 1-2 mins after apply, check Security Group port 22 |
| `Unprotected key file` | Run `chmod 400 ~/.ssh/terraform-key` (Linux/Mac) |

---

## ☁️ Remote State (S3 Backend)

To avoid losing your `terraform.tfstate` file, store it remotely in S3.

Add this to `providers.tf`:

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
```

Then run:
```bash
terraform init  # migrates state to S3 automatically
```

---

## 🔄 Recovering Lost State

If you ever lose your `.tfstate` file:

```
Option 1: Check terraform.tfstate.backup → copy it back
Option 2: If using S3 backend → terraform init downloads it automatically
Option 3: Re-import resources manually:
```

```bash
# Re-import EC2 instance
terraform import aws_instance.my_ec2 i-0abc123def456

# Re-import S3 bucket
terraform import aws_s3_bucket.my_bucket your-bucket-name
```

---

## 🗑️ Destroy Infrastructure

To delete everything Terraform created:

```bash
terraform destroy
```

> ⚠️ This will permanently delete all resources. Make sure you want to do this!

---

## 🔒 Security Notes

- **Never commit** `terraform.tfvars` to GitHub (contains AWS keys)
- **Never commit** `terraform.tfstate` to GitHub (contains sensitive data)
- Both are listed in `.gitignore` for safety
- Always use **IAM roles** with minimum required permissions
- Keep your `.pem` / SSH private key safe and never share it

---

## 🤝 Contributing

1. Fork the repository
2. Create a new branch (`git checkout -b feature/my-feature`)
3. Make your changes
4. Commit (`git commit -m "Add my feature"`)
5. Push (`git push origin feature/my-feature`)
6. Open a Pull Request

---

## 👤 Author

**mmuza** — [@muzii123](https://github.com/muzii123)

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

> 💡 **Tip:** Always run `terraform plan` before `terraform apply` to preview changes safely!