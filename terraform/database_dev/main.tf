module "database" {
  source = "../shared/database"

  cf_user       = var.cf_user
  cf_password   = var.cf_password
  cf_org_name   = var.cf_org_name
  cf_space_name = var.cf_space_name
}
