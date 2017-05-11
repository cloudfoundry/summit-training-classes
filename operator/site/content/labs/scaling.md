---
date: 2016-05-19T11:56:15-03:00
title: Scaling
---

In this section, you will add application capacity to the Cloud Foundry platform, then scale your application.

## Scaling the Platform Out

Scaling out with bosh is simple.  We simply edit the manifest, add instances, and deploy.

* Edit your Diego deployment manifest.
* Find the `cell_z1` instance and increase the number to 2.
* Deploy

```sh
# In terminal 1
bosh deploy

# In terminal 2
cf top  # <-- switch to the "Cell Stats" display
```
* What happened?

### Checking Your Work

Once your deployment completes, you can run the following to see your additional instances:

```sh
bosh vms
```

## Scaling your Application

### Vertical Scaling

* Use the cf cli to scale your application vertically (add memory).

```sh
# In terminal 1
# Use cf cli to scale app vertically

# In terminal 2
cf top # <-- switch to the App Stats display
```

What happens?  Why?  How long does it take?  Is this a good idea in production systems?

### Horizontal Scaling

Use the cf cli to scale your application horizontally to 2 instances.

```sh
# In terminal 1
# Use cf cli to scale app horizontally

# In terminal 2
cf top # <-- switch to the App Stats display
```

What happens?  How long does it take?

This is the preferred approach to scaling after right sizing your app.

### Checking Your Work

You can see the amount of memory and number of instances using:

```sh
cf app <your-app>
```


## Beyond the Class

* Canaries & max-in-flight
  * https://bosh.io/docs/deployment-manifest.html#update
  * https://bosh.io/docs/terminology.html#canary
* Drain scripts
  * http://bosh.io/docs/drain.html
* Availability Zones
  * https://github.com/cloudfoundry/bosh-notes/blob/master/availability-zones.md
