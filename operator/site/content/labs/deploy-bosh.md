---
date: 2018-02-06T10:21:15-03:00
title: Deploying BOSH Lite v2 on AWS
---

## Install the BOSH CLI

You need to [install the BOSH v2 CLI](http://bosh.io/docs/cli-v2.html#install).

## Deploying a BOSH Director

Your goal is to deploy an instance of BOSH Lite v2 - a scaled-down version of BOSH in which the Director uses containers to emulate VMs.

> **Note for AWS users:** In some training sessions you may already have a BOSH Lite v2 instance set up for you in AWS. If not, you can set one up yourself by following the instructions on this page. If your instructor has provided you with a VPC, Security Group and Elastic IP, jump to [deploying the director](#deploying-the-director).

> **Note for other users:** Provided you have a machine with [sufficient resources](../../prereqs), you can deploy a BOSH Lite Director locally by following [these instructions](https://bosh.io/docs/bosh-lite). Then skip to [checking your deployment](#checking-your-deployment) at the bottom of this page.


### AWS Setup

Before setting up our BOSH Lite v2 Director, we'll need to create some resources in AWS.

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

### Deploying the Director

Run `git clone https://github.com/cloudfoundry/bosh-deployment.git`

```sh
cd bosh-deployment
git checkout 2c1f713
```

> The specific BOSH command we're going to run has further dependencies. **Make sure you have [installed these extra dependencies](http://bosh.io/docs/cli-env-deps.html)**.

Now we're ready to deploy our BOSH Director with the following command:

> **Note:** If you created your own VPC using the instructions above then $EXTERNAL_IP is the elastic IP that you allocated.

```sh
bosh create-env bosh.yml \
  --state=state.json \
  --vars-store=creds.yml \
  -o aws/cpi.yml \
  -o bosh-lite.yml \
  -o bosh-lite-runc.yml \
  -o jumpbox-user.yml \
  -o external-ip-with-registry-not-recommended.yml \
  -v director_name=$DIRECTOR_NAME \
  -v internal_cidr=$INTERNAL_CIDR \
  -v internal_gw=$INTERNAL_GW \
  -v internal_ip=$INTERNAL_IP \
  -v access_key_id=$AWS_ACCESS_KEY_ID \
  -v secret_access_key=$AWS_SECRET_ACCESS_KEY \
  -v region=$AWS_DEFAULT_REGION \
  -v az=$AZ \
  -v default_key_name=$DEFAULT_KEY_NAME \
  -v default_security_groups=[bosh] \
  --var-file private_key=<path/to/private/key> \
  -v subnet_id=$SUBNET_ID \
  -v external_ip=$EXTERNAL_IP
  ```

Great! If that all went well, you should now have a BOSH Director. In order to access it, export the following environment variables:

```sh
export BOSH_ENVIRONMENT=$EXTERNAL_IP
export BOSH_CA_CERT="$(bosh int creds.yml --path /director_ssl/ca)"
export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET="$(bosh int creds.yml --path /admin_password)"
export BOSH_GW_HOST=$BOSH_ENVIRONMENT
export BOSH_GW_USER=vcap
export BOSH_GW_PRIVATE_KEY=<path/to/private/key>
```

### Checking your deployment

In order to continue you must be able to run `bosh env` successfully, which should produce output similar to the following:

```sh
  Name      BOSH Lite Director
  UUID      b1c3a0d6-cd0b-4ff9-9b6a-c80f9c34cf79
  Version   264.7.0 (00000000)
  CPI       warden_cpi
  Features  compiled_package_cache: disabled
            config_server: disabled
            dns: disabled
            snapshots: disabled
  User      admin
```

