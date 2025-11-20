terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.21.0"
    }
  }

  backend "s3" {
        bucket="raj-state-testing-bucket"
        key="terraform.tfstate"
        region="ap-south-1"
        use_lockfile=true
        dynamodb_table="raj-state-table"
  }
}
