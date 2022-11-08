variable "vpc-cidr" {
    type = string
    default = "10.10.0.0/16"

}

variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true

}

variable "project-name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "developer"

}
variable "instance-tenany" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}
variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "dnsSupport" {
    type = bool
    default = true

}
variable "dnsHostNames" {
    type = bool
    default = false

}



variable "public_subnets" {
  type = list(string)
  default = ["10.10.101.0/24","10.10.102.0/24"]

}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default = ["10.10.201.0/24","10.10.202.0/24"]
}
variable "mapPublicIP" {
    type = bool
    default = true
  
}
