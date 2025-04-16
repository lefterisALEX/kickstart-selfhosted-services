---
sidebar_position: 1
---

# Introduction

A fully automated (and opiniated) way to deploy and manage your selfhosted services in Hetzner using Docker Compose and Terraform.  
This setup might be suitable for people that they:
 - want to deploy their self hosted services in a VPS accessible via VPN and not in a home server.
 - want to use the selfhosted services hobby as a way to learn IAC terraform/terragrunt 

This project demonstates a way to use the cloudstack terraform module in order to deploy your selfhosted services.
After applying the code you will get a an instance in hetzner where it clones your code from a GitHub repository, manages secrets using Infisical, and utilizes Docker Compose for deploying your applications.
The setup ensures that applications are kept up-to-date with the latest code change:w
s from your upstream repository.

![Example banner](../static/img/architecture.svg)
## Required Services 

The whole setup is using various services , below a list of those services and what is used for.
 1. **Hetzner** is used to deploy the Virtual Private Server inside a Virtual Private Network. (Required)
 2. **AWS S3** is used to save the terraform state. (Required)
 3. Tailscale is used as VPN between your devices and the Hetzner Private Network.
 4. **Github** is used to deploy emphemeral runner inside your Hetzner Private Network, but also used  as Identity Provider to login to tailscale.
 6. **Traefik** is used for reverse proxy.
 7. **LetsEncrypt** is used for Automatic Certificate Renewal. 
 5. **Cloudflare** is used for DNS configuration.

