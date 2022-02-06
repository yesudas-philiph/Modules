##==========================
#datasource.tf
##==========================
data "aws_availability_zones" "available_AZ" {
  state = "available"
}
