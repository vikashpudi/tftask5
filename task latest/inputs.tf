 variable "enviroment" {
    type = string
    description = "(optional) describe your variable"

}
variable "null_version" {
    type = string
    description = "(optional) describe your variable"
}
 variable "resourcegroup_details" {
    type = object({
            name = string
            location = string
            })
    default = {
      location = "eastus"
      name = "ntier"
    }
}
variable "numberofvms" {
    type = number
    description = "(optional) describe your variable"
}

variable "virtual_network_details" {
    type = object ({
        name = string
        address_space = list(string)
    })
    default = {
      address_space = [ "10.10.0.0/16" ]
      name = "taskvnet"
    }
  
}
variable "subnet_details" {
    type = object ({
        name = list(string)
        address_prefixes = list(string)
    })
    default = {
      address_prefixes = [ "10.10.0.0/16" ]
      name =  ["taskvnet" ]
    }
  
}
variable "authentication_details" {
    type = object ({
       username   = string
        password = string
    })
    default = {
      password = "murali"
      username = "Devops@123456"
    }
  
}
