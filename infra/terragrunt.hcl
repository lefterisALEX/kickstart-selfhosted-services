include {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/lefterisALEX/terraform-hetzner-private-network-with-nat-gateway.git//?ref=v0.1.0"
}

inputs = {
  # List of SSH keys to be used for accessing the instance. Those need to be pre-provisioned.
  ssh_keys = ["main"]

  # CIDR block for the private subnet
  private_subnet = "192.168.156.0/24"

  # Name of the network
  network_name = "private"

  # Flag to deploy a NAT gateway, is not needed since this instance has access to internet.
  deploy_nat_gateway = false

  # Location of the resources. Options https://docs.hetzner.com/cloud/general/locations/#what-locations-are-there
  location = "nbg1"

  # Network zone for the resources. Options https://docs.hetzner.com/cloud/general/locations/#what-locations-are-there
  network_zone = "eu-central"
}

