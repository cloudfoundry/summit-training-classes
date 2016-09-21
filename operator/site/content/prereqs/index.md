---
date: 2016-04-19T18:59:04-06:00
title: Prerequisites
---

Please review the requirement below and **complete the following prerequisites before class**.  

## Experience

This training is targeted at people with:

* Little to no Cloud Foundry BOSH experience  
* Some experience managing Linux-based systems
* Comfortable using the command line and SSH


## System Requirements

There are two ways to complete this class:

* Preferred: On a VM on Amazon Web Services.
* Unsupported but possible: On your laptop provided you have sufficient resources and permissions.


In either case, you **MUST have a laptop and be able to install software on it**.

## Preferred: On AWS

### Laptop Requirements

Please ensure the following:

* You **MUST be able to install software on your laptop**.
* You must have an SSH program.

### AWS Requirements

You must **bring your own AWS account**.  Additionally, please ensure the following:

* Access to a VPC
* An AWS Keypair tied to account that has the ability to create:
  * Elastic IPs
  * Security groups
  * (1) m3.xLarge instance

A guide to prepare your AWS account for installing BOSH lite can be found [here](/labs/bosh-lite-on-aws/). Instead of installing BOSH lite with vagrant you can also use an AMI to start BOSH lite (AMI ID: ami-2bcdb658).

## Not supported but possible: On your Laptop

### Laptop Requirements

Please ensure the following:

* Make sure your machine has at least 8GB RAM, and 100GB free disk space. Smaller configurations may work, but significantly smaller configurations will certainly fail.
* You **MUST be able to install software on your laptop**.
* You must have a command line SSH tool.

### Required Software

Please install the following:

* [Vagrant](https://www.vagrantup.com/downloads.html): Used to provision a bosh-lite instance.
* A Vagrant Provider.  [VirtualBox](https://www.virtualbox.org/wiki/Downloads) is recommended.  
* It is highly recommended that you ensure you laptop cannot "sleep" during class.  If you use a mac, you can install [caffeine](https://itunes.apple.com/us/app/caffeine/id411246225?mt=12).
