# Symplique Manage Azure Billing

Automate Azure billing record management with Terraform and Azure Functions. Provision Cosmos DB, Blob Storage, Key Vault, and deploy Python-based Azure Functions for archiving and retrieving billing records.

---

## 🚀 Project Structure

```
workflows/                # CI/CD pipeline for Terraform deployment
terraform/
    env/                    # Environment configs (int, prod)
    function_src/           # Azure Function source code
        archive_billing_records/  # Timer-triggered archival function
        get_billing_record/       # HTTP-triggered retrieval function
    module/                 # Reusable Terraform modules

📦.github
 ┗ 📂workflows
 ┃ ┗ 📜build.yaml
 📦terraform
 ┣ 📂env
 ┃ ┣ 📂int
 ┃ ┃ ┣ 📜backend.tf
 ┃ ┃ ┗ 📜main.tf
 ┃ ┗ 📂prod
 ┃ ┃ ┣ 📜backend.tf
 ┃ ┃ ┗ 📜main.tf
 ┣ 📂function_src
 ┃ ┣ 📂archive_billing_records
 ┃ ┃ ┣ 📜__init__.py
 ┃ ┃ ┗ 📜function.json
 ┃ ┣ 📂get_billing_record
 ┃ ┃ ┣ 📜__init__.py
 ┃ ┃ ┗ 📜function.json
 ┃ ┗ 📜host.json
 ┗ 📂module
 ┃ ┣ 📂blobstorage
 ┃ ┃ ┣ 📜main.tf
 ┃ ┃ ┗ 📜variables.tf
 ┃ ┣ 📂cosmosdb
 ┃ ┃ ┣ 📜main.tf
 ┃ ┃ ┗ 📜variables.tf
 ┃ ┣ 📂functions
 ┃ ┃ ┣ 📜main.tf
 ┃ ┃ ┗ 📜variables.tf
 ┃ ┗ 📂keyvault
 ┃ ┃ ┣ 📜main.tf
 ┃ ┃ ┗ 📜variables.tf
```

---

## ✨ Features

- **Automated Infrastructure:** Deploy Cosmos DB, Blob Storage, Key Vault, and Function App
- **Archival Logic:** Move old billing records from Cosmos DB to Blob Storage
- **Record Retrieval:** Fetch records via HTTP API from Cosmos DB or Blob Storage
- **CI/CD:** GitHub Actions workflow for Terraform plan/apply and function packaging

---

## 🛠️ Getting Started

### Prerequisites

- [Terraform](https://www.terraform.io/)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Python 3.9 (for Azure Functions)

### Setup

1. **Clone the repository**
        ```sh
        git clone <repo-url>
        cd Symplique-ManageAzureBilling
        ```

2. **Configure environment variables**
        - Set Azure credentials in GitHub secrets for CI/CD
        - Update `terraform.tfvars` in `env/int` and `env/prod` with required values

3. **Deploy Infrastructure**
        ```sh
        cd terraform/env/int
        terraform init
        terraform plan -var-file=terraform.tfvars
        terraform apply -var-file=terraform.tfvars
        ```

4. **Package Azure Functions**
        - Functions are zipped and deployed via CI/CD
        - Manual packaging:
                ```sh
                cd terraform/function_src
                pip install -r requirements.txt -t .python_packages/lib/site-packages
                zip -r ../function.zip .
                ```

---

## ⚡ Azure Functions

- **Archive Billing Records:** Timer-triggered, archives records older than threshold days from Cosmos DB to Blob Storage
- **Get Billing Record:** HTTP-triggered, retrieves a billing record by ID from Cosmos DB or Blob Storage

---

## 🧩 Customization

- Adjust `threshold_days` in Terraform variables for archival logic
- Update Cosmos DB, Blob Storage, and Key Vault names per environment in `main.tf`

---

## 🔄 CI/CD

- Automated deployment steps in [`build.yaml`](workflows/build.yaml)

---

## 📄 License

MIT License

---

> For details on modules and functions, see:
> - [`main.tf`](terraform/env/int/main.tf)
> - [`__init__.py`](terraform/function_src/archive_billing_records/__init__.py)
> - [`__init__.py`](terraform/function_src/get_billing_record/__init__.py)

This project automates Azure billing record management using Terraform and Azure Functions. It provisions resources for Cosmos DB, Blob Storage, Key Vault, and deploys Python-based Azure Functions for archiving and retrieving billing records.

Project Structure
workflows: CI/CD pipeline for Terraform deployment.
terraform
env/: Environment-specific Terraform configs (int, prod).
function_src/: Azure Function source code.
archive_billing_records/: Timer-triggered function to archive old records.
get_billing_record/: HTTP-triggered function to retrieve records.
module/: Reusable Terraform modules for Azure resources.
Features
Automated Infrastructure: Deploys Cosmos DB, Blob Storage, Key Vault, and Function App.
Archival Logic: Moves old billing records from Cosmos DB to Blob Storage.
Record Retrieval: Fetches records from Cosmos DB or Blob Storage via HTTP API.
CI/CD: GitHub Actions workflow for Terraform plan/apply and function packaging.
Getting Started
Prerequisites
Terraform
Azure CLI
Python 3.9 (for Azure Functions)
Setup
Clone the repository


git clone <repo-url>cd Symplique-ManageAzureBilling
Configure environment variables

Set Azure credentials in GitHub secrets for CI/CD.
Update terraform.tfvars in int and prod with required values.
Deploy Infrastructure


cd terraform/env/intterraform initterraform plan -var-file=terraform.tfvarsterraform apply -var-file=terraform.tfvars
Azure Functions Packaging

Functions are zipped and deployed via the CI/CD pipeline.
Manual packaging:

cd terraform/function_srcpip install -r requirements.txt -t .python_packages/lib/site-packageszip -r ../function.zip .
Azure Functions
Archive Billing Records
Timer-triggered, archives records older than threshold days from Cosmos DB to Blob Storage.

Get Billing Record
HTTP-triggered, retrieves a billing record by ID from Cosmos DB or Blob Storage.

Customization
Adjust threshold_days in Terraform variables for archival logic.
Update Cosmos DB, Blob Storage, and Key Vault names per environment in main.tf and main.tf.
CI/CD
See build.yaml for automated deployment steps.
License
MIT License

For details on modules and functions, see:

main.tf
__init__.py
__init__.py
