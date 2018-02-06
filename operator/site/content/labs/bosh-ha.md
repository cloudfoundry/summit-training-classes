---
date: 2018-02-06T11:52:15-03:00
title: Interacting with BOSH clusters
---

## BOSH Cluster Basics

In this lab, you will explore the Cloud Foundry cluster you deployed with BOSH.
The BOSH command line interface offers many useful features for exploring your clusters.

### VM Details

You can view details of the VMs BOSH has deployed with the commands `bosh instances` and `bosh vms`. Play with both of these, exploring the various command line options to show different information. Remember that to get help you can run `bosh <command> -h`.

### Accessing VMs

You can 'ssh' to any virtual machine deployed by BOSH.

```sh
  bosh ssh -d <deployment name> <instance-id>
```

For example:

```sh
  bosh ssh -d cf diego-api/c754437a-738e-43d7-8f07-b1ddd2359d3b
```

* Choose a VM to ssh to. Once you're connected, change directory to `/var/vcap`.

```bash
/var/vcap
 ├── bosh
 ├── data
 ├── instance          <-- instance identity & health
 ├── monit
 ├── packages          <-- binaries
 └── sys
        └── log        <-- logs
```
* You can tail logs individually or all at once:

```
tail --lines=1 -f /var/vcap/sys/log/*/*
```

## Health Monitoring

### Process Monitoring with Monit and VM resurrection


While still ssh-ed into a VM, try the following:

```sh
sudo /var/vcap/bosh/bin/monit summary
```

* This shows the processes monit is running.  Let's kill one and see what happens.

```bash
# terminal 1
sudo watch /var/vcap/bosh/bin/monit summary
# terminal 2
sudo kill -9 $(cat /var/vcap/sys/run/consul_agent/consul_agent.pid)
```

* The output from Monit status is also sent to the BOSH director. Try the following:

```sh
#in terminal 1, back on the bosh-lite VM
watch bosh instances --failing
#in terminal 2, while ssh-ed into a VM from your deployment
sudo kill -9 $(cat /var/vcap/sys/run/consul_agent/consul_agent.pid)
```
#### Cloud Check

After you `exit` from the VM, try using BOSH's cloudcheck to trigger a manual health check:

```sh
  bosh -d <deployment-name> cloudcheck
```

## Beyond the class

* [BOSH Health Monitor plugins - for forwarding status data to external monitoring systems](http://bosh.io/docs/hm-config.html)
* [4 levels of HA in Cloud Foundry](http://blog.pivotal.io/pivotal-cloud-foundry/products/the-four-levels-of-ha-in-pivotal-cf)
