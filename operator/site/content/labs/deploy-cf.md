---
date: 2016-05-18T10:21:15-03:00
title: Deploying Cloud Foundry to bosh-lite
---

- cf-release: https://github.com/cloudfoundry/cf-release
- Stemcell: https://s3.amazonaws.com/bosh-warden-stemcells/bosh-stemcell-3147-warden-boshlite-ubuntu-trusty-go_agent.tgz
- Manifest: You are going to create your own!


Your goal is to use what you learned in the previous module to deploy Cloud Foundry to your running bosh-lite instance.
## Targeting and Logging In

You first need to target your bosh director.  If you are using bosh-lite on your laptop, the default IP is 192.168.50.4.  If you are using bosh-lite on AWS, you will need the Public/Elastic IP of your instance.

```sh
  bosh target <your-bosh-lite-ip> lite
```

When using bosh-lite, the default username is `admin` and password is `admin` (if needed).

### Checking your work

You should see output similar to the following:

```sh
  $ bosh target 192.168.50.4 lite
  Target set to `Bosh Lite Director`
  ...
```

You should also be able to run `bosh status` and see something similar to the following:

```sh
  ...
  Name       Bosh Lite Director
  URL        https://192.168.50.4:25555
  Version    1.3215.3.0 (00000000)
  User       admin
  UUID       2da68ec9-3249-4c68-8f7b-aa6f5446033c
  CPI        warden_cpi
  dns        disabled
  compiled_package_cache enabled (provider: local)
  snapshots  disabled
  ...
```

## Preparing for the Deployment

In the previous module, we discussed the 3 components the bosh director needs to create a deployment: a stemcell, release and manifest.
To create a release and a manifest and understand the Cloud Foundry release deployment process with BOSH Lite, please read http://docs.cloudfoundry.org/deploying/boshlite/index.html.
Skip step 1, BOSH Lite has already been deployed for you.

Use `bosh help` to figure out how to add these to your director.

### Checking your work

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


## Deploying

Deployments in bosh are simple, provided you have provided the stemcell, release and manifest to the director. Deploy CF:

```sh
  bosh deploy
```

### Checking your work

If all went well, you should see "cf" deployed when running:

```sh
  bosh deployments
```

If you don't have CF running at this point, please ask for help.

## Beyond the class

* Preparing a "real" cloud for BOSH: http://bosh.io/docs/init.html
* bosh-init - deploy BOSH director to manage a "real" cloud: http://bosh.io/docs/using-bosh-init.html
* Try these commands

```sh
bosh help
bosh tasks
bosh tasks recent
bosh tasks recent --no-filter
bosh task <id> --debug
bosh recreate <job> <index_or_id>
```
