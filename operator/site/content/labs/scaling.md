---
date: 2018-02-16T19:21:15-03:00
title: Scaling
---

In this section, you will add application capacity to the Cloud Foundry platform, then scale your application.

## Scaling the Platform Out

Scaling out with BOSH is simple.  We simply need to change the manifest, add instances, and deploy.  In our case, the number of Diego cells in our deployment is set by [an 'operations' file](https://bosh.io/docs/cli-ops-files.html), which modifies the main deployment manifest (you included this as an option when you originally ran `bosh deploy`).

* Find the relevant ops file at ~/workspace/cf-deployment/operations/bosh-lite.yml
* Find the section of the file which changes the number of diego-cell instances and set the value from 1 to 2.
* Deploy

```sh
# In terminal 1
$ cd ~/workspace/cf-deployment
$ bosh -d cf deploy ~/workspace/cf-deployment/cf-deployment.yml \
-o ~/workspace/cf-deployment/operations/bosh-lite.yml \
-o ~/workspace/cf-deployment/operations/use-compiled-releases.yml \
--vars-store deployment-vars.yml \
-v system_domain=$SYSTEM_DOMAIN

...
  instance_groups:
  - name: diego-cell
-   instances: 1
+   instances: 2
Continue? [yN]:
```

```sh
# In terminal 2 (before hitting y)
cf top  # <-- switch to the "Cell Stats" display by hitting 'd'
```

* What happened?

### Checking Your Work

Once your deployment completes, you can run the following to see your additional instances:

```sh
bosh vms
```

## Scaling your Application

### Vertical Scaling

* Use the cf CLI to scale your application vertically (add memory).

```sh
# In terminal 1
# Use cf CLI to scale app vertically

# In terminal 2
cf top # <-- switch to the App Stats display
```

What happens?  Why?  How long does it take?  Is this a good idea in production systems?

### Horizontal Scaling

Use the cf CLI to scale your application horizontally to 2 instances.

```sh
# In terminal 1
# Use cf CLI to scale app horizontally

# In terminal 2
cf top # <-- switch to the App Stats display
```

What happens? How long does it take?

This is the preferred approach to scaling after allocating an appropriate level of resources to your app.

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
  * https://bosh.io/docs/azs.html
