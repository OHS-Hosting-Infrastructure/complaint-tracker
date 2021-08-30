module "database" {
  source = "../shared/database"

  cf_user          = var.cf_user
  cf_password      = var.cf_password
  cf_space_name    = "ct-stage"
  env              = "stage"
  recursive_delete = true
}
