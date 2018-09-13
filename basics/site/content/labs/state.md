---
date: 2016-04-19T19:21:15-06:00
title: Stateful Services
---

In this lab,  you will create an instance of a Redis service and use it with an app.

## Create a Service Instance

First, you need to create an instance of the service.

{{% do %}}Use `cf marketplace` to view the details of the Redis service{{% /do %}}
{{% do %}}Use the CLI to create an instance of the `30mb` plan for Pivotal Web Services or the `free` plan on The Swisscom Application Cloud{{% /do %}}
{{% do %}}Use `cf help -a` to find command to list the services in your space{{% /do %}}

{{% checking %}}

Depending on your Cloud Foundry provider, you should see something similar to:

```sh
name    service      plan   bound apps   last operation
redis   rediscloud   30mb                create succeeded
```

{{% /checking %}}

## Bind a Service Instance

You need to bind your service instance to your application so it can be used.

{{% do %}}Push `07-shared-state/stateful-app` with the `--no-start` flag{{% /do %}}
{{% do %}}Use `cf bind-service` to bind your service instance to your app{{% /do %}}
{{% question %}}Does this work immediately? If not, why not? What commands can you use to find out more?{{% /question %}}
{{% do %}}Start your app so that it can pick up the environment variables{{% /do %}}
{{% question %}}What commands can you use to tell if you've bound the service instance to the correct app?{{% /question %}}

{{% checking %}}

If you hit the `/env` endpoint of your app, or run the command `cf env stateful-app`, you will see the `VCAP_SERVICES` environment variable that Cloud Foundry provides to your app. When a service is bound to your app, the service's details appear in this variable.

{{% /checking %}}

## Demonstrate Persistence

By storing state in a service we can restart apps without losing any data.

{{% do %}}Visit the app in a browser{{% /do %}}
{{% observe %}}Observe the number of requests this app instance has served, along with the overall total number of requests _all_ app instances have served{{% /observe %}}
{{% do %}}Restart the app and visit it in a browser again{{% /do %}}
{{% observe %}}Observe that the total number of requests is still stored in Redis, even though the app was restarted{{% /observe %}}

## Explore the Service Instance Lifecycle

Service instances can be shared by many apps, and can live longer than the apps that use them.

{{% do %}}Increase the number of instances of your app{{% /do %}}
{{% do %}}Visit your app to see the difference between different app instances serving requests and the overall hit count in their shared Redis service instance{{% /do %}}

Now we have many app instances Cloud Foundry is load-balancing between them, but they're all sharing the same Redis instance.

{{% question %}}What will happen when we unbind the app?{{% /question %}}
{{% do %}}Stop the app, and use `cf unbind-service` to unbind the service from the app{{% /do %}}
{{% do %}}Rebind the app, and start it{{% /do %}}
{{% observe %}}Observe that the Redis instance still holds the same state{{% /observe %}}

Unbinding did not delete data in Redis. It _did_ remove the credentials that our app was using to connect to Redis, but new ones were issued when we bound the app again.

{{% question %}}What will happen when we delete the service instance?{{% /question %}}
{{% question %}}Can you use `cf delete-service redis`?{{% /question %}}
{{% do %}}Do whatever is necessary to delete the service instance, and then create it again{{% /do %}}
{{% observe %}}When you start your app and visit it in a browser, you'll see that this is a new, clean Redis instance with no existing state{{% /observe %}}

## Beyond the Class

  * Use [SendGrid](https://sendgrid.com/) to send e-mails
  * Use [IronWorker](https://www.iron.io/worker/) for async tasks
  * Learn about [security groups](https://docs.cloudfoundry.org/adminguide/app-sec-groups.html)
  * Use a [manually created](https://docs.pivotal.io/pivotalcf/devguide/services/user-provided.html) IBM [Cloudant instance](https://cloudant.com/)
