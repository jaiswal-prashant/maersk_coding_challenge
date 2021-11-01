location = "canadaeast"
vnet = {
    name = "azvnet"
    rgName = "vnet-rg"
    address_space = ["10.0.0.0/16"]
}

subnet = {
        webtier = {
            name = "web_sbn"
            address_prefix = ["10.0.1.0/24"]
            
        }
        apptier = {
            name = "app_sbn"
            address_prefix = ["10.0.2.0/24"]
        }
       

}

zones = ["1","2","3"]


image = {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2016-Datacenter"
        version   = "latest"
}

webVm = {
    prefix = "azwebvm"
    count = 1
    vmSize = "Standard_DS5_v2"
    rgName = "azwebtier-rg"
    disks = {
        webdisk1 = {
            size = "100"
            lun = "10"
        }
    }
    tags = {
        environment = "production"
        owner = "Prashant"
        serverType = "Web Tier" 
    }
}

appVm = {
    prefix = "azappvm"
    count = 1
    vmSize = "Standard_DS5_v2"
    rgName = "azapptier-rg"
    disks = {
        appdisk1 = {
            size = "100"
            lun = "10"
        }
    }
    tags = {
        environment = "production"
        owner = "Prashant"
        serverType = "App Tier" 
    }
}



nsg = {
    nsg1  = {
        resource_group_name = "vnet-rg"
        location = "canadaeast"
        
        security_rule = {
            Ingress_rule = {
                description                = "Ingress from internet"
                priority                   = 100
                direction                  = "Inbound"
                access                     = "Allow"
                protocol                   = "Tcp"
                source_port_range          = "*"
                destination_port_ranges    = ["80","443"]
                source_address_prefix      = "*"
                destination_address_prefix = "*"

                
            }
        }
        }
}

storage_account_name = {
    storagetfstate1 = {
        resource_group_name = "vnet-rg"
        location = "canadaeast"
        account_tier  = "Standard"
        account_kind  = "StorageV2"
        account_replication_type = "GRS"
        access_tier    = "Hot"
        enable_https_traffic_only = true
        allow_blob_public_access = false
        min_tls_version = "TLS1_2"
        delete_retention_policy = "7"
        container_delete_retention_policy = "7"
        versioning_enabled = false
        container_name = "tfstatefiles"
        container_access_type = "private"
        tags = {
        }
    }
}
