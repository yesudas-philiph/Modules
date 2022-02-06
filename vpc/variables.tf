##==========================
#variables.tf
##==========================

 variable "env" {
     default  = "Devel"
 }

variable "project" {
    default  = "core"
}

variable "vpc_cidr" {
    default  = "172.18.0.0/16"
}
