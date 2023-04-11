resourcegroup_details = {
    name="ntier_rg" 
    location="eastus"
}

vnet_details = {
  address_space = [ "172.16.0.0/16" ]
  name = "ntier_vnet"
}

subnet_details = {
  names = [ "web", "app", "cache", "mgmt","ad","db" , "sub1" , "sub2", "sub3" ]
}

runningversion = "1.2"