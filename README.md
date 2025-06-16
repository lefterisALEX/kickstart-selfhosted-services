# kickstart-selfhosted-services

This repository serves as a template for deploying self-hosted services on a Virtual Private Server (VPS) using Terraform and Docker Compose, by leveraging the [Terraform Hetzner Self-Hosted Services Host](https://github.com/lefterisALEX/terraform-hetzner-selfhosted-services-host) module.

## Features
**Automated Deployment**: Automatically deploy your applications using Docker Compose.
GitOps Style Updates: Any updates to your applications will trigger an automated pull of the new commit and apply the updated Docker Compose configuration.
Easy Configuration: Simple setup process with clear documentation.

## Prerequisites
To complete the setup you will need to have an account with the following providers:

1. Hetzner Cloud account : Is used to deploy the Virtual Private Server inside a Virtual Private Network.
2. Tailscale : is used as VPN between your devices and the Hetzner Private Network.
3. Amazon Web Services : is used to save the terraform state.
4. Cloudflare : is used for DNS configuration.
5. Infisical : is used for external secret management.


## Getting Started
To get started you can follow the instruction in the [documentation page](https://lefterisalex.github.io/kickstart-selfhosted-pages/)


## Contributing
Contributions are welcome! If you have suggestions for improvements or find any issues, please open an issue or submit a pull request.

