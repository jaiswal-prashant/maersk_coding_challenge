# Three tier app resource provisioning
This directory contains terraform code to provision infrastructure resources for three tier application (web,app,db). You need terraform version atleast 0.12.31


**Steps**
-  Edit environments/prod/terraform.tfvars with appropriate values.
-  Edit environments/prod/backend.hcl with appropriate values. 
- `export TF_VAR_clientId=<client_id_of_service_principal>`
- `export TF_VAR_clientSecret=<secret_of_service_principal>`
- `export TF_VAR_tenantId=<Azure_Tenant_Id>`
- `export TF_VAR_subscriptionId=<Azure_subscription_Id>`
- `export ARM_SAS_TOKEN=<SAS_token_for_backend_storage_account>`
- `terraform init --backend-config=./environments/prod/backend.hcl`
- `terraform plan --var-file=./environments/prod/terraform.tfvars`
- `terraform apply --var-file=./environments/prod/terraform.tfvars `

*This terraform code will create virtual machine spread across three availability zones* 
   

