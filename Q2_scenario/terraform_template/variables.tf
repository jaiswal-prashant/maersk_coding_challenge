

variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "subscription_id" {}

variable "location" {}
variable "vnet" {}
variable "subnet" {}
variable "image" {}
variable "webVm" {}
variable "appVm" {}

variable "adminUsername" {
    default = "azureuser"
}
variable "adminPassword" {}
variable "zones" {}
variable "nsg" {}
variable "storage_account_name" {}