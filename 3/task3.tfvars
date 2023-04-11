numberofvms = 2
resourcegroup_info = {
  location = "eastus"
  name = "task32"
}
vnet_info = {
  address_space = [ "10.0.0.0/16" ]
  name = "vnettask3"
}
subnet_info = {
  address_prefixes = [ "10.0.1.0/24" ]
  name = "sub1"
}
