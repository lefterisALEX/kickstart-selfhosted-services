---
sidebar_position: 1
---

# Preparation

## Github

Create a new repository based on this template repository and generate an [Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-fine-grained-personal-access-token) that gives access with the following permissions to your new repository only.
 - Administration (Read & Write) -- This is required for the Github Runners
 - Contents (Read) -- This is required to clone your repository in your Hetzner Server.

Store the token as [github secret](https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-a-repository) in your repository with name `GH_TOKEN`, so can be used when pipeline is executed.  


:::note

In later steps you will need to save more secrets in your Github, you need to follow same procedure
::: 

## Hetzner

In Hetzner Console create a new project and generate a new API token under Security -> API Tokens
Save this token as `HCLOUD_TOKEN` in Github Secrets.

Additionally in hetzner console upload your SSH public key under Security -> SSH Keys

## Tailscale

If you want other people to use your services is better to create a [github organization](https://docs.github.com/en/organizations/collaborating-with-groups-in-organizations/creating-a-new-organization-from-scratch), and invite those people in that organization.

Login to https://login.tailscale.com/ using Github as Identity Provider (select then the organization if you created).  
Navigate to `Settings -> Personal Settings -> Keys` and press **Generate an auth key*.  
In the options choose to be reusable and ephemeral.
Save the generated key as github secret in your repository with name `TAILSCALE_AUTH_KEY`.


## AWS

To allow CICD to save the state in our AWS account we can do it using [OpenID Connect](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)

Need to set also AWS_REGIOn adnAWS_ACCOUNT_ID in variables in github


## Infisical

There are stored all secrets related with your applications.  

1. Create a project and save the project ID as github secret with name `INFISICAL_PROJECT_ID`
2. Admin -> Access Control -> Identities (create a new Identity )
3. Assign the new identity as Project Viewer
4. Press Universal Auth and then press Add a client secret then. Save the generated client secret as github secret with name `INFISICAL_CLIENT_SECRET`
5. Copy the client ID and save it as github secret with name `INFISICAL_CLIENT_ID` 



## Cloudflare

You will need to have a domain (or subdomain) with an A record pointing to your Private IP of your hetzner server.
Additionally LetsEncrypt is managing the rotation of the TLS certificate , using DNS challenge. 
for that you will need to create an API token with the following permissions for your zone.
1. Got to Profile -> API Tokens -> Create Token > Create Custom Token
2. Add Permissions Zone -> Zone -> Read & Zone -> DNS -> Edit . Then select specific zone  and select your domain and press Continiu to Summary. 
3. Take the generated API token and place it in infisical in a new directlry called traefik. The secret name should be `CF_DNS_API_TOKEN` and the value the token that was generated in cloudflare.

## Configuration Options
All configuration options for each module are available in the `terragrunt.hcl` file of each module.  
Explanations of the options are provided as comments above the options.  
For infrastructure:  `infra/terragrunt.hcl`  
For container-host:  `container-host/terragrunt.hcl`  

