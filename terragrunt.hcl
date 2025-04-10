locals {
  hcloud_token = get_env("TF_VAR_hcloud_token")
}

# generate "versions" {
#   path      = "versions.tf"
#   if_exists = "overwrite"
#   contents  = <<EOF
# terraform {
#   required_providers {
#     hcloud = {
#       source  = "hetznercloud/hcloud"
#       version = "1.49.1"
#     }
#   }
# }
# EOF
# }

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "hcloud" {
  token = "${local.hcloud_token}"
}
EOF
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket  = "terraform-state-general"
    key     = "${path_relative_to_include()}/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}

