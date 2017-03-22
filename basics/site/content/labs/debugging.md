---
date: 2016-04-19T19:21:15-06:00
title: Debugging
---

In this lab, you will continue to master debugging techniques for your applications.

## Push a buggy app

A buggy app is included in the `06-debugging/debug-app` directory with a manifest.

* Push `06-debugging/debug-app` to PWS
* Note the URL

### Access the App

* Open a browser and access the app.
* Observe a 500 error.
* _What does Cloud Foundry think the health of the app is? How did it draw this conclusion?_

Getting fast feedback on failures is a key element of agility. The sooner we know something is broken, the sooner we can fix it.

* Use `cf push --help` and Cloud Foundry documentation to push the app again, in a way that Cloud Foundry will deem it unhealthy

## Check out the Logs

* Use `cf logs` to access the recent logs and debug the issue.

If you do not specify the `--recent` flag to `cf logs`, it will start tailing logs from that point onwards.

#### Checking Your Work

You should see something similar to this in the logs:

```sh
... [App/0] ERR ...  - RuntimeError - I am a bug, fix me:
```

### Fix it

This app can be fixed by setting an environment variable and restarting it.

* Use `cf help` to find out how to set an environment variable for your app called `FIXED` with a value of `true`
* Restart your app, and visit it in a browser to check that the bug is fixed

## Debugging with Events

Now the app offers other links that allow you to terminate the app's process, use up all the app's RAM, or fill the disk.

* Click "stop process"
* Observe the output of `cf events` and `cf logs` for your app
* Click "exhaust memory"
* Observe the output of `cf events` and `cf logs` for your app
* _How do the two compare? What help does Cloud Foundry give you in determining the cause of failure?_

#### Checking Your Work

You should see something like the following:

```sh
... index: 0, reason: CRASHED, exit_description: 2 error(s) ...
```

* Click the 'exhaust disk' link, and check `cf logs` and `cf events`.
* _What happens? Is this what you expected?_

## App instrumentation

We will use New Relic as a example.  The process involves creating an instance of the New Relic service, binding it to our app, adding a license key, then re-pushing. Services are covered in another section of this course, so don't worry if you don't understand these commands.

* Create a New Relic service instance: `cf create-service newrelic standard newrelic`
* Tell Cloud Foundry that `debug-app` should use your New Relic service instance: `cf bind-service debug-app newrelic`
* Find the New Relic license key in the output of `cf env debug-app`
* In `newrelic.yml`, replace `YOUR-LICENSE-KEY` with the value you just found
* Re-push the app

### Viewing the Dashboard

New Relic has a dashboard. You can find the URL by looking at the service details.

* Visit the URL reported by `cf service newrelic`

It takes some time for the data from your app to be visible in the New Relic dashboard.


## SSH access

Don't forget that you can use `cf ssh` to look at the current filesystem of your app.


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
