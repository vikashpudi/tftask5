resource "azurerm_virtual_machine" "myvms" {
    count = var.numberofvms
    name                  = "{var.enviroment}-vm-${count.index}"
   location = azurerm_resource_group.resourgegroup.location
    resource_group_name = azurerm_resource_group.resourgegroup.name 
    network_interface_ids =[var.enviroment=="dev" ? azurerm_network_interface.nicsdev[ count.index].id : azurerm_network_interface.nicsqa[count.index].id ]
    vm_size = local.vm_size
    delete_data_disks_on_termination = true
    storage_image_reference {
        publisher =local.publisher
        offer = local.offer
        sku = local.sku
        version   = local.version
    }
    storage_os_disk {
        name ="${var.enviroment}-os-${count.index}"
        caching = local.caching
        create_option = local.create_option
        os_type = local.os_type
        disk_size_gb = local.disk_size_gb
        managed_disk_type =local.managed_disk_type
    }
    os_profile {
      computer_name = "ubuntu"
      admin_username = var.authentication_details.username
      admin_password = var.authentication_details.password
    }
    os_profile_linux_config {
      disable_password_authentication = false
    }
      
}
resource "null_resource" "version" {
  count = var.enviroment == "test" ? var.numberofvms : 0
    triggers = {
      version = var.null_version
    }

  provisioner "remote-exec" {
      inline = [
                "sudo apt update",
                "curl -sL https://deb.nodesource.com/setup_16.x | sudo bash -",
                "sudo apt update",
                "sudo apt install nodejs -y",
                "sudo npm -v",
                "git clone https://github.com/gothinkster/angular-realworld-example-app.git",
                "cd angular-realworld-example-app/",
                "sudo npm install -g @angular/cli@8",
                "sudo npm install"

            ]
    } 
    connection {
      type     = "ssh"
      user     = var.authentication_details.username
      password = var.authentication_details.password
      host     = azurerm_network_interface.nicsqa[count.index].private_ip_address
      
    }

    depends_on = [
      azurerm_virtual_machine.myvms
    ]
}
resource "null_resource" "version1" {
  count = var.enviroment == "dev" ? var.numberofvms:0
    triggers = {
      version = var.null_version
    }
     
     provisioner "file" {
    source      =  "C:/Users/Murali/myapp.service"
    destination = "/home/vikash/myapp.service"
    connection {
      type     = "ssh"
      user     = var.authentication_details.username
      password = var.authentication_details.password
      host     = azurerm_public_ip.publicipdev[count.index].ip_address
      
    }
  }

  provisioner "remote-exec" {
      inline = [
        "sudo apt update",
                "curl -sL https://deb.nodesource.com/setup_16.x | sudo bash -",
                "sudo apt update",
                "sudo apt install nodejs -y",
                "sudo npm -v",
                "git clone https://github.com/gothinkster/angular-realworld-example-app.git",
                "cd angular-realworld-example-app/",
                "sudo npm install -g @angular/cli@8",
                "sudo npm install",
                "cd /home/vikash/",
                "chmod 777 myapp.service",
                "sudo -i",
                "mv /home/vikash/myapp.service /etc/systemd/system/myapp.service",
                "exit",
                "systemctl start myapp.service"

        ]
    } 
    connection {
      type     = "ssh"
      user     = var.authentication_details.username
      password = var.authentication_details.password
      host     = azurerm_public_ip.publicipdev[count.index].ip_address
       
    }
    

    depends_on = [
      azurerm_virtual_machine.myvms
    ]
}

    