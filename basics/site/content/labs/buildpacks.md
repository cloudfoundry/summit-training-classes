---
date: 2016-04-19T19:21:15-06:00
title: Buildpacks
---

In this exercise, you will explore buildpack basics.

## System Buildpacks

Use `cf help` to take a look at the buildpacks configured in PWS.  

* If you don't specify a buildpack, what is the first one that will be checked?


## Pushing with the Static Buildpack

An app is included in the `04-buildpacks/static-app` directory.  Push this app to CF using the provided manifest.

This app uses a very small amount of memory and will be used to demonstrate the speed of scaling in Cloud Foundry.

### Checking Your Work

You can view the details of your app:

```sh
$ cf app static-app

     state     since        cpu    memory        disk
#0   running   2015-11-02   0.0%   6.5M of 16M   33.6M of 64M
```

## Scaling with Speed

Use `cf scale` to scale your static app to 32 instances.  

* Why is CF able to scale instances so quickly?


### Checking Your Work

You can view the details of your app:

```sh
$ cf app static-app

     state      since        cpu    memory        disk
#0   running    2015-11-02   0.0%   6.5M of 16M   33.6M of 64M
#1   starting   2015-11-02   0.0%   0 of  16M     0 of 64M
#2   running    2015-11-02   0.0%   6.9M of 16M   33.5M of 64M
...
#30   running   2015-11-02   0.0%   6.8M of 16M   33.5M of 64M
#31   running   2015-11-02   0.0%   7M of 16M     33.6M of 64M
```

## Cleaning Up

Delete your apps to free up space.

## Beyond the Class

  * Write [custom buildpack](https://docs.cloudfoundry.org/buildpacks/custom.html) using [caddy HTTP/2 server](https://caddyserver.com/)
  * Deploy static-app with custom caddy buildpack
