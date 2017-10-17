---
date: 2016-04-19T19:21:15-06:00
title: Routes
---

In this exercise, you will use route mapping to perform a zero-downtime upgrade of an app.

## The Scenario

Imagine that you are running a web application, and all your customers use the address `www-yourname.cfapps.io`. This is the 'front door' address that must stay working once people start using your app.

We'll create this 'front door' route on Cloud Foundry, then push v1.0 of our application. We'll map the 'front door' route to our app. Once this is done, we can imagine that we have a successful online application that users are accessing via the 'front door' address.

At some point we will want to push an updated v1.1 of our app, find out if it works, and _only if it works_, start directing traffic from the 'front door' route to the new version of our app. When we've done that, we can stop routing traffic to the v1.0 app, and our zero-downtime upgrade will be complete.

## Create the New 'Front Door' Route

We need to create a route for the app we are going to deploy. This route will be used for _all_ versions of the app, so should stay the same even when the app is updated.

{{% do %}}Use `cf create-route` to a create a new route for your app, making sure the domain is `cfapps.io` if you are using Pivotal Web Services, or `scapp.io` if you are using The Swisscom Application Cloud{{% /do %}}

### Push v1.0

{{% do %}}Change to the `08-domains-routes/v1.0` directory and push the v1.0 app{{% /do %}}
{{% question %}}Does the push work? If not, why not? Can you fix this with a commandline argument?{{% /question %}}

### Map the 'Front Door' Route to the App

{{% do %}}Use `cf help -a` to figure out how to map your route above to this app{{% /do %}}
{{% do %}}Verify your app is accessible by accessing the 'front door' route you created{{% /do %}}

{{% checking %}}

You should be able to access your app on the route created above. You should also be able to see the route/url by looking at the app details.

{{% /checking %}}

### Push v1.1

Imagine that a new version of the app has been developed. We want to push it and check that it works in isolation.

{{% do %}}Push version 1.1 of the app from `08-domains-routes/v1.1` and assign it a random route{{% /do %}}
{{% do %}}Do not map your main route to it yet{{% /do %}}
{{% do %}}Validate you can access the app by accessing the random route{{% /do %}}

If this app was being deployed automatically, this is the point that smoke tests would be run against the new version. If the new version works on the random route, we can proceed to load-balance production traffic to it.

### Map the 'Front Door' Route to v1.1

{{% do %}}Use the CF CLI to map traffic hitting the main route you created to v1.1

{{% checking %}}

Check your work by accessing the main route multiple times. You should observe traffic being **balanced by Cloud Foundry across both instances**. You can also see the routes/urls by looking at the app details.

{{% /checking %}}

### Unmap the 'Front Door' Route from v1.0

We pushed the new version, smoke tested it on its own route, and then load balanced production traffic to both the new version and the old version. Now it is time to stop traffic going to the old version of the app.

{{% do %}}Use `cf help -a` to figure out how to stop sending traffic to v1.0{{% /do %}}
{{% question %}}Could you leave the v1.0 app running in case you need to roll-back?{{% /question %}}

{{% checking %}}

Check your work by accessing the main route multiple times.  You should observe traffic **only going to v1.1**.  You can also see the routes/urls by looking at the app details.

{{% /checking %}}

Congratulations! You successfully updated your running application to a new version with no downtime for users.


## Beyond the Class

  * Set up a custom [SSL certificate](http://www.selfsignedcertificate.com/)
  * Read about how libraries like [Togglz](https://www.togglz.org/) and [Spring Cloud Config](https://cloud.spring.io/spring-cloud-config/) can be used for application feature flags
  * Consider how you can ensure that API and schema changes are backwards-compatible when pushing new versions of apps
  * Delete all routes that are no longer used

```bash
$ cf delete-orphaned-routes
```
