variable "cf_api_url" {
  type        = string
  description = "cloud.gov api url"
  default     = "https://api.fr.cloud.gov"
}

variable "cf_org_name" {
  type        = string
  description = "cloud.gov organization name"
  # default     = "hhs-acf-ohs-hses"
}

variable "cf_password" {
  type        = string
  description = "secret; cloud.gov deployer account password"
  sensitive   = true
}

variable "cf_space_name" {
  type        = string
  description = "cloud.gov space name (ct-<env>)"
  # default     = "ct-stage"
}

variable "cf_user" {
  type        = string
  description = "secret; cloud.gov deployer account user"
  sensitive   = true
}

variable "env" {
  type        = string
  description = "deployment environment in shortened form (dev, staging, prod)"
  default     = "dev"
}
