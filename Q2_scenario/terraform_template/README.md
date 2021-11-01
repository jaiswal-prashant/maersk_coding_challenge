Macro Life, a healthcare company has recently setup the entire Network and Infrastructure on Azure.
The infrastructure has different components such as Virtual N/W, Subnets, NIC, IPs, NSG etc.
The IT team currently has developed PowerShell scripts to deploy each component where all the
properties of each resource is set using PowerShell commands.
The business has realized that the PowerShell scripts are growing over period of time and difficult to
handover when new admin onboards in the IT.
The IT team has now decided to move to Terraform based deployment of all resources to Azure.
All the passwords are stored in a Azure Service known as key Vault. The deployments needs to be
automated using Azure DevOps using IaC(Infrastructure as Code).

==========================================================================================
1) What are different artifacts you need to create - name of the artifacts and its purpose

- Assuming the pipeline we are running from AzureDevOps from a project already created below are the steps needed 
    . Created a CI Pipeline using Classic Editor we need to select the repo source of the code i.e. Github 
    . Select "Run Agent ON " which will have couple of task 
            - " Copy Files to: $(build.artifactstagingdirectory)/<directorName>" , fill in the values it copy files to workspace or the VM.
            -  Publish Artifact: drop , fill in the values, it will upload the genrated artifacts in folder of the vm.
- CI pipeline is ready and can be executed or can be configured to automatically trigged when and pull request is merged to github.

- Create a Release pipeline. This should have above CI pipeline stage as artifacts and then terraform init/plan/apply stage. This need to run on some agent hence  we have to select various tasks to be added to job like 
                1. Terraform Installer (terraform verison and other details)
                2. Command line - (to run terraform init -backend-config=../environments/backend.hcl -no-color
                                terraform plan -var-file=../environments/terraform.tfvars -out ../plan_output -no-color)
                3. Agentless job
                4 Manual Intervention
                5. Repeat 1,2 steps (but in command line we need to run terraform apply now
                                    terraform init -backend-config=../environments/backend.hcl -no-color
                                    terraform apply -auto-approve -var-file=../environments/terraform.tfvars -no-color) 

=================================================================================================================

2) List the tools you will to create and store the Terraform templates.

-   Terraform installler version >0.12.31 or = 0.13
-   github to store source code
-   azure account
-   Service principal details (tenant_id, client_id, client secret, subscription id, ARM_SAS_TOKEN)

================================================================================================================

3) Explain the process and steps to create automated deployment pipeline.
 - Explained in 1st step above.

==========================================================================================

4) Create a sample Terraform template you will use to deploy Below services:
 Vnet
 2 Subnet
 NSG to open port 80 and 443
 1 Window VM in each subnet
 1 Storage account

# Terraform teamplate to create various resources in Azure
This directory contains terraform code to provision infrastructure resources for the company. This includes vnet, 2 subnet, nsg (to open port on 80,443 ), storage account & windows VM. You need terraform version atleast 0.13


**Steps**
-  Edit environments/prod/terraform.tfvars with appropriate values.
-  Edit environments/prod/backend.hcl with appropriate values. 
- `export TF_VAR_client_id=<client_id_of_service_principal>`
- `export TF_VAR_client_secret=<secret_of_service_principal>`
- `export TF_VAR_tenant_id=<Azure_Tenant_Id>`
- `export TF_VAR_subscription_id=<Azure_subscription_Id>`
- `export ARM_SAS_TOKEN=<SAS_token_for_backend_storage_account>`

Execute below commands. 

- `terraform init --backend-config=./environments/prod/backend.hcl`

- `terraform plan --var-file=./environments/prod/terraform.tfvars`

- `terraform apply --var-file=./environments/prod/terraform.tfvars `

*This terraform code will create below resources 

-  a virtual network
-  2 subnets
-  nsg [ opens 80 & 443 port ]
-  virtual machine in each subnet
-  storage account 
   
   Note - In order to store tfstate information in bucket we can put values in backend.hcl and enable provider.tf.
============================================================================================================

5) Explain how will you access the password stored in Key Vault and use it as Admin Password in the VM
Terraform template.

 It can be achieve by creating keyvault & keyvault secret vai terraform or via portal. And then using the keyvault metadata which will fetch te secret password as admin password which VM creation. Below resources are supported by terraform .

 - azurerm_key_vault                       ----> Key Vault creation
 - azurerm_key_vault_secret                ----> Key vault secret creation and store
 the value fetched from azurerm_key_vault_secret can be passed in admin_password while creating "azurerm_windows_virtual_machine" will serve the purpose.



