include {
  path = find_in_parent_folders()
}

locals {
  templates_path        = "/root/deployr/containers-host/templates"
  storage_box_url       = "//u399852.your-storagebox.de/backup"
  directories_to_create = ["/photos", "/backups", "/immich-cache", "/root/scripts", "/root/.config/rclone"]
  repository            = get_env("REPOSITORY")
}

terraform {
  source = "github.com/lefterisALEX/terraform-hetzner-cloudstack.git//?ref=v2.1.7"
}

dependency "infra" {
  config_path = "../infra"
  mock_outputs = {
    private_network_id = "12345578"
  }
}

inputs = {
  # Name of the server
  name = "cloudstack"

  # Operating System to Use. Supports only Ubuntu at the moment
  image = "ubuntu-24.04"

  # Type of the server to deploy. Options https://www.hetzner.com/cloud/
  server_type = "cax21"

  # Location of the resources. Options https://docs.hetzner.com/cloud/general/locations/#what-locations-are-there
  region = "nbg1"

  # The size of the attached volume where containers persistent data are stored.
  volume_size = 10

  # The Hetzner private network ID. 
  hcloud_network_id = dependency.infra.outputs.private_network_id

  # The private IP of the VPS. Need to be inside the CIDR of the private subnet.
  server_ip = "192.168.156.100"

  # Setting this to true will disable the firewall. highly recommend to keep it false.
  public_access = false

  # Protect the attach volume from accidental deletion. Set it to false only if you plan to completely destroy resources and do not mind loose your container persistent data.
  volume_delete_protection = true

  # Set to false if you do not want to manage your secrets with infisical.
  enable_infisical = true

  # The API of the infisical server. If you want to use US datacenter you can comment it out or set it to https://app.infisical.com 
  infisical_api_url = "https://app.infisical.com"

  # Your infisical project ID, value if retrieved from the Github secret `INFISICAL_PROJECT_ID`
  infisical_project_id = get_env("INFISICAL_PROJECT_ID")

  # The infisical client ID, value if retrieved from Github secret `INFISICAL_CLIENT_ID`
  infisical_client_id = get_env("INFISICAL_CLIENT_ID")

  # The infisicak client secret, value is retrieved from Github secret `INFISICAL_CLIENT_SECRET` 
  infisical_client_secret = get_env("INFISICAL_CLIENT_SECRET")

  # The tailscale authentication key, value is retrieved from the Github Secret `TAILSCALE_AUTH_KEY`
  tailscale_auth_key = get_env("TAILSCALE_AUTH_KEY")

  # A list of routes that are advertised inside your tailscale network.
  tailscale_routes = "192.168.156.0/24,172.29.0.0/16"

  # Your github token which is needed to create the Github Runner and clone your private repository. 
  github_token = get_env("GH_TOKEN")

  # Your github repository URL where docker compose files are.
  github_repo_url="https://github.com/${local.repository}"

  # The relative path in your repository where the parent docker-compose.yaml file is.
  docker_compose_path = "containers-host/apps"

  # Timezone which will be configured in your VPS.
  timezone = "Europe/Amsterdam"

  # A list of SSH key names from your pre-deployed in your hetzner project. You can use them to connect later to the VPS.
  ssh_keys = ["main"]

  # Custom userdata script to run during server initialization. 
  custom_userdata = [
  ]
}

