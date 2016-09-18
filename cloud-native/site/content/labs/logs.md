---
date: 2016-04-19T19:21:15-06:00
title: Logs
---

In this exercise, you will view logs for your application and instrumentation for distributed tracing.

## CLI Logs

Cloud Foundry aggregates logs related to your application.  These include logs for components related to calls to your application.

The browser app has been instrumented using <a href="http://cloud.spring.io/spring-cloud-sleuth/" target="_blank">Spring Cloud Sleuth</a>.  This adds span information to your logs and can be easily hooked up to external systems for consumption.  We won't have time to deploy and configure an external service like Zipkin, but you can still view this instrumentation in the logs.

### Tailing Logs

* Use `cf logs` to tail logs for your browser application.
* Issue a few requests through the web interface.

You should see logs from the application but also the Router component of CF.

```sh
2016-05-20T12:50:59.07-0600 [RTR/5] <-- RTR is the Router.
```

Also note:

```sh
2016-05-20T12:52:11.07-0600 [APP/0]      OUT 2016-05-20 18:52:11.068  INFO [browser,92ca8a46b9903cdc,92ca8a46b9903cdc,true]
```

The section `[browser,92ca8a46b9903cdc,92ca8a46b9903cdc,true]` is instrumented by Spring Cloud Sleuth.  You are seeing [app-name, spanID, traceID].

This info is also available in the browser UI.

> Notice that cloud foundry automatically treats your application logs as streams and makes them easily accessible: http://12factor.net/logs


## Beyond the Class

* Stream Application Logs to <a href="https://papertrailapp.com" target="_blank">Papertrail</a> via <a href="https://docs.cloudfoundry.org/devguide/services/log-management-thirdparty-svc.html" target="_blank">these instructions.</a>
* Use PCF Metrics to view detailed information about your app: <a href="http://docs.run.pivotal.io/metrics/using.html" target="_blank">docs.run.pivotal.io/metrics/using.html</a>
* Deploy the Microservices Dashboard: <a href="https://github.com/ordina-jworks/microservices-dashboard" target="_blank">github.com/ordina-jworks/microservices-dashboard</a>
<!-- * Use <a href="http://start.spring.io" target="_blank">start.spring.io</a> to generate a zipkin server.  <a href="https://spring.io/blog/2016/02/15/distributed-tracing-with-spring-cloud-sleuth-and-spring-cloud-zipkin" target="_blank">Deploy it to CF </a> and hook it up to your microservices. -->
