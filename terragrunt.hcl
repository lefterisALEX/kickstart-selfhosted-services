locals {
  hcloud_token  = get_env("TF_VAR_hcloud_token")
  aws_s3_bucket = get_env("TF_VAR_aws_s3_bucket") 
}

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
    bucket  = "${local.aws_s3_bucket}"
    key     = "${path_relative_to_include()}/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}

