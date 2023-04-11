 variable "rgp" {
    type = string
    description = "enterrgname"
    default = "defaultrgp"
   
 }
 variable "loc" {
    type = string
    description = "location"
    default = "eastus"
   
 }
 variable "nsg" {
    type = string
    description = "yournsg name"
    default = "mynsg"
   
 }
  
 variable "vnet" {
   type = map(string)
   description = "(optional) describe your variable"
   default = {
      name = string
      address_prefix = list(string)
   }
 }

 variable "subnet1" {
   type = string
   description = "(optional) describe your variable"
 }
  variable "subnet2" {
   type = string
   description = "(optional) describe your variable"
 }
  variable "subnet3" {
   type = string
   description = "(optional) describe your variable"
 }