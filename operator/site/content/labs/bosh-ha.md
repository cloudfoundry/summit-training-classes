---
date: 2016-05-19T11:52:15-03:00
title: Interacting with bosh clusters
---


In this lab, you will explore the CF cluster you deployed with bosh.

## Bosh Cluster Basics

The bosh cli includes a large number of useful features to explore your clusters.

### VM Details

You can view details on the vms bosh has deployed using either `bosh instances` or `bosh vms`. `bosh instances` provides more detailed information. Try both and see the differences.

```sh
 bosh instances
```

OR

```sh
 bosh vms
```

Use `bosh help <command>` to see available flags for each command. How would you see all vms and all details?

### Accessing VMs

You can ssh to any vm bosh has deployed.

```sh
  bosh ssh
```

* SSH into doppler_z1/0
* Bosh installs components in `/var/vcap`.

```bash
/var/vcap
 ├── bosh
 ├── data
 ├── jobs              <-- config
 ├── packages          <-- binaries
 ├── store             <-- persistant disk
 └── sys
        └── log        <-- logs
```
* You can tail logs individually or all at once:

```
tail --lines=1 -f /var/vcap/sys/log/*/*
```

## Health Monitoring

### Process Monitoring with Monit

On the doppler vm:

```sh
sudo /var/vcap/bosh/bin/monit summary
```

* This shows the processes monit is running.  Let's kill one and see what happens.

```bash
#in terminal 1
sudo watch /var/vcap/bosh/bin/monit summary
#in terminal 2
kill -9 $(cat /var/vcap/sys/run/doppler/doppler.pid)
```

* Monit status is reported up to BOSH director

```sh
#in terminal 1 (on the bosh-lite VM)
watch bosh instances --failing
#in terminal 2 (on the doppler VM)
kill -9 $(cat /var/vcap/sys/run/doppler/doppler.pid)
```

### VM resurrection

#### Cloud Check

Bosh cloudcheck can be used to trigger a manual health check. Try it:

```sh
  bosh cloudcheck
```

If errors are found, bosh will provide options to fix issues.

#### Automatic Resurrection

The following command will find a VM and kill it.
The script is necessary b/c the "VMs" are actually containers when using bosh-lite.

```bash
#in terminal 1 (on the bosh-lite VM)
watch bosh instances --failing
#in terminal 2 (on the bosh-lite VM)
curl -XDELETE http://127.0.0.1:7777/containers/$(curl -s http://127.0.0.1:7777/containers | jq -r '.["Handles"][4]')
```

## Beyond the class

* BOSH Health Monitor plugins
  * BOSH can forward status data to external monitoring systems
  * http://bosh.io/docs/hm-config.html
* [4 levels of HA in Cloud Foundry](http://blog.pivotal.io/pivotal-cloud-foundry/products/the-four-levels-of-ha-in-pivotal-cf)
