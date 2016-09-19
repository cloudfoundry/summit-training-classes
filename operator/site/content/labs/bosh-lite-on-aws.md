---
date: 2016-09-19T14:00:15-03:00
title: Prepare AWS to deploy BOSH lite
---

This step-by-step guide shows how to configure an AWS account to deploy BOSH lite. You will learn how to:

* create a VPC and a subnet
* create a security group
* create a AWS access key
* create a AWS key pair

## Create a VPC and a subnet

Login into your AWS account and follow the instructions below.

### Choose the VPC Amazon Web Service

![cf push explained](/img/aws-setup-01-vpc-01.png)

### Start VPC Wizard

![cf push explained](/img/aws-setup-01-vpc-02.png)

### Choose "VPC with a Single Public Subnet"

![cf push explained](/img/aws-setup-01-vpc-03.png)

### Create VPC

Choose a VPC name and click on "Create VPC"

![cf push explained](/img/aws-setup-01-vpc-04.png)

### Confirm creation with "OK"

![cf push explained](/img/aws-setup-01-vpc-05.png)

### Remember the VPC ID

To install BOSH lite you'll need the VPC ID later. In this example the VPC ID is "vpc-207bec44" but it will differ for each setup.

![cf push explained](/img/aws-setup-01-vpc-06.png)

### List all Subnets

The next information that is required to install BOSH lite is the subnet ID of the subnet that was created for your VPC by the VPC wizard automatically. To find this subnet ID click on "Subnets" on the left side.

![cf push explained](/img/aws-setup-01-vpc-07.png)

### Spot the Subnet ID

To find the right subnet you can filter the subnets by the VPC. Remember the ID of the subnet because you'll need it to deploy BOSH lite.

![cf push explained](/img/aws-setup-01-vpc-08.png)


### Activate "Auto-assign Public IP"

Activate "Auto-assign Public IP" for the subnet.

![cf push explained](/img/aws-setup-01-vpc-09.png)
![cf push explained](/img/aws-setup-01-vpc-10.png)

## Create a Security Group

To create a security group click on "Security Groups" and then on "Create Security Group".

![cf push explained](/img/aws-setup-02-sec-group-01.png)
![cf push explained](/img/aws-setup-02-sec-group-02.png)

In the "Create Security Group" dialog choose the VPC ID of the VPC you created in previous steps (see screnshot below). Give your security group a name and click "Yes, Create".

![cf push explained](/img/aws-setup-02-sec-group-03.png)

Once the security group has been created select the group and click on the "Inbound Rules" tap. After that click on "Edit".

![cf push explained](/img/aws-setup-02-sec-group-04.png)

Specify the rules like in the scrennshot below and click on "Save".

**Note**: you can add additional rules by clicking on "Add another rule".

![cf push explained](/img/aws-setup-02-sec-group-05.png)

## Create a AWS Access Key

Next you have to create an Access Key that will be used to deploy BOSH lite. To do so follow the instructions in the screenshots below.

### Go to the User Management
![cf push explained](/img/aws-setup-03-access-key-01.png)
![cf push explained](/img/aws-setup-03-access-key-02.png)

### Select your own Username
**Note:** Instead of "OWolf" you must click on your AWS user name!
![cf push explained](/img/aws-setup-03-access-key-03.png)

### Create Access Key
![cf push explained](/img/aws-setup-03-access-key-04.png)

### Download Access Key
When you click on "Donwload Credentials" you will download a csv file. Save this file you need the information in there to deploy BOSH lite.
![cf push explained](/img/aws-setup-03-access-key-05.png)


## Create a Key Pair

![cf push explained](/img/aws-setup-04-key-pair-01.png)
![cf push explained](/img/aws-setup-04-key-pair-02.png)
![cf push explained](/img/aws-setup-04-key-pair-03.png)
![cf push explained](/img/aws-setup-04-key-pair-04.png)

Once you've downloaded the key pair move it to directory that you need to remember. Furthermore change the access rights of the key file. On MacOS for example you can do:

```sh
cp ~/Downloads/cfsummit-bosh-lite.pem ~/.ssh/cfsummit-bosh-lite.pem
chmod 600 ~/Downloads/cfsummit-bosh-lite.pem
```


## Start BOSH lite installation

It is assumed that vagrant and the vagrant-aws is installed.

```sh
git clone git@github.com:cloudfoundry/bosh-lite.git
cd bosh-lite
```

Ensure that the right region is used in the Vagrantfile:

```sh
grep -A 5 -B 5 region Vagrantfile

    # Following minimal config is for Vagrant 1.7 since it loads this file before downloading the box.
    # (Must not fail due to missing ENV variables because this file is loaded for all providers)
    v.access_key_id = ENV['BOSH_AWS_ACCESS_KEY_ID'] || ''
    v.secret_access_key = ENV['BOSH_AWS_SECRET_ACCESS_KEY'] || ''
    v.region = "eu-west-1"
    v.ami = ''
  end
```

Export the AWS configuration as shell variables so that vagrant can provision a virtual machine on AWS.

**Note:** You have to replace the values with the values you've obtained in the steps above.

```sh
export BOSH_LITE_NAME=cfsummit-bosh-lite
export BOSH_AWS_ACCESS_KEY_ID=[your-key-id-from-the-csv-you-have-downloaded-in-previous-steps]
export BOSH_AWS_SECRET_ACCESS_KEY=[your-key-from-the-csv-you-have-downloaded-in-previous-steps]
export BOSH_LITE_SUBNET_ID=subnet-04df6e5c
export BOSH_LITE_SECURITY_GROUP=sg-01d2cd66
export BOSH_LITE_KEYPAIR=cfsummit-bosh-lite
export BOSH_LITE_PRIVATE_KEY=~/.ssh/cfsummit-bosh-lite.pem
```

Finally you can start the BOSH lite VM on AWS:

```sh
vagrant up --provider=aws
```

This command above should result in the following output:

```sh
Bringing machine 'default' up with 'aws' provider...
==> default: Warning! The AWS provider doesn't support any of the Vagrant
==> default: high-level network configurations (`config.vm.network`). They
==> default: will be silently ignored.
==> default: Warning! You're launching this instance into a VPC without an
==> default: elastic IP. Please verify you're properly connected to a VPN so
==> default: you can access this machine, otherwise Vagrant will not be able
==> default: to SSH into it.
==> default: Launching an instance with the following settings...
==> default:  -- Type: m3.xlarge
==> default:  -- AMI: ami-bd9400ce
==> default:  -- Region: eu-west-1
==> default:  -- Keypair: cfsummit-bosh-lite
==> default:  -- Subnet ID: subnet-04df6e5c
==> default:  -- Security Groups: ["sg-01d2cd66"]
==> default:  -- Block Device Mapping: [{:DeviceName=>"/dev/sda1", "Ebs.VolumeType"=>"gp2", "Ebs.VolumeSize"=>80}]
==> default:  -- Terminate On Shutdown: false
==> default:  -- Monitoring: false
==> default:  -- EBS optimized: false
==> default:  -- Assigning a public IP address in a VPC: false
==> default: Waiting for instance to become "ready"...
==> default: Waiting for SSH to become available...
==> default: Machine is booted and ready for use!
==> default: Running provisioner: public_ip (shell)...
    default: Running: inline script
==> default: The public IP for this instance is 52.211.98.31
==> default: You can 'bosh target 52.211.98.31', or run 'vagrant ssh' and then 'bosh target 127.0.0.1'
==> default: Running provisioner: port_forwarding (shell)...
    default: Running: inline script
==> default: Setting up port forwarding for CF...
```

Now you can target the BOSH lite using the IP address from the output above (52.211.98.31 in this example, but it will be a different one in your case):

```sh
bosh target 52.211.98.31
```

To login initially use "admin" as username and "admin" as password. You can change the password like this:

```sh
bosh create user admin mynewpass
```
