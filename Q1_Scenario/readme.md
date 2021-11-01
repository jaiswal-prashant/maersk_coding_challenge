#Q1 - SCENARIO

A car rental company called FastCarz has a .net Web Application and Web API which are recently
migrated from on-premise system to Azure cloud using Azure Web App Service
and Web API Service.
The on-premises system had 3 environments Dev, QA and Prod.
The code repository was maintained in TFS and moved to Azure GIT now. The TFS has daily builds which
triggers every night which build the solution and copy the build package to drop folder.
deployments were done to the respective environment manually. The customer is planning to setup
Azure DevOps Pipeline service for below requirements:

1) The build should trigger as soon as anyone in the dev team checks in code to master branch.
2) There will be test projects which will create and maintained in the solution along the Web and API.
The trigger should build all the 3 projects - Web, API and test.
 The build should not be successful if any test fails.
3) The deployment of code and artifacts should be automated to Dev environment.
4) Upon successful deployment to the Dev environment, deployment should be easily promoted to QA
and Prod through automated process.
5) The deployments to QA and Prod should be enabled with Approvals from approvers only.
Explain how each of the above the requirements will be met using Azure DevOps configuration.
Explain the steps with configuration details.

#Solution

We need to Create a project form in Azure devops, then in the pipeline section below are steps need to be performed.
    . standard CI build pipline 
          . Get sources (githib repo details like link,branch name,)
          . run on agent(choose an agent in order to exceute on some node) 
          . Copy files (Copy Files to: $(build.artifactstagingdirectory)/Terraform to target folder - $(build.artifactstagingdirectory)/Terraform , here run this task when previous job have been succeded)
          . Publish Artifcats.
          . CI pipeline is ready and can be executed or can be configured to automatically trigged when and pull request is merged to github.

          
    . Release Pipeline
          

        Create a Release pipeline. This should have above CI pipeline stage as artifacts and then terraform init/plan/apply stage. This need to run on some agent hence we have to select various tasks to be added to job like 1. Terraform Installer (terraform verison and other details) 2. Command line - (to run terraform init -backend-config=../environments/backend.hcl -no-color terraform plan -var-file=../environments/terraform.tfvars -out ../plan_output -no-color) 3. Agentless job 4 Manual Intervention 5. Repeat 1,2 steps (but in command line we need to run terraform apply now terraform init -backend-config=../environments/backend.hcl -no-color terraform apply -auto-approve -var-file=../environments/terraform.tfvars -no-color) 

        We need to repeat these steps thrice for Dev/QA/Prod