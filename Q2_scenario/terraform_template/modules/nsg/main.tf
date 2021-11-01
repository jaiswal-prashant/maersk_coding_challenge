resource "azurerm_network_security_group" "nsg" {
    for_each = var.nsg
    name                = each.key
    location            = each.value.location
    resource_group_name = each.value.resource_group_name
    
    
    
    dynamic "security_rule" {
        for_each = each.value.security_rule
        content {
            name = security_rule.key
            priority = security_rule.value.priority
            direction = security_rule.value.direction
            access = security_rule.value.access
            protocol = security_rule.value.protocol
            source_port_range = security_rule.value.source_port_range
            destination_port_ranges = security_rule.value.destination_port_ranges
            source_address_prefix      = security_rule.value.source_address_prefix
            destination_address_prefix = security_rule.value.destination_address_prefix

            
        }
   }
  #tags = each.value.tags
}

//data "azurerm_subnet" "subnet" {
//  for_each = var.subnet
//  name                 = each.value.name
//  virtual_network_name = var.vnet.name
//  resource_group_name  = var.vnet.rgName
//}
//
//resource "azurerm_subnet_network_security_group_association" "subnet_sg_association" {
//  for_each                  = var.nsg
//  subnet_id                 = data.azurerm_subnet.subnet[*].id
//  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
//}
