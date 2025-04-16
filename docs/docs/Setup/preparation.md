---
sidebar_position: 1
---

# Preparation

The following guide is going though the required preparation steps that you will need before you first run your pipeline to deploy your selfhosted services. 

## Github

1. Go to [kickstart-selfhosted-services](https://github.com/lefterisALEX/kickstart-selfhosted-services) repository and press "Use this template" to create a new repository based on this template repository.  

![](../../static/img/use-template.png)

2. Clone the new repository to your laptop/desktop.  
3. In your newly created repository generate an [Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-fine-grained-personal-access-token) that gives access with the following permissions to your new repository only.
 - Contents (Read) -- This is required to clone your repository in your Hetzner Server.

4. Finally store the token as a [GitHub secret][1] in your repository under the name `GH_TOKEN`

## Hetzner

1. In Hetzner Console create a new project and give it a name of your choice.
2. In this project under Security upload your SSH public key. 

![](../../static/img/ssh-key.png)


![](../../static/img/upload-ssh.png)

:::info
    Naming the SSH key main will not require changes in the terraform module since is the default key which will be looked up. 
:::

3. In this project under Security -> API Tokens generate a new API token with Read & Write permissions 
Store the token as a [GitHub secret][1] in your repository under the name `HCLOUD_TOKEN`

![](../../static/img/api-key-1.png)

![](../../static/img/api-key-2.png)

## Tailscale

:::note
If you want other people to use your services is better to create a [github organization](https://docs.github.com/en/organizations/collaborating-with-groups-in-organizations/creating-a-new-organization-from-scratch), and invite those people in that organization.
:::

Login to [tailscale](https://login.tailscale.com/) using Github as Identity Provider (select then the organization if you created).  
Navigate to `Settings -> Personal Settings -> Keys` and press **Generate an auth key**.  

![](../../static/img/tailscale-auth-key.png)

In the options choose to be reusable and ephemeral.

![](../../static/img/tailscale-auth-key-2.png)

Store the token as a [GitHub secret][1] in your repository under the name `TAILSCALE_AUTH_KEY`

## AWS

:::info
AWS S3 is used as backend to store the terraform state. If you preffer a different backend please refer to  [terragrunt](https://terragrunt.gruntwork.io/docs/features/state-backend/) documentation.
You will need to modify the remote_state code in the parent `terrarunt.hcl` file. 
:::

To allow github runners to store/retrieve the state in our AWS account we do it using [OpenID Connect](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)
1. Create the three required variables in github which will be used to create an AWS S3 bucket to store the terraform state.

**AWS_ACCOUNT_ID** -> Your AWS ACCOUNT ID.  
**AWS_REGION**  -> The AWS Region you want the bucket to be created.  
**AWS_S3_BUCKET** -> The AWS S3 bucket name.  

![](../../static/img/github-set-variables.png)

2. Create an IAM Policy with the following permissions attached. 
:::info
    Do not forget to replace the Resource strings to include your bucket name from the previous step.
:::
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3:CreateBucket"
            ],
            "Resource": [
                "arn:aws:s3:::terraform-state-kickstart-demo/*", 
                "arn:aws:s3:::terraform-state-kickstart-demo*"
            ]
        }
    ]
}
```

![](../../static/img/iam-policy.png)

2. Create a new IAM Role called **github-oidc** with the following **Custom Trust Policy**.
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::123456789000:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                },
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": [
                        "repo:homelabs757/my-selfhosted-services:*"
                    ]
                }
            }
        }
    ]
}
```

:::info
    Replace the AWS Account ID in Principal with your AWS account ID and also the repository with your own repository.
:::
![](../../static/img/iam-role.png)

Press next and in the **Add Permissions** select the IAM policy you created earlier. Give a new to the IAM role and press Create.
![](../../static/img/iam-role-select-policy.png)

:::info
    Make sure the name of the role is **github-oidc** otherwise is not going to work.
::: 

![](../../static/img/aws-oidc-role.png)

3. Create a new Identity Provider of type "OpenID Connect" with the following Provider URL and Audience.  
**Provider URL:** `https://token.actions.githubusercontent.com`  
**Audience:** `sts.amazonaws.com`  

![](../../static/img/iam-provider.png)
![](../../static/img/oidc-github.png)

## Deploy 

You can deploy now the instance by running the github action.
![](../../static/img/github-deploy-2.png)

If all above steps are done properly the pipeline should be executed without issues.

![](../../static/img/action-passed.png)

If you login to tailscale you should be able to see your server be registered and connected to the tailscale network.

![](../../static/img/tailscale-connected.png)

Also in Hetzner you should be able to see the server running.

![](../../static/img/hetzner-server-runs.png)
## Infisical

There are stored all secrets related with your applications.  

1. Create a project and save the project ID as github secret with name `INFISICAL_PROJECT_ID`
![](../../static/img/infisical-project-id.png)

2. Navigate to `Admin` -> `Access Control` -> `Identities` .  
Press "Create Identity" and select as `Member` as Role
![](../../static/img/infisical-create-identity.png)

3. Press `Universal Auth` and then press `Add client secret`. Give it a name and press Create. Save the generated client secret as github secret with name `INFISICAL_CLIENT_SECRET`
![](../../static/img/infisical-universal-auth.png)
![](../../static/img/infisical-add-client-secret.png)
![](../../static/img/infisical-create-client-secret.png)

4. Copy the `Client ID` and save it as github secret with name `INFISICAL_CLIENT_ID`  
![](../../static/img/infisical-client-id.png)

Now you should have 3 new secrets stored in github related with Infisical.

![](../../static/img/github-infisical-client-secret.png)


5. Assign the new identity as Project Viewer
![](../../static/img/infisical-project-1.png)
![](../../static/img/infisical-project-2.png)


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
For containers-host:  `containers-host/terragrunt.hcl`  


[1]: https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-a-repository
