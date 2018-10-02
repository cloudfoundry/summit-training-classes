---
date: 2016-04-19T19:21:15-06:00
title: Availability
---

In this lab, we will use purposefully crash app instances and see how Cloud Foundry works to maintain availability.

## Push a Crashable App

{{% question %}}What happens when an app crashes?{{% /question %}}
{{% do %}}Change to the `05-resilience/imperfect-app` directory and push the crashable app.{{% /do %}}
{{% do %}}Note the random URL for your app, and visit it in a browser.{{% /do %}}
{{% do %}}Click the 'crash' link{{% /do %}}
{{% do %}}Use `cf app imperfect-app` to see the state of your app.{{% /do %}}
{{% question %}}Can you see it in the "crashed" state before Cloud Foundry restarts it?{{% /question %}}

## Access Your App Amid Failures

{{% do %}}Scale your app to 3 instances.{{% /do %}}
{{% do %}}Use `cf apps` to ensure you have 3 instances requested.{{% /do %}}
{{% do %}}Visit your app and click the 'crash' link.{{% /do %}}
{{% do %}}Refresh the page, and Cloud Foundry will send your request to one of the healthy instances.{{% /do %}}

### Can you crash instances quicker than Cloud Foundry can restart them?

If you have `watch` available on your system, use it to watch app instances restart.

```sh
$ watch cf apps # Watch app instances restart
```

If not, you can re-run `cf app` multiple times.

```sh
$ cf app imperfect-app

     state     since       cpu    memory         disk
#0   running   2015-11-02  0.0%   25.3M of 32M   66.9M of 128M
#1   down      2015-11-02  0.0%   0 of 0         0 of 0
#2   down      2015-11-02  0.0%   0 of 0         0 of 0
```

{{% question %}}What happens if you make a request whilst they are all down?{{% /question %}}

{{% do %}} Delete your app to free up space. {{% /do %}}

## Beyond the Class

  * Read the [Twelve-Factor App](http://12factor.net/)
  * Benchmark app with [Load Impact](https://loadimpact.com/) (crash 1-2 instances)
  * Read about [Zero-downtime deployments in CF](http://garage.mybluemix.net/posts/blue-green-deployment/)
  * Use [cf-blue-green-deploy](https://github.com/bluemixgaragelondon/cf-blue-green-deploy) CLI plugin
  * [Coding Horror wisdom](http://blog.codinghorror.com/version-1-sucks-but-ship-it-anyway/)
