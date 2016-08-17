---
date: 2016-04-19T19:21:15-06:00
title: Availability
---

In this lab, we will use a flawed app and see how Cloud Foundry works to maintain availability.

## Pushing a Flawed App

* Change to the `05-resilience/imperfect-app` directory and push the flawed app.

* Note the random URL for your app.

## Scaling

* Scale your app to 3 instances.  

### Checking Your Work

Use `cf apps` to ensure you have 3 instances requested.

```sh
$ cf apps

name            state     instances   memory   disk   urls
imperfect-app   started   2/3         32M      256M   imperfect..
```

## Access Your App Amid Failures

Use `cf app` and notice instances are crashing.  However, you can still access the app via the random URL from above.  

```sh
$ cf app imperfect-app

     state     since       cpu    memory         disk
#0   running   2015-11-02  0.0%   25.3M of 32M   66.9M of 128M
#1   down      2015-11-02  0.0%   0 of 0         0 of 0
#2   down      2015-11-02  0.0%   0 of 0         0 of 0
```

If you have `watch` available on your system, use it to watch app instances restart in real time.

```sh
$ watch cf apps # Watch app instances restart in real-time
```

If not, you can re-run `cf app` multiple times.


## Diagnosing Issues

This app has 2 flaws.  You will use the cf cli to diagnose and correct the problems.

### `cf events`

The `cf events` command can be used to show recent events for your app.  Among those are often crashes and restarts.

* Use `cf events` to diagnose the reason your app is crashing.
* Use the cf cli to fix the issue.  What was the problem?

#### Checking Your Work

Using `cf events` you should have noticed your app did not have enough memory.  You should have used `cf scale` to add memory to your app.

### Diagnosing Further

There is still a problem with the app.

* View the recent logs for your app to diagnose this problem.
* Correct the problem using the cf cli.

#### Checking Your Work

You should have noticed something similar to the following in your logs:

```sh
Errno::EDQUOT - Disk quota exceeded @ io_write - infinite-file:
```

This can be fixed by scaling the disk for your app.

## Beyond the Class

  * Read the [Twelve-Factor App](http://12factor.net/)
  * Benchmark app with [Load Impact](https://loadimpact.com/) (crash 1-2 instances)
  * Read about [Blue-Green deployment in CF](http://garage.mybluemix.net/posts/blue-green-deployment/)
  * Use [cf-blue-green-deploy](https://github.com/bluemixgaragelondon/cf-blue-green-deploy) cli plugin
  * [Coding Horror wisdom](http://blog.codinghorror.com/version-1-sucks-but-ship-it-anyway/)
