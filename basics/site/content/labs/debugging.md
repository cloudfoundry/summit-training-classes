---
date: 2016-04-19T19:21:15-06:00
title: Debugging
---

In this lab, you will continue to master debugging techniques for your applications.

## Push a buggy app

A buggy app is included in the `06-debugging/debug-app` directory with a manifest.

* Push it to PWS
* Note the URL

### Access the App

Open a browser and access the app.  You should see a 500 error.

## Check out the Logs

Use `cf logs` to access the recent logs and debug the issue.  Alternatively, should be able to tail the logs using `cf logs` and then access the app.

### Checking Your Work

You should see something similar to this in the logs:

```sh
... [App/0] ERR ...  - RuntimeError - I am a bug, fix me:
```

### Fix it

This app can be fixed by setting an environment variable and restarting it.  

* Use `cf help` to set an environment variable for your app called `FIXED` with a value of `true`.
* Then restart your app.


## Debugging with Events

* View the recent events for your app.  

### Checking Your Work

You should see something like the following:

```sh
... index: 0, reason: CRASHED, exit_description: 2 error(s) ...
```

## App instrumentation

We will use New Relic as a example.  The process involves creating an instance of the New Relic service, binding it to our app, adding a license key, then re-pushing.

```sh
$ cf create-service newrelic standard newrelic
$ cf bind-service debug-app newrelic
```

The license key is included in the environment.

```sh
$ cf env debug-app
# Find your New Relic license key
```

You need to add the license key to a file in the app directory.

```sh
# From the training home directory:
$ cd 06-debugging/debug-app
# Replace YOUR-LICENSE-KEY
$ vim newrelic.yml
```

Then re-push.

```bash
$ cf push
```

### Viewing the Dashboard

New Relic has a dashboard.  You can find the URL by looking at the service details.

```bash
$ cf service newrelic
```

Open the link in your browser.


## SSH access

If you need to, you can also access the application container directly via `cf ssh`.

```bash
$ cf ssh debug-app
```

This allows you to see the running container and the file system.


## Beyond the Class

* Setup [Skylight](https://www.skylight.io/) for app
* Setup [Opbeat](https://opbeat.com/) for app
* Learn about [CF Logging and Metrics](http://www.cfsummit.com/sites/cfs2015/files/pages/files/cfsummit15_king.pdf)
* Send app logs to [Papertrail](https://papertrailapp.com/)

```sh
$ cf cups logdrain -l syslog://YOUR-PAPERTRAIL-LOG-DESTINATION
$ cf bind-service debug-app logdrain
# Check your Papertrail Events, no need to restart the app
```
