---
date: 2016-04-19T19:21:15-06:00
title: Stateful Services
---

In this lab,  you will create an instance of a Redis service and use it with an app.

## Creating a service instance

First, you need to create an instance of the service.  But you need to know what to create.

* Use `cf marketplace` to view the details of the Redis service.
* Use `cf service` to create an instance of the `30mb` plan.

### Checking Your Work

You can view your service instances:

```sh
$ cf services

name    service      plan   bound apps   last operation
redis   rediscloud   30mb                create succeeded
```

## Binding Service Instances

Now, you need to bind your service instance to your application so it can be used.  A sample app is included in `07-shared-state/stateful-app`.

* Push the sample app with the `--no-start` flag.
* Use `cf bind-service` to bind your service instance to your app.
* Then start/restart your app so that it can pick up the environment values.

### Checking Your Work

If you view the details of your app, you should see the bound services.

```sh
cf app <your-app>
```

## Let's iterate on user feedback

* Set the following env variable and restart your app.

```sh
$ cf set-env stateful-app SHOW_APP_SUPPORTERS true
$ cf restart stateful-app
```

* Then, open your app in a browser.

* Scale your app.

## Beyond the Class

  * Use [SendGrid](https://sendgrid.com/) to send e-mails
  * Use [IronWorker](https://www.iron.io/worker/) for async tasks
  * Learn about [security groups](https://docs.cloudfoundry.org/adminguide/app-sec-groups.html)
  * Use a [manually created](https://docs.pivotal.io/pivotalcf/devguide/services/user-provided.html) IBM [Cloudant instance](https://cloudant.com/)
