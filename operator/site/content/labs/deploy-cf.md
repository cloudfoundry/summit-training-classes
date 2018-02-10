---
date: 2018-02-06T10:21:15-03:00
title: Deploying Cloud Foundry with BOSH Lite v2
---

Your goal is to use what you learned in the previous module to deploy Cloud Foundry to an instance of BOSH Lite v2 - a scaled-down version of BOSH in which the Director uses containers to emulate VMs. You will learn how to:

- Upload releases needed for Cloud Foundry.
- Upload a stemcell
- Use a Cloud Foundry manifest to make a deployment

**NOTE:** In some training sessions you may already have a BOSH Lite v2 instance set up for you in AWS. If not, please follow the instructions below to set up BOSH Lite v2 locally, being sure to *run the optional step to add routes*:

- https://bosh.io/docs/bosh-lite

Move on when you're able to run `bosh -e [your environment name] env` successfully, which should produce output similar to the following:

```sh
  Name      Bosh Lite Director
  UUID      b1c3a0d6-cd0b-4ff9-9b6a-c80f9c34cf79
  Version   264.7.0 (00000000)
  CPI       warden_cpi
  Features  compiled_package_cache: disabled
            config_server: disabled
            dns: disabled
            snapshots: disabled
  User      admin
```

## Logging In

<!-- THIS SECTION WILL NEED TO BE REWRITTEN AFTER WE PIN DOWN AWS METHOD -->

This section covers logging in from an AWS or laptop setup.

**NOTE**

- BOSH can generate credentials for you, including when using `bosh create-env` to create a BOSH Lite v2 Director. Login instructions appeared in the [instructions from bosh.io](https://bosh.io/docs/bosh-lite).
- The rest of this lab and the successive labs assume running BOSH Lite v2 on AWS and having `SSH`ed into your AWS EC2 instance.

### BOSH Lite v2 on AWS


## Preparing for the Deployment

<!-- THIS SECTION MAY NEED CHANGES FOR AWS -->

Next we need to obtain a manifest. In this exercise we'll use the 'canonical' manifest provided by the Cloud Foundry Foundation. Among other uses, the file lists the different releases that BOSH will download when you make your deployment.

```sh
git clone https://github.com/cloudfoundry/cf-deployment ~/workspace/cf-deployment
```

Set the following environment variable to the alias you've given your Director (this saves us from having to repeat it in each of the following bosh commands):

```sh
export BOSH_ENVIRONMENT=vbox
```

Run the following command to update the cloud-config. This file is used to translate deployment manifests, which describe cloud resources in a generic way, into configuration specific to the IaaS provider where the deployment is being made.

```sh
bosh update-cloud-config ~/workspace/cf-deployment/iaas-support/bosh-lite/cloud-config.yml
```

The last step before deploying is to upload a stemcell - the base operating system for every VM in the deployment.

```sh
bosh upload-stemcell https://s3.amazonaws.com/bosh-core-stemcells/warden/bosh-stemcell-3468.21-warden-boshlite-ubuntu-trusty-go_agent.tgz
```

### Checking Your Work

```sh
  bosh stemcells
```

You should see something like this:
```sh
Name                                         Version   OS             CPI  CID
bosh-warden-boshlite-ubuntu-trusty-go_agent  3468.21*  ubuntu-trusty  -    765798f4-756f-4ba7-52d4-26e64a5bf0cc

(*) Currently deployed

1 stemcells
```

## Deploy CF

There's just one more command to set your deployment running:

```sh
bosh -d cf deploy ~/workspace/cf-deployment/cf-deployment.yml \
-o ~/workspace/cf-deployment/operations/bosh-lite.yml \
--vars-store deployment-vars.yml \
-v system_domain=bosh-lite.com
```

The process may take around two hours to complete if you're running BOSH-lite locally.

### Checking Your Work

Barring any hitches, your deployment can now be inspected by running:

```sh
  bosh deployments
```

The output should look something like this, and will include details of the numerous BOSH releases that make up a Cloud Foundry deployment:

```sh
Name  Release(s)                   Stemcell(s)                                          Team(s)  Cloud Config
cf    binary-buildpack/1.0.15      bosh-warden-boshlite-ubuntu-trusty-go_agent/3468.21  -        latest
      capi/1.48.0
      cf-mysql/36.10.0
      cf-networking/1.9.0
      cf-smoke-tests/40
      cf-syslog-drain/5.1
      cflinuxfs2/1.187.0
      consul/191
      diego/1.34.0
      dotnet-core-buildpack/2.0.1
      garden-runc/1.11.1
      go-buildpack/1.8.16
      java-buildpack/4.8
      loggregator/101.5
      nats/22
      nodejs-buildpack/1.6.15
      php-buildpack/4.3.48
      python-buildpack/1.6.7
      routing/0.171.0
      ruby-buildpack/1.7.11
      staticfile-buildpack/1.4.21
      statsd-injector/1.1.0
      uaa/54

1 deployments
```

Congratulations, you have just BOSH-deployed your first Cloud Foundry instance!

## Beyond the class

* Preparing a "real" cloud for BOSH: http://bosh.io/docs/init.html
* bosh-init - deploy BOSH director to manage a "real" cloud: http://bosh.io/docs/using-bosh-init.html
* Precompiled releases - http://bosh.io/docs/compiled-releases.html
* Try these commands

```sh
bosh help
bosh tasks
bosh tasks --recent
bosh task <id> --debug
bosh vms
```
