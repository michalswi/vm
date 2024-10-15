variable "tags" {
  description = "List of tags."
  type        = map(string)
  default     = {}
}

variable "name" {
  type    = string
  default = "mstest"
}

variable "location" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "vm_size" {
  default = "Standard_B1s"
}

variable "subnet_id" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "ip_whitelist" {
  description = "IP address allowed to ssh"
  type        = list(string)
}
