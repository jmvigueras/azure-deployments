locals {
  #-----------------------------------------------------------------------------------------------------
  # LB variables
  #-----------------------------------------------------------------------------------------------------
  admin_password = var.admin_password == null ? random_string.admin_password.result : var.admin_password
}

