Create Sp FOR Azure
 az ad sp create-for-rbac   --name "sp-terraform-aks"   --role "Contributor"   --scopes /subscriptions/fb054262-2097-4672-a006-c9c5f87ed11c  --sdk-auth

Export All variables
export ARM_CLIENT_ID="7df98604-a244-46fc-8d26-ec341eedd054"
 export ARM_CLIENT_SECRET="x~h8Q~a8s4jQhRsGp5Izsm_Fwg7AVf4MZB-wnbZT"
 export ARM_SUBSCRIPTION_ID="fb054262-2097-4672-a006-c9c5f87ed11c"
 export ARM_TENANT_ID="aa392a45-727a-488b-8c64-6c2d88033605"

Create AKS,Netowk Modules for Terraform

Create StorageAccount Maintain Bakend inazure 

terraform init
terraform plan env/prod/terraform.tfvars
terraform apply env/prod/terraform.tfvars

So Infrastucture craete


