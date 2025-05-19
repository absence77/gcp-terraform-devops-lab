# 🚀 Automating Terraform for GCP with GitHub Actions

> Complete guide: set up CI/CD for Terraform, GCP, and GitHub Actions using a service account and remote backend in Google Cloud Storage.

---

## 📌 Goal

- Create a GCP service account with required permissions
- Create a GCS bucket to store Terraform state
- Add the key to GitHub Secrets (as base64)
- Create a working GitHub Actions workflow

👉 [Example repository](https://github.com/absence77/gcp-terraform-devops-lab)

---

## ✅ Step 1: Create a service account in GCP

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Navigate to **IAM & Admin → Service Accounts**
3. Click **Create Service Account**:
   - Name: `terraform-ci`
   - Description: "CI/CD Terraform GitHub"
4. Click **Create and continue**
5. Add roles:
   - `Editor` (for general access)
   - Or fine-grained roles: `Compute Admin`, `VPC Admin`, `Storage Admin`
6. Click **Done**

---

## 💼 Step 2: Create a GCS bucket for backend

1. Go to: [Cloud Storage → Buckets](https://console.cloud.google.com/storage/browser)
2. Click **Create bucket**:
   - Name: `my-terraform-backend-bucket` *(must be globally unique)*
   - Region: `us-central1`
   - Access Control: `Fine-grained`
3. Click **Create**

---

## 🔑 Step 3: Grant access to the bucket

1. Go to: **IAM → IAM**
2. Find the account `terraform-ci@...`
3. Click **Edit access → Add role**
4. Select `Storage Admin`

---

## 📁 Step 4: Configure `backend.tf`

Create the file `backend.tf`:

```hcl
terraform {
  backend "gcs" {
    bucket  = "my-terraform-backend-bucket"
    prefix  = "terraform/state"
  }
}
```

---

## 🔄 Step 5: Initialize backend locally (run once)

```bash
terraform init
```

---

## 🔐 Step 6: Create a JSON key for the service account

1. Go to **IAM → Service Accounts → terraform-ci**
2. Click the **Keys** tab
3. Click **Add key → Create new key**
4. Select **JSON** and click **Create**
5. The file `terraform-ci-key.json` will be downloaded

---

## 🧬 Step 7: Convert key to base64

```bash
base64 terraform-ci-key.json > key_base64.txt
```

Open `key_base64.txt` and copy the entire string.

---

## 🛡️ Step 8: Add secret to GitHub

1. Go to your GitHub repo → **Settings → Secrets and variables → Actions**
2. Click **New repository secret**
3. Fill in:
   - Name: `GCP_CREDENTIALS_BASE64`
   - Value: paste the content from `key_base64.txt`

---

## 🤖 Step 9: Configure GitHub Actions workflow

Create `.github/workflows/terraform.yml`:

```yaml
name: Terraform GCP Plan

on:
  push:
    branches:
      - master
  pull_request:

jobs:
  terraform:
    name: Terraform Plan
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.5.7

      - name: Create credentials file from secret
        run: |
          echo "${{ secrets.GCP_CREDENTIALS_BASE64 }}" | base64 -d > $HOME/gcp-key.json
          echo "GOOGLE_APPLICATION_CREDENTIALS=$HOME/gcp-key.json" >> $GITHUB_ENV

      - name: Terraform Init
        run: terraform init

      - name: Terraform Plan
        run: terraform plan -var-file="terraform.tfvars"
```

---

## 📀 What happens in the workflow:

| Step | Description |
|------|-------------|
| `checkout` | Clones the repo code |
| `setup-terraform` | Installs specified Terraform version |
| `Create credentials` | Decodes base64 secret into `gcp-key.json` and sets environment variable |
| `terraform init` | Connects to the remote GCS backend |
| `terraform plan` | Shows planned infrastructure changes |

---

## 🚯 Common errors

| Error | Reason | Solution |
|-------|--------|----------|
| 403 Forbidden | Insufficient permissions | Assign `Storage Admin` role |
| `terraform init` fails | Missing `backend.tf` | Ensure it is committed |
| Invalid base64 | Encoding issue | Properly encode with `base64` command |

---

## ✅ Done!

Now on each push to `master` or on PR:

- GitHub Actions runs Terraform
- Authenticates to GCP with service account
- Uses GCS bucket as a remote backend
- Displays `terraform plan`

---

## 🔒 Security Tips

- Never commit the raw `.json` key — only store it via base64 in Secrets
- Revoke unused keys regularly
- Use separate service accounts for `dev`, `staging`, and `prod`

---

## 📁 Repository

👉 https://github.com/absence77/gcp-terraform-devops-lab


