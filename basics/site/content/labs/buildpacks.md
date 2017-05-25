---
date: 2016-04-19T19:21:15-06:00
title: Buildpacks
---

In this exercise, we will examine a running app to understand what a buildpack provides.

## View System Buildpacks

{{% do %}}Use `cf help -a` to find out how to take a look at the buildpacks configured in PWS.{{% /do %}}
{{% question %}}If you don't specify a buildpack, what is the first one that will be tested for?{{% /question %}}


## Pushing with the Static Buildpack

An app is included in the `04-buildpacks/static-app` directory.

{{% do %}}Push the app in `04-buildpacks/static-app` to CF using the provided manifest{{% /do %}}
{{% question %}}How can you check that you pushed your app successfully?{{% /question %}}

## Explore Buildpack Output

{{% question %}}How does the running droplet compare to your app directory?{{% /question %}}
{{% do %}}Use `cf ssh static-app` to explore the filesystem of the running application{{% /do %}}
{{% observe %}}Observe what additional dependencies the buildpack made available for your app{{% /observe %}}

## Scale with Speed

{{% do %}}Use `cf scale` to scale your static app to 16 instances{{% /do %}}
{{% question %}}Why is CF able to scale instances so quickly?{{% /question %}}


#### Checking Your Work

You can view the details of your app:

```sh
$ cf app static-app

     state      since        cpu    memory        disk
#0   running    2015-11-02   0.0%   6.5M of 16M   33.6M of 64M
#1   starting   2015-11-02   0.0%   0 of  16M     0 of 64M
#2   running    2015-11-02   0.0%   6.9M of 16M   33.5M of 64M
...
#14   running   2015-11-02   0.0%   6.8M of 16M   33.5M of 64M
#15   running   2015-11-02   0.0%   7M of 16M     33.6M of 64M
```


## Override the Chosen Buildpack

Cloud Foundry correctly used the Staticfile Buildpack to deploy your app. It did this because the app includes a file
called `Staticfile`.

{{% do %}}Change into `04-buildpacks/mixed-app` and see that the directory contains both `index.html` and `index.php`{{% /do %}}
{{% question %}}Which buildpack do you think will be used to run this app? Staticfile, or PHP?{{% /question %}}
{{% do %}}Use `cf push` to deploy `mixed-app`{{% /do %}}
{{% observe %}}Observe from the CLI output which buildpack was used{{% /observe %}}
{{% do %}}Hit both `/index.html` and `/index.php`{{% /do %}}
{{% do %}}Use `cf ssh` to see what files the buildpack has added{{% /do %}}

Instead of letting Cloud Foundry allow each buildpack to detect whether it can run the app, we're going to specify which buildpack we want to use.

{{% do %}}Push the app again, using a flag to specify this buildpack: `https://github.com/cloudfoundry/staticfile-buildpack` (use `cf push --help` to find out which flag to provide){{% /do %}}
{{% observe %}}Observe from the CLI output which buildpack was used{{% /observe %}}
{{% do %}}Hit both `/index.html` and `/index.php`{{% /do %}}
{{% question %}}What happens this time? Why?{{% /question %}}
{{% do %}}Use `cf ssh` to see what files the buildpack has added, and how they differ from the last push{{% /do %}}


## Clean Up

{{% do %}}Delete your apps to free up space.{{% /do %}}

## Beyond the Class

  * Write [custom buildpack](https://docs.cloudfoundry.org/buildpacks/custom.html) using [caddy HTTP/2 server](https://caddyserver.com/)
  * Deploy static-app with custom caddy buildpack
