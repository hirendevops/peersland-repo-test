Create Sp FOR Azure
 az ad sp create-for-rbac   --name "sp-terraform-aks"   --role "Contributor"   --scopes /subscriptions/fb054262-2097-4672-a006-c9c5f87ed11c  --sdk-auth


Create AKS,Netowk Modules for Terraform

Create StorageAccount Maintain Bakend inazure 

terraform init
terraform plan env/prod/terraform.tfvars
terraform apply env/prod/terraform.tfvars

So Infrastucture craete


