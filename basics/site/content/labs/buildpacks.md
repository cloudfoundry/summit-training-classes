---
date: 2016-04-19T19:21:15-06:00
title: Buildpacks
---

In this exercise, we will examine a running app to understand what a buildpack provides.

## System Buildpacks

* Use `cf help` to find out how to take a look at the buildpacks configured in PWS.
* _If you don't specify a buildpack, what is the first one that will be tested for?_


## Pushing with the Static Buildpack

An app is included in the `04-buildpacks/static-app` directory.

* Push the app in `04-buildpacks/static-app` to CF using the provided manifest

### Checking Your Work

You can view the details of your app:

```sh
$ cf app static-app

     state     since        cpu    memory        disk
#0   running   2015-11-02   0.0%   6.5M of 16M   33.6M of 64M
```

## Exploring Buildpack Output

* _How does the running droplet compare to your app directory?_
* Use `cf ssh static-app` to explore the filesystem of the running application
* Observe what additional dependencies the buildpack made available for your app

## Scaling with Speed

* Use `cf scale` to scale your static app to 32 instances
* _Why is CF able to scale instances so quickly?_


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


## Picking the Correct Buildpack

Cloud Foundry correctly used the Staticfile Buildpack to deploy your app. It did this because the app includes a file 
called `Staticfile`.

Change into `04-buildpacks/mixed-app` and see that the directory contains both `index.html` and `index.php`. 

* _Which buildpack do you think will be used to run this app? Staticfile, or PHP?_
* `cf push` mixed-app
* Observe from the CLI output which buildpack was used
* Hit both `/index.html` and `index.php`
* Use `cf ssh` to see what files the buildpack has added

Instead of letting Cloud Foundry allow each buildpack to detect whether it can run the app, we're going to specify which buildpack we want to use.

* Push the app again, this time with the flag `-b https://github.com/cloudfoundry/staticfile-buildpack`
* Observe from the CLI output which buildpack was used
* Hit both `/index.html` and `index.php`
* _What happens this time? Why?_
* Use `cf ssh` to see what files the buildpack has added, and how they differ from the last push


## Cleaning Up

Delete your apps to free up space.

## Beyond the Class

  * Write [custom buildpack](https://docs.cloudfoundry.org/buildpacks/custom.html) using [caddy HTTP/2 server](https://caddyserver.com/)
  * Deploy static-app with custom caddy buildpack
