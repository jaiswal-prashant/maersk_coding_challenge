locals {
    webHosts = [ for i in range(var.webVm.count) : format("%s%d", var.webVm.prefix, i + 1) ]
    appHosts = [ for i in range(var.appVm.count) : format("%s%d", var.appVm.prefix, i + 1) ]
    
}


resource "azurerm_resource_group" "network_rg" {
  name = var.vnet.rgName
  location = var.location
}


resource "azurerm_virtual_network" "network" {
  name = var.vnet.name
  resource_group_name = var.vnet.rgName
  location = var.location
  address_space = var.vnet.address_space
}


module "web_virtual_machine" {
    source = "./modules/virtual_machine"
    hostnames = local.webHosts
    location = var.location
    vmRg = var.webVm.rgName
    vmSize = var.webVm.vmSize
    subnet = var.subnet.webtier
    vnet = azurerm_virtual_network.network.name
    zones = var.zones
    networkRg = var.vnet.rgName
    image = var.image
    disks = var.webVm.disks
    adminUsername = var.adminUsername
    adminPassword = var.adminPassword
    tags = var.webVm.tags
}


module "app_virtual_machine" {
    source = "./modules/virtual_machine"
    hostnames = local.appHosts
    location = var.location
    vmRg = var.appVm.rgName
    vmSize = var.appVm.vmSize
    subnet = var.subnet.apptier
    vnet = azurerm_virtual_network.network.name
    zones = var.zones
    networkRg = var.vnet.rgName
    image = var.image
    disks = var.appVm.disks
    adminUsername = var.adminUsername
    adminPassword = var.adminPassword
    tags = var.appVm.tags
}

module "network_security_group" {
    depends_on = [module.web_virtual_machine,module.app_virtual_machine]
    source = "./modules/nsg"
    nsg   = var.nsg
    subnet = var.subnet
    vnet   = var.vnet
  
}
