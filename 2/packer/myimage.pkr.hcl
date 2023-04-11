source "azure-arm" "my_vmss" {
  use_azure_cli_auth             ="true"
  image_offer                       = "UbuntuServer"
  image_publisher                   = "Canonical"
  image_sku                         = "16.04-LTS"
  location                          = "East US"
  managed_image_name                = "mycustomimgae"
  managed_image_resource_group_name = "vmmsscale"
  os_type                           = "Linux"
  vm_size                           = "Standard_DS2_v2"
}

build {
  sources = ["source.azure-arm.my_vmss"]

  provisioner "shell" {
     
    inline          = ["apt update","apt-get -y install nginx"]
     
  }

}