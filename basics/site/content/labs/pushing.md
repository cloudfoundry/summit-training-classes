---
date: 2016-04-19T19:21:15-06:00
title: Pushing your first app
---

In this exercise, you will deploy an app to Cloud Foundry.

## Push my app

Be sure you are logged in and targeted to your org/space.

A sample app is provided in the `basics/static/resources` directory.  Push it to cloud foundry.

```bash
# From the training home directory:
$ cd 03-first-app/web-app
$ cf push

...

urls: web-app-unpassionate-eighteen.cfapps.io   <<< note the route
```

### Deployment Manifest

This app is configured with a [deployment manifest](https://docs.cloudfoundry.org/devguide/deploy-apps/manifest.html).  The manifest tells cf the app name and how many instances to create (among other things).  Manifests are optional.  

You can see the manifest by opening the file: `03-first-app/web-app/manifest.yml`.

```sh
name: web-app
memory: 32M
disk_quota: 256M
random-route: true
buildpack: ruby_buildpack
```

### Random Route

The app deploys using `random-route`.  Since the `cfapps.io` is shared by all [run.pivotal.io](https://run.pivotal.io/) apps, we need an easy way to deploy our app to this shared domain for development.

You can see the details on `random-route` using cf help:

```sh
cf push --help
```

So where is your app?  When you pushed, you should have seen a message:

```sh
urls: web-app-unpassionate-eighteen.cfapps.io
```

Alternatively, you can look up the details on your app (next section).

### Checking Your Work

#### What apps are in the CF space?

```sh
$cf apps

name      state     instances   memory   disk   urls
web-app   started   1/1         32M      256M   web-app-unpass...
```

#### I want to see more app info...

```sh
$ cf app web-app

requested state: started
instances: 1/1
usage: 32M x 1 instances
urls: web-app-unpassionate-eighteen.cfapps.io
last uploaded: Mon Nov 2 10:18:05 UTC 2015
stack: cflinuxfs2
buildpack: ruby 1.6.7

     state     since        cpu    memory         disk
#0   running   2015-11-02   0.0%   25.7M of 32M   95.1M of 256M
```

## Pushing worker apps

A worker app (no tcp routing) is also included.  You can push this app from the **TO DO** 03-first-app/worker-app directory.


### Checking Your Work

```sh
$ cf app worker-app

requested state: started
instances: 1/1
usage: 16M x 1 instances
urls:
last uploaded: Mon Nov 2 13:56:39 UTC 2015
stack: cflinuxfs2
buildpack: binary_buildpack

     state     since        cpu    memory         disk
#0   running   2015-11-02   0.0%   10.7M of 16M   27.3M of 64M
```

## Viewing Logs

The worker app outputs logs.  Use `cf help` to determine what command to run to see recent logs.

### Checking Your Work

You should see an output similar to:

```sh
2015... [App/0] ERR + main
2015... [App/0] ERR + find_my_public_ip
2015... [App/0] ERR + which curl
2015... [App/0] ERR + curl -sL https://api.ipify.org?format=json
2015... [App/0] OUT {"ip":"54.236.219.204"}
2015... [App/0] ERR + suspend_myself
2015... [App/0] ERR + kill -STOP 11
```

## Make room (for better apps)

You can also delete apps.  Delete the two apps you deployed using `cf help` to find the correct command.

### Checking Your Work

You should not see your apps when you run:

```sh
cf apps
```

## Beyond the Class

  * Debug `cf` commands with [`CF_TRACE=true`](https://docs.cloudfoundry.org/devguide/deploy-apps/troubleshoot-app-health.html#trace)
  * Create your own [`manifest.yml`](https://docs.cloudfoundry.org/devguide/deploy-apps/manifest.html)
  * Learn about [pushing WAR files](https://docs.cloudfoundry.org/buildpacks/java/java-tips.html)
