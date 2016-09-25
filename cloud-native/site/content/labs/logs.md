 n---
date: 2016-04-19T19:21:15-06:00
title: Logs
---

In this exercise, you will view logs for your application and instrumentation for distributed tracing.

## CLI Logs

Cloud Foundry aggregates logs related to your application.  These include logs for components related to calls to your application.

The browser app has been instrumented using <a href="http://cloud.spring.io/spring-cloud-static/spring-cloud-sleuth/1.0.9.RELEASE/" target="_blank">Spring Cloud Sleuth</a>.  This add span information to your logs and can be easily hooked up to external systems for consumption.

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

### Working with Zipkin

We have pushed four microservice applications that use Spring Cloud Slueth with an external [Zipkin](http://zipkin.io/) service.

In the previous section you have seen span and trace ids in the application logs lets see how zipkin works with this inromation.

Let's start a trace by sending a request to our Acme Finacial UI. <a href="/start" target="_blank">Start Trace!</a>

Now lets take a look at what it looks like in <a href="Zipkin" target="_blank">Zipkin</a>.

  - From the Zipkin UI make sure you are on the `Find a trace` tab.
  - Select acme-financial-ui
    - then select Find Traces
  - Select a trace.

Let's Digest some of this information.

![zipkin-trace](/img/zipkin-trace.png)

From the trace, take note of the number of spans made, the number of services called, and how long it took for the trace to finish.

Lets take a look at the Spans.

![spans](/img/spans.png)


After we send our initial request to the ui what methods are called?

What happens in the back-office service?

## Understanding the trace hierarchy

In your browser Navigate to the<a href="/dependency" target="_blank">dependencies</a> or your traces.

Lets check out the hierachy.

When the initial request is sent to the **UI** a  call to the **back-office-microservice** is made which then gets data from the **account-microservice** and the **customer-mircroservice**.

![dependencies](/img/dependencies.png  )


## Beyond the Class

* Stream Application Logs to <a href="https://papertrailapp.com" target="_blank">Papertrail</a> via <a href="https://docs.cloudfoundry.org/devguide/services/log-management-thirdparty-svc.html" target="_blank">these instructions.</a>
* Use PCF Metrics to view detailed information about your app: <a href="http://docs.run.pivotal.io/metrics/using.html" target="_blank">docs.run.pivotal.io/metrics/using.html</a>
* Deploy the Microservices Dashboard: <a href="https://github.com/ordina-jworks/microservices-dashboard" target="_blank">github.com/ordina-jworks/microservices-dashboard</a>
<!-- * Use <a href="http://start.spring.io" target="_blank">start.spring.io</a> to generate a zipkin server.  <a href="https://spring.io/blog/2016/02/15/distributed-tracing-with-spring-cloud-sleuth-and-spring-cloud-zipkin" target="_blank">Deploy it to CF </a> and hook it up to your microservices. -->
