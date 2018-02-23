---
date: 2018-02-06T10:21:15-03:00
title: Deploying Cloud Foundry with BOSH Lite v2
---

## Preparing to Deploy Cloud Foundry

**Note:** - This guide requires you to be logged in to your Director, and the rest of the instructions assume you have already done so.

Next we need to obtain a manifest. In this exercise we'll use the 'canonical' manifest provided by the Cloud Foundry Foundation. Among other uses, the file lists the different releases that BOSH will download when you make your deployment.

```sh
git clone https://github.com/cloudfoundry/cf-deployment ~/workspace/cf-deployment

cd ~/workspace/cf-deployment
git checkout tags/v1.15.0
```

Check to see if you've already set `$BOSH_ENVIRONMENT`:

```
echo $BOSH_ENVIRONMENT
```

If you see an empty output, set the `BOSH_ENVIRONMENT` environment variable to your Director's external IP. Your Director IP will be 192.168.50.6 if you followed the guide to run BOSH Lite v2 locally:

```sh
export BOSH_ENVIRONMENT=<your environment IP/name>
```

Run the following command to update the cloud-config. This file is used to translate deployment manifests, which describe cloud resources in a generic way, into configuration specific to the IaaS provider where the deployment is being made.

```sh
bosh update-cloud-config ~/workspace/cf-deployment/iaas-support/bosh-lite/cloud-config.yml
```

The last step before deploying is to upload a stemcell - the base operating system for every VM in the deployment. You need to ensure you upload a stemcell that matches the version expected by the manifest `cf-deployment.yml`, which we can achieve by pulling the value out of the file:

```sh
export STEMCELL_VERSION=$(bosh int cf-deployment.yml --path '/stemcells/alias=default/version')

bosh upload-stemcell "https://bosh.io/d/stemcells/bosh-warden-boshlite-ubuntu-trusty-go_agent?v=$STEMCELL_VERSION"
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

If have you deployed BOSH Lite v2 locally, set `$SYSTEM_DOMAIN` to bosh-lite.com. If you deployed BOSH Lite v2 to AWS, use `$BOSH_ENVIRONMENT.sslip.io`

There's just one more command to set your deployment running:

```sh
bosh -d cf deploy ~/workspace/cf-deployment/cf-deployment.yml \
-o ~/workspace/cf-deployment/operations/bosh-lite.yml \
-o ~/workspace/cf-deployment/operations/use-compiled-releases.yml \
--vars-store deployment-vars.yml \
-v system_domain=$SYSTEM_DOMAIN
```

> **Note:** This deployment will take a while (~20-30 minutes). However there will be a confirmation prompt near the beginning so keep an eye on your screen.

In our example, `cf` is the name we're choosing to give the deployment. `cf-deployment.yml` is our Cloud Foundry deployment manifest, while `bosh-lite.yml` and `use-compiled-releases.yml` are 'operations' files which make changes to that manifest. The 'vars-store' flag specifies where we want BOSH to generate a file containing credentials for our deployment. Lastly, 'system domain' will be used as the root domain for your deployment.

### Checking Your Work

You can view a list of your deployments by running:

```sh
  bosh deployments
```

Barring any hitches, the output should look something like this, and will include details of the many BOSH releases that make up a Cloud Foundry deployment:

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

## Checking your manifest

After you've made a deployment, it can sometimes be useful to be able to check the exact version of the manifest BOSH used when standing it up. You could check the copy of the manifest you have locally (in our case, `cf-deployment.yml`), but it's likely that in this version a number of variables will be undefined. For example:

```
- name: blobstore
    release: capi
    properties:
      system_domain: "((system_domain))"
```

If instead you run `bosh manifest -d <deployment-name>`, you'll see the complete manifest:

```
- name: blobstore
    release: capi
    properties:
      system_domain: bosh-lite.com
```


## Beyond the class

* Read up on preparing an IaaS for BOSH: http://bosh.io/docs/init.html
* [BOSH Bootloader](https://github.com/cloudfoundry/bosh-bootloader) - CLI tool to pave an IaaS and deploy a BOSH Director
* Understand precompiled releases - http://bosh.io/docs/compiled-releases.html
* Try these commands:

```sh
bosh help
bosh tasks
bosh tasks --recent
bosh task <id> --debug
bosh vms
```
