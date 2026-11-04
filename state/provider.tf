terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.98.0"
    }
  }

 backend "s3" {
   bucket = "robostatedemo"
   key    = "remote-state-demo"
   region = "us-east-1"
   encrypt        = true
   use_lockfile = true
   /* dynamodb_table = "robostatedemo" */
 }
}

   /* we used dynamodb for locking telling to terraform */
 

provider "aws" {
  # Configuration options
}