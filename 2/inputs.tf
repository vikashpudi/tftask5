variable "group_info" {
  type        = string
  default     = "defaultresourcegroup"
  description = "(optional) describe your variable"
}
variable "location_info" {
  type =  string
  default = "eastus"

}
variable "vnet_info" {
  type = object({
    name          = string
    address_space = list(string)
  })
  default = {
    address_space = ["10.0.0.1/16"]
    name          = "myvnetfromtf"
  }
}
variable "vmss_name" {
    type = object({
        name = string
        username = string
        numberofinstance = number
    })
}
     
 
