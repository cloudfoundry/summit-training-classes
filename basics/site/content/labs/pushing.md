---
date: 2016-04-19T19:21:15-06:00
title: Pushing your first app
---

In this exercise, you will deploy an app to Cloud Foundry.

## Get the App Code

We'll be working with applications that have already been written and are available on GitHub.

{{% do %}}If you do not have `git` installed, you can download the code from [https://github.com/EngineerBetter/training-zero-to-hero/archive/master.zip](https://github.com/EngineerBetter/training-zero-to-hero/archive/master.zip). You'll need to unzip it once you have downloaded it.{{% /do %}}
{{% do %}}If you have `git` installed, you can clone the repository with `git clone https://github.com/EngineerBetter/training-zero-to-hero.git`{{% /do %}}

All paths in these exercises assume that you're in the `training-zero-to-hero` directory.

{{% do %}}Open a terminal window (Linux, macOS) or command prompt (Windows){{% /do %}}
{{% do %}}Navigate to the `training-zero-to-hero` using the `cd` command{{% /do %}}

## Push the App

Let's push the app in `03-push/web-app` to Cloud Foundry.

{{% do %}}Make sure you are logged in and targeting your org/space.{{% /do %}}
{{% do %}}Change to the `03-push/web-app` directory{{% /do %}}
{{% do %}}Run `cf push`{{% /do %}}
{{% observe %}}Watch the CF CLI output the progress of your push{{% /observe %}}
{{% do %}}When your push has finished, run `cf apps` to see the list of apps in your space{{% /do %}}

{{% checking %}}

You should see something like this:

```sh
$cf apps

name      state     instances   memory   disk   urls
web-app   started   1/1         32M      256M   web-app-unpassionate-eighteen.cfapps.io
```

{{% /checking %}}

## Accessing Your App

{{% question %}}How can you access your web app?{{% /question %}}

So where is your app? When you pushed, in amongst a lot of output you should have seen a message similar to:

```sh
...
urls: web-app-unpassionate-eighteen.cfapps.io
...
```

Alternatively, you can find URL mapped to your app in the output of `cf apps` (above).

{{% do %}}Access your app in a web browser{{% /do %}}

## Look at What was Pushed

### Deployment Manifest

This app is configured with a [deployment manifest](https://docs.cloudfoundry.org/devguide/deploy-apps/manifest.html).  The manifest tells CF the app name and how many instances to create (among other things). Manifests are optional.

You can see the manifest by opening the file: `03-push/web-app/manifest.yml`.

```yaml
applications:
- name: web-app
  random-route: true
```

### Random Route

The app deploys using `random-route`.  Since the `cfapps.io` is shared by all [run.pivotal.io](https://run.pivotal.io/) apps, we need an easy way to deploy our app to this shared domain for development.  If you are using The Swisscom Application  Cloud, the shared domain will be `scapp.io`.

You can see the details on `random-route` using cf help:

```sh
cf push --help
```

&nbsp;

{{% do %}}Use `cf app web-app` to see more details of your app:{{% /do %}}

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

## Push the Worker App

Not all apps need to respond to HTTP requests: instead they might do background work, such as consuming messages from a queue.

{{% do %}}Push the app in the `worker-app` directory{{% /do %}}
{{% question %}}What differences are there in the manifest? Why are these needed?{{% /question %}}

{{% checking %}}

You should not see any URLs associated with your worker app:

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

{{% /checking %}}

## View App Logs

The worker app outputs logs, and Cloud Foundry allows you to see these from your computer.

{{% do %}}Use `cf help -a` to determine what command to run to see *recent* logs.{{% /do %}}

{{% checking %}}

You should see output similar to:

```sh
2016-08-30T11:53:13.02+0100 [APP/0]      OUT Doing some work...
```

{{% /checking %}}

## Make room (for better apps)

You can also delete apps.

{{% do %}}Delete the two apps you deployed (use `cf help -a` to find the correct command){{% /do %}}

{{% checking %}}

You should not see either `web-app` or `worker-app` when you run `cf apps`.

{{% /checking %}}

## Beyond the Class

  * Debug `cf` commands with [`CF_TRACE=true`](https://docs.cloudfoundry.org/devguide/deploy-apps/troubleshoot-app-health.html#trace)
  * Create your own [`manifest.yml`](https://docs.cloudfoundry.org/devguide/deploy-apps/manifest.html)
  * Learn about [pushing WAR files](https://docs.cloudfoundry.org/buildpacks/java/java-tips.html)
