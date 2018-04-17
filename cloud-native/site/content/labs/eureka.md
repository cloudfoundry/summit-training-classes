---
title: Service Discovery with Eureka
---

In this exercise, you will deploy a <a href="http://cloud.spring.io/spring-cloud-netflix/" target="_blank">Eureka</a> server.  You will also deploy a  new app `browser` that consumes data from our people service.

## About the App

The browser app uses Eureka to identify instances of our people service.  It uses the <a href="https://github.com/Netflix/ribbon" target="_blank">Ribbon</a> support built into <a href="http://cloud.spring.io/spring-cloud-netflix/" target="_blank">Spring Cloud Netflix</a> to provide client side load balancing.  The browser app also leverages <a href="https://github.com/Netflix/feign" target="_blank">Feign</a> support which makes writing HTTP clients in java simple.


## Deploying Eureka

First you need to deploy the Eureka server.  A prebuilt jar is provided here <a href="/resources/eureka.jar" target="_blank">eureka.jar</a>.

* Push the Eureka server to Cloud Foundry

```sh
cf push eureka -p /path/to/jar -m 750M --random-route -b java_buildpack
```

### Checking Your Work

You should see the eureka app running: `cf apps`

### Accessing the Eureka Console

Eureka has a built in web UI that shows information on the services registered. You can access it by going to the URL in your browser.  At this point, you won't see any services registered.

> NOTE: You can ignore the scary sounding error messages displayed in the UI.  This is a single instance deployment of Eureka, not meant for production.

### Creating a User Provided Service for Eureka

We will need to tell our applications where our Eureka server is.  There are many ways to do this, but for the purpose of this class, we will create a user provided service instance that can be bound to any client or service apps.

```sh
cf cups eureka-service -p '{"uri":"http://<YOUR_EUREKA>"}'
```

## Registering the People Service

The people service is written with a Eureka client which is disabled by default.  For the purpose of the class, we can use Spring Profiles to activate the Eureka client simply by setting an environment variable.

* Set SPRING_PROFILES_ACTIVE=cloud,eureka for your people service.

```sh
cf set-env people SPRING_PROFILES_ACTIVE cloud,eureka
```

* Use `cf bind-service` to bind the `eureka-service` you created above to your people service app.

* Use `cf restage` so the people service can pick up the changes.


### Checking Your Work

You should be able to see the environment variable.

```sh
cf env people
...

User-Provided:
SPRING_PROFILES_ACTIVE: cloud,eureka
```

You should also see the service instance:

```sh
cf services
...

name             service             plan                     bound apps   last operation
eureka-service   user-provided                                people
people-mysql     a9s-postgresql94    postgresql-single-small  people       create succeeded
```


### Viewing Your Service in Eureka

Within a few minutes of restaging, you should see your people service registered in the Eureka console.


## Pushing the Browser App

* Now, push the browser app with 512MB of memory.  The jar file is located here <a href="/resources/browser.jar" target="_blank">browser.jar</a>.

* Bind the Eureka service and restart the browser app.

### Checking Your Work

You should see the app.

```sh
cf apps
```

You should see the Eureka service bound to the browser app.

```sh
cf services
```

You should also see the browser app registered in the Eureka console.

### Using the browser app

The Browser app simply logs requests and results to the REST endpoints of the app.

* Open the browser app in your web browser
* In the `Explorer` text box, enter `/people` and hit `GO`

> The first request *might* fail (not gracefully).  This is because the browser service
is still fetching information from Eureka. In the next exercise, we will add resiliency so we can fail gracefully.

Let's try scaling our people service to 2 instances

```sh
cf scale
```

### What is happening?

When successful, the browser app is using Eureka to locate the people service instances,
then using Ribbon to load balance requests to those instances (because of quota limits, we only have 2 instance).
Should we add/remove instances of the people service, or should that service move, updates will happen automatically.

Congratulations! You have successfully used service discovery to consume a microservice.
