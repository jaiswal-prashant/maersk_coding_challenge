variable "vmRg" {}
variable "location" {}
variable "hostnames" {}
variable "vmSize" {}
variable "subnet" {}
variable "vnet" {}
variable "networkRg" {}
variable "adminUsername" {}
variable "adminPassword" {}
variable "image" {}
variable "tags" {}
variable "zones" {}
variable "disks" {}
variable "delete_os_disk_on_termination" {
    default = true
}
variable "delete_data_disks_on_termination" {
    default = true
}