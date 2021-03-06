variable "cf_password" {
  type        = string
  description = "secret; cloud.gov deployer account password"
  sensitive   = true
}

variable "cf_user" {
  type        = string
  description = "cloud.gov deployer account username"
}
