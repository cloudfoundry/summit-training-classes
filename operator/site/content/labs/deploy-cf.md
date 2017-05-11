---
date: 2016-05-18T10:21:15-03:00
title: Deploying Cloud Foundry to bosh-lite
---

Your goal is to use what you learned in the previous module to deploy Cloud Foundry with the Diego backend to your running bosh-lite instance. You will learn how to:

- Generate a Cloud Foundry manifest.
- Upload releases needed for Cloud Foundry.
- Upload a stemcell

**NOTE:** Formal classes may already have an AWS environment setup hosting your bosh-lite instance. If a bosh-lite instance has not been setup for you, please follow the instructions below:

- https://github.com/cloudfoundry/bosh-lite/blob/master/README.md#install-bosh-lite

## Environment Setup
There are a few things that need to be installed before we are ready to deploy.

```sh
cd ~
sudo apt-get update
sudo apt-get install git jq unzip
wget https://github.com/cloudfoundry-incubator/spiff/releases/download/v1.0.8/spiff_linux_amd64.zip
unzip spiff_linux_amd64.zip
rm spiff_linux_amd64.zip
sudo mv spiff /usr/local/bin
sudo gem install bundler
```

## Targeting and Logging In
This section covers logging from an AWS or Laptop setup.

**NOTE**

- When using bosh-lite, the default username is `admin` and password is `admin` (if needed).
- The rest of this lab and the successive labs assume running bosh-lite on AWS and having `SSHed` into your AWS EC2 instance.

### Bosh-lite on AWS
You will need the Public/Elastic IP of your bosh-lite to target bosh-lite from your laptop or to `SSH` to your AWS EC2 instance and target localhost.

```sh
  bosh target 127.0.0.1 lite
```
### Bosh-lite on Laptop

The bosh-lite default IP running on a laptop is `192.168.50.4`.  

```sh
  bosh target <your-bosh-lite-ip> lite
```

### Checking Your Work

You should see output similar to the following:

```sh
  $ bosh target 127.0.0.1 lite
  Target set to `Bosh Lite Director`
  ...
```

You should also be able to run `bosh status` and see something similar to the following:

```sh
  ...
  Name       Bosh Lite Director
  URL        https://127.0.0.1:25555
  Version    260.0.0 (00000000)
  User       admin
  UUID       f314cc48-5260-4d52-968d-bcec8f8eff0f
  CPI        warden_cpi
  dns        disabled
  compiled_package_cache disabled  # TODO: Verify with Michael. This showed enable my laptop.
  snapshots  disabled
  ...
```

## Preparing for the Deployment

In the previous module, we discussed the 3 components the bosh director needs to create a deployment: a stemcell, release and manifest.

First, we will create the manifest used to deploy CF. The CF git repository contains templates and a script useful in generating the manifest. We'll clone the repo and step through the manifest creation.

```sh
mkdir -p ~/workspace
git clone https://github.com/cloudfoundry/cf-release.git ~/workspace/cf-release
cd ~/workspace/cf-release

# The submodules need to be updated to the correct commit.
./scripts/update
```

We will be using the Diego backend within CF to run the applications. This requires modification to the manifest stubs provided in the cf-release repo. Create a file, `~/workspace/stubs/cf-diego-stub.yml`, containing the following overrides that will be used in the final manifest generation.

```sh
---
jobs:
  - name: runner_z1
    instances: 0
  - name: hm9000_z1
    instances: 0
properties:
  cc:
    default_to_diego_backend: true
```

Now we are ready to generate the manifest. This will also point BOSH to the
generated manifest.

```sh
cd ~/workspace/cf-release
sudo ./scripts/generate-bosh-lite-dev-manifest ~/workspace/stubs/cf-diego-stub.yml
```

Use the following links to upload the latest release and stemcell to BOSH.  `bosh help` can be useful to figure out how to add these to your director.

- http://bosh.io/stemcells (find the `bosh-warden-boshlite`, click on the `prev...` link)
- http://bosh.io/releases (use the `cf-release` link)

### Checking Your Work

You can use the following commands to ensure you have provided the three required inputs to the bosh director:

```sh
  bosh stemcells
```

```sh
  bosh releases
```

```sh
  bosh deployment
```

 or

```sh
  bosh status
```


## Deploy CF

Deployments in bosh are simple, given you have provided the stemcell, release and manifest to the director.


```sh
  bosh deploy
```

### Checking Your Work

If all went well, you should see `cf-warden` deployed when running:

```sh
  bosh deployments
```

If you don't have CF running at this point, please ask for help.

## Deploy Diego Backend for CF
Deploying Diego follows the same pattern as any BOSH deployment. It requires a manifest, stemcell and release(s). For a Diego deployment, the steps are similar to the CF deployment.

### Manifest Generation
```sh
git clone https://github.com/cloudfoundry/diego-release/ ~/workspace/diego-release
cd ~/workspace/diego-release
./scripts/update

./scripts/generate-bosh-lite-manifests
```

This generated a diego deployment manifest in ./bosh-lite/deployments/diego.yml. Use `bosh help` to determine the command needed to point bosh at this manifest.

### Checking Your Work

`bosh status` should list the diego.yml as the Deployment Manifest. If it doesn't, please ask for assistance.

### Deployment
Diego requires 3 releases. Use https://bosh.io/releases to upload the needed releases. Hint: Not the incubator releases.

- diego-release
- garden-runc-release
- cflinuxfs2-rootfs-release

**NOTE:** The diego deployment uses the same stemcell as the CF deployment, so there's no need to upload another stemcell.

```sh
bosh deploy
```

### Checking Your Work

If all went well, you should see `cf-warden-diego` deployed when running:

```sh
  bosh deployments
```

If you don't have Diego running at this point, please ask for help.

Congratulations!!! You have just deployed a Cloud Foundry Foundation that uses Diego as the application runtime.

## Beyond the class

* Preparing a "real" cloud for BOSH: http://bosh.io/docs/init.html
* bosh-init - deploy BOSH director to manage a "real" cloud: http://bosh.io/docs/using-bosh-init.html
* Precompiled releases - http://bosh.io/docs/compiled-releases.html
* Try these commands

```sh
bosh help
bosh tasks
bosh tasks recent
bosh tasks recent --no-filter
bosh task <id> --debug
bosh recreate <job> <index_or_id>
```
