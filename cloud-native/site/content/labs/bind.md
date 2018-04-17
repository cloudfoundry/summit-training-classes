---
title: Binding and Environment Variables
---

In the last section, we lost all our data when we restarted our app.  In this section, we will fix that.

## Creating a PostgreSQL instance

We will create an instance of postgresql and bind it to our app, thereby removing state from memory.

* Use `cf marketplace` to view the available services and plans.
* Use `cf create-service` to create a PostgreSQL service instance `a9s-postgresql` and select the `postgresql-single-small` plan.

### Checking Your Work

You should be able to see your service instance:

```sh
cf services
...

name        service          plan                      bound apps   last operation
people-db   a9s-postgresql94 postgresql-single-small                create succeeded
```

## Binding to Your App

You need to bind your service instance to your application so that is can be used.

* Use `cf bind-service` to bind your service instance to your application.
* Restage your app so that it uses the new service: `cf restage`.

### Checking Your Work

You should be able to see your service instance bound to your app:

```sh
cf services

...
name        service          plan                      bound apps   last operation
people-db   a9s-postgresql94 postgresql-single-small   people       create succeeded
```

## Testing Statelessness

At this point, you should be able to put data into your service that lands in the external PostgreSQL service.

```sh
curl -X POST -H "Content-Type:application/json" -d '{"firstName":"Jedediah,", "lastName":"Leland", "company":"The Inquirer"}' http://people-<RANDOM_ROUTE>.de.a9sapp.eu/people
```

* Restart your app.
* You should still see the data:

```sh
curl http://people-<RANDOM_ROUTE>.de.a9sapp.eu/people
...

{
  "_embedded" : {
    "people" : [ {
      "firstName" : "Jedediah",
      "lastName" : "Leland",
      "company" : "The Inquirer",
      "_links" : {
        "self" : {
          "href" : "http://people-<RANDOM_ROUTE>.de.a9sapp.eu/people/2"
        },
        "person" : {
          "href" : "http://people-<RANDOM_ROUTE>.de.a9sapp.eu/people/2"
        }
      }
    } ]
  },
  "_links" : {
    "self" : {
      "href" : "http://people-<RANDOM_ROUTE>.de.a9sapp.eu/people"
    },
    "profile" : {
      "href" : "http://people-<RANDOM_ROUTE>.de.a9sapp.eu/profile/people"
    },
    "search" : {
      "href" : "http://people-<RANDOM_ROUTE>.de.a9sapp.eu/people/search"
    }
  },
  "page" : {
    "size" : 20,
    "totalElements" : 1,
    "totalPages" : 1,
    "number" : 0
  }
}
```

> Congrats!  You now have a stateless app: <a href="http://12factor.net/processes" target="_blank">12factor.net/processes</a>

## How does it work?

Run the following:

```sh
cf env people
```

This will print the environment variables for your application.  Look for a `System-Provided` variable called `VCAP_SERVICES`.  You should see the service credentials for your PostgreSQL service.  Note:

> * Cloud Foundry leverage the environment variables: <a href="http://12factor.net/config" target="_blank">12factor.net/config</a>
> * Cloud Foundry treats services as attached resources: <a href="http://12factor.net/backing-services" target="_blank">12factor.net/backing-services</a>


## Scale Out

By moving the state for your application into an external service, you can now scale out your application horizontally.

* Use `cf scale` to scale your app to 2 instances.

> Notice that you can scale by adding instances: <a href="http://12factor.net/concurrency" target="_blank">12factor.net/concurrency</a>

### Checking your Work

You should see 2 instances:

```sh
cf app people
...

0   running   2016-05-17 09:53:40 AM   0.1%     376.8M of 750M   153.7M of 512M
1   running   2016-05-17 10:01:35 AM   0.0%     232.1M of 750M   153.7M of 512M
```

## Scale Down

* Use `cf scale` to reduce your app back to 1 instance.

> Notice that you can start quickly and dispose of unneeded instances gracefully: <a href="http://12factor.net/disposability" target="_blank">12factor.net/disposability</a>

## Beyond the Class

* CF also allows you to manipulate environment variables or create your own: <a href="https://docs.cloudfoundry.org/devguide/deploy-apps/environment-variable.html" target="_blank">docs.run.pivotal.io/devguide/deploy-apps/environment-variable.html</a>.  Write an app that prints out all environment variables.
* With CF, you can create instances of services that point to existing endpoints with existing credentials: <a href="http://docs.cloudfoundry.org/devguide/services/user-provided.html" target="_blank">docs.cloudfoundry.org/devguide/services/user-provided.html</a>.  Create a User Provided Service that points to a DB and bind it to an app.
