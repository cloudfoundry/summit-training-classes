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

If you view the details of your service, you should see which apps it is bound to.

```sh
cf services
```

If you hit the `/env` endpoint of your app, or run the command `cf env stateful-app`, you will see the `VCAP_SERVICES` environment variable that Cloud Foundry provides to your app. When a service is bound to your app, its details appear in this variable.

## Demonstrating Persistence

Visit the app in a browser and you'll see the number of requests this app instance has served, along with the overall total number of requests _all_ app instances have served.

Restart the app and visit it in a browser again. You'll see that the total number of requests is still stored in Redis, even though the app was restarted.

## Exploring the Service Instance Lifecycle

Scale your app, and you'll be able to see the difference between different app instances serving requests and the overall hit count in their shared Redis service instance.

Stop the app, and use `cf unbind-service` to unbind the service from the app. Rebind the app, start it, and see that the Redis instance still holds the same state.

Can you use `cf delete-service redis`? Do whatever is necessary to delete the service instance, and then create it again. When you start your app and visit it in a browser, you'll see that this is a new, clean Redis instance with no existing state.

## Beyond the Class

  * Use [SendGrid](https://sendgrid.com/) to send e-mails
  * Use [IronWorker](https://www.iron.io/worker/) for async tasks
  * Learn about [security groups](https://docs.cloudfoundry.org/adminguide/app-sec-groups.html)
  * Use a [manually created](https://docs.pivotal.io/pivotalcf/devguide/services/user-provided.html) IBM [Cloudant instance](https://cloudant.com/)
