resource "azurerm_resource_group" "rg" {
  name = var.vmRg
  location = var.location
}



resource "azurerm_subnet" "subnet" {
  name                 = var.subnet.name
  resource_group_name  = var.networkRg
  virtual_network_name = var.vnet
  address_prefixes     = var.subnet.address_prefix
}




resource "azurerm_network_interface" "nic" {
    for_each = toset(var.hostnames)
    name = "${each.value}-nic"
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
    ip_configuration {
        name                          = "${each.value}-ipconfig"
        subnet_id                     = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_windows_virtual_machine" "vm" {
    //for_each = toset(var.hostnames)
    for_each              = { for h in var.hostnames : h => [var.zones[index(var.hostnames, h) % length(var.zones)]] }
    name                  = each.key
    location              = var.location
    resource_group_name   = azurerm_resource_group.rg.name
    network_interface_ids = [azurerm_network_interface.nic[each.key].id]
    size               = var.vmSize
    admin_username        = var.adminUsername
    admin_password        = var.adminPassword
    source_image_reference {
       publisher = var.image.publisher
       offer = var.image.offer
       sku = var.image.sku
       version = var.image.version
    }
    #zones                 = each.value
    
    
    os_disk {
        name              = format("%s-%s",each.key,"osdisk")
        caching           = "ReadWrite"
        
        storage_account_type  = "Standard_LRS"
    }
    tags = var.tags
}



