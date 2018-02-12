---
date: 2016-09-19T14:00:15-03:00
title: Prepare AWS to deploy BOSH lite
---

This step-by-step guide shows how to configure an AWS account to deploy BOSH lite.

Before our BOSH Director, we'll need to create some resources in AWS.

**VPC**

1. Let's start with a VPC. Open the AWS Console, and select `VPC`. On the next screen, click `Start VPC Wizard`. Complete the VPC form with the following information:

| Field                | Value                           |
|----------------------|---------------------------------|
| IP CIDR block        | 10.0.0.0/16                     |
| VPC name             | bosh                            |
| Public subnet        | 10.0.0.0/24                     |
| Availability Zone    | *choose a zone for your region* |
| Subnet name          | public                          |
| Enable DNS hostnames | Yes                             |
| Hardware tenancy     | Default                         |

Click Create VPC and click OK once VPC is successfully created.

1. Click Subnets and locate the 'public' subnet in the VPC. Make a note of the `Subnet ID` and `Availability zone`, which you will use later.

1. On the VPC Dashboard, click Elastic IPs and click Allocate New Address.
In the Allocate Address dialog box, click Yes, Allocate.
Note down the IP, which will be used later to access your Director.

1. In the AWS Console, select EC2 to get to the EC2 Dashboard.
Click Key Pairs and click Create Key Pair. In the Create Key Pair dialog box, enter “bosh” as the Key Pair name and click `Create`. Save the private key locally, and change its permissions as follows:
`chmod 400 <path to private key>`

1. On the EC2 Dashboard, click Security Groups and then click `Create Security Group`. Complete the Create Security Group form with the following information:

| Field               | Value                                     |
|---------------------|-------------------------------------------|
| Security group name | bosh                                      |
| Description         | BOSH deployed VMs                         |
| VPC                 | *select the bosh VPC you created earlier* |

Click `Create`. Now we need to add some rules to this security group. With the security group selected, click the 'Inbound' tab and press `edit`

Fill in the following inbound rules:

| Type            | Port Range | Source                      |
|-----------------|------------|-----------------------------|
| SSH             | 22         | *my IP*                     |
| Custom TCP Rule | 6868       | *my IP*                     |
| Custom TCP Rule | 25555      | *my IP*                     |
| All Traffic     | All        | *id of your security group* |

Run `git clone git@github.com:cloudfoundry/bosh-deployment.git`

`cd bosh-deployment`

Now we're ready to deploy our BOSH Director with the following command:

```sh
bosh create-env bosh.yml \
  --state=state.json \
  --vars-store=creds.yml \
  -o aws/cpi.yml \
  -o bosh-lite.yml \
  -o bosh-lite-runc.yml \
  -o jumpbox-user.yml \
  -o external-ip-with-registry-not-recommended.yml \
  -v director_name=bosh-1 \
  -v internal_cidr=10.0.0.0/24 \
  -v internal_gw=10.0.0.1 \
  -v internal_ip=10.0.0.6 \
  -v access_key_id=$AWS_ACCESS_KEY_ID \
  -v secret_access_key=$AWS_SECRET_ACCESS_KEY \
  -v region=$AWS_DEFAULT_REGION \
  -v az=$the_availability_zone_of_your_subnet \
  -v default_key_name=bosh \
  -v 'default_security_groups=[bosh]' \
  --var-file private_key=$path_to_the_private_key_you_downloaded_earlier \
  -v subnet_id=$your_subnet_id \
  -v external_ip=$the_elastic_ip_you_created_earlier
  ```

Great! If that all went well, you should now have a BOSH Director. In order to access it, export the following environment variables:

```sh
export BOSH_ENVIRONMENT=$the_elastic_ip_you_created_earlier
export BOSH_CA_CERT="$(bosh int creds.yml --path /director_ssl/ca)"
export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET="$(bosh int creds.yml --path /admin_password)"
export BOSH_GW_HOST=$BOSH_ENVIRONMENT
export BOSH_GW_USER=jumpbox
export BOSH_GW_PRIVATE_KEY=$path_to_the_private_key_you_downloaded_earlier
```

To verify that worked, run `bosh env`. You should see output like this:

```sh
Using environment ‘34.235.181.111’ as client ‘admin’

Name      bosh-1
UUID      e1944296-f3ef-4d64-a11e-a4e45b50ad80
Version   264.7.0 (00000000)
CPI       warden_cpi
Features  compiled_package_cache: disabled
          config_server: disabled
          dns: disabled
          snapshots: disabled
User      admin

Succeeded
```
