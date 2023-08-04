variable "rg_name" {
    description = "Resource Group Name"
    type = string
    default = "myrg"
}

variable "rg_location" {
    description = "Resource Group Location"
    type = string
    default = "East US"
}

variable "vnet_name" {
    description = "Virtual Netwrok Name"
    type = string
    default = "myvnet1"
}

variable "vnet_address" {
    description = "Virtual Address CIDR"
    type = list(string)
    default = [ "10.0.0.0/16" ]
}

variable "subnet_name" {
    description = "Subnet Name"
    type = string
    default = "mysubnet1"
}

variable "subnet_address" {
    description = "Subnet Address Space"
    type = list(string)
    default = [ "10.0.0.0/24" ] 
}

variable "pip_name" {
    description = "Public IP Name"
    type = string
    default = "mypip1"
}

variable "nic_name" {
    description = "Network Interface Name"
    type = string
    default = "mynic1"
}

variable "vm_name" {
    description = "Virtual Machine Name"
    type = string
    default = "myvm"
}

