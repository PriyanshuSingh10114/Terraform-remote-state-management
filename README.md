# Terraform Remote State Management

This repository demonstrates how to configure a **remote backend** for Terraform, using an S3 bucket for state storage and a DynamoDB table for state locking, on AWS.

Terraform State Locking with Remote Backend.

## ✅ Why Use Remote State + Locking?

- Allows multiple team members to work on the same infrastructure without corrupting state.  
- Ensures the Terraform state file is stored remotely (not on local machine).  
- Enables state locking so only one Terraform operation can run at a time.  
- Achieves safer, team-friendly infrastructure as code.

## 🛠 What is Covered

- Creation of an **S3 bucket** to store Terraform state.  
- Creation of a **DynamoDB table** to manage state locks correctly.  
- Terraform `backend "s3"` configuration with `use_lockfile = true`.  
- Full example of how to structure Terraform files for remote state usage.  
- Tips to avoid common errors (e.g., correct partition key name in DynamoDB).

## 📁 Folder Structure

.
├── backend # Terraform code for backend setup (S3 + DynamoDB)
│ ├── dynamodb.tf
│ ├── s3.tf
│ └── backend.tf
├── env # Example environments (e.g., dev, prod) if needed
├── modules # Reusable Terraform modules
├── main.tf # Your main infrastructure code
├── variables.tf # Variable definitions
└── outputs.tf # Outputs from your infrastructure

markdown
Copy code

## 🔧 Setup Instructions

### 1. Create S3 Bucket for Terraform State

- Name the bucket (for example): `raj-terraform-state-bucket`  
- Region: `ap-south-1` (Mumbai)  
- Ensure public access is blocked and permissions are secure.

### 2. Create DynamoDB Table for State Locking

- Table Name: `raj-state-table`  
- Partition Key: **LockID** (type: String)  
  > ⚠️ **Important:** Exactly `LockID` (capital ‘D’), otherwise Terraform locking will fail.

### 3. Configure the Terraform Backend

In `backend.tf`, configure:

```hcl
terraform {
  backend "s3" {
    bucket       = "raj-terraform-state-bucket"
    key          = "terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    dynamodb_table = "raj-state-table"
  }
}
Run:

bash
Copy code
terraform init -reconfigure
4. Run Terraform Commands
bash
Copy code
terraform init
terraform plan
terraform apply
You should see that the state is stored remotely in S3 and locks are managed using DynamoDB.

❓ Common Errors & Fixes
Error Message	Reason	Fix
“Missing the key LockId”	DynamoDB table has wrong partition key	Delete table & recreate with key LockID
“dynamodb_table is deprecated”	Using older parameter only	Use use_lockfile = true alongside dynamodb_table
“AccessDeniedException” when creating table	Insufficient IAM permissions	Attach AmazonDynamoDBFullAccess, AmazonS3FullAccess, or custom policies

👍 Best Practices
Keep your Terraform state bucket private and versioned.

Use consistent naming conventions for buckets and tables.

Use workspaces or separate state files for different environments (dev/prod).

Restrict IAM users/roles to only the permissions they need.

Enable encryption on S3 bucket and DynamoDB table for added security.

📚 Further Reading
Terraform Backends documentation

AWS S3 Terraform backend guide

AWS DynamoDB table for Terraform state locking

Terraform State: Remote, Write, Lock

🧑‍💻 Author
This project was created by Priyanshu Singh (@PriyanshuSingh10114).
Feel free to open issues or pull requests for improvements.

