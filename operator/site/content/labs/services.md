---
date: 2016-05-19T14:00:15-03:00
title: Deploying a Redis Data Service
---

In this exercise, you will use bosh to add a redis service to your Cloud Foundry installation.  Then, as a user of CF, you will create an instance of this service and bind it to your app.

## Deploying Redis

Given your knowledge of bosh, deploy a new Redis cluster.

* First, you will need to clone the release repo, using this address: `https://github.com/pivotal-cf/cf-redis-release.git`
* Then, use the scripts directory to generate a bosh-lite manifest for warden. Modify any placeholders you come across (look at the script's code)
* Use the generated manifest to find dependent releases and upload to bosh-lite
* Set the deployment file and deploy!

> **Warning**: To be fair, instruction in the repo's README are a bit old. You may need to read some code. Ask for help if you need!

### Checking Your Work

If you run the following, you should see your redis cluster deployed:

```sh
bosh deployments
```

You should also see redis VMs created:

```sh
bosh vms
```

## Register the Service Broker

An errand is included in the redis release that registers the broker with Cloud Foundry.  You can see the available errands by running:

```sh
bosh errands
```

The errand is called `broker-registrar`.  Use the bosh cli to run this errand.

### Checking Your Work

At this point, you should see redis available inside the cf marketplace:

```sh
cf marketplace
```

## Using the Redis Service

Now, we will switch back to CF and use the new redis service.

### Creating a Service Instance

Use `cf create-service` to create a new service instance of the redis service.

### Checking Your Work

If you run the following, you should see your service instance:

```sh
cf services
```

### Binding your Service Instance

In order for your app to be able to use the service, you must `bind` it.  Use the cf commands to bind the service instance to your application.

### Checking Your Work

There are many ways to check and see what services are bound to an app.  One way is to re-run `cf services`.

### How does it work?

Run the following:

```sh
  cf env <your-app>
```

You should see json outputted to the command line.  Find the section that looks like:

```

  System-Provided:
  {
    VCAP_SERVICES: {
    ...
  }
```

Under this you should see the redis service.  The connection credentials were provided by the service broker and handed to the application via an environment variable called `VCAP_SERVICES`.  This is why cf prompted you to `restage` your application after binding.

## Beyond the Class

Review the documentation on [Application Security Groups](https://docs.pivotal.io/pivotalcf/adminguide/app-sec-groups.html).

It is best practice to restrict outgoing access by default through the use of the system-wide `running` and `staging` security groups.  Then, allow exceptions on a space by space basis by binding security groups to spaces.

Modify your running security group to restrict access, then create a security group (and bind it to your space) that allows your app to connect to redis.
