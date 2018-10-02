---
title: Circuit Breakers with Hystrix
---

Currently, our browser app does not fail gracefully when an issue occurs while communicating with the people service. Let's fix that.


## Simulating Failure

We can simulate failure by stopping the people service app:

```sh
cf stop people
```

Now if you access your browser app and hit `Go` on the `/people` endpoint, you should see a 500 error.

```sh
{
  "timestamp": 1463694694293,
  "status": 500,
  "error": "Internal Server Error",
  "exception": "com.netflix.hystrix.exception.HystrixRuntimeException",
  "message": "getPeople failed and no fallback available.",
  "path": "/people"
}
```


## Enabling Hystrix

Our browser app actually has Hystrix built in, but currently disabled. You can enable Hystrix by setting the `SPRING_PROFILES_ACTIVE` environment variable to `hystrix`.

* `cf set-env browser SPRING_PROFILES_ACTIVE hystrix`
* `cf restart browser`

> **Don't** write your apps this way. You should always be using Hystrix in your Spring code, but we do this for the purpose of teaching.


### Checking Your Work

You should see the environment variable:

```sh
cf env browser
```


### Seeing Hystrix in Action

Now if you access your browser app and hit `Go` on the `/people` endpoint, you should see a graceful failure:

```sh
Response Headers

200 OK

Date: Thu, 19 May 2016 22:17:46 GMT
Server: Apache-Coyote/1.1
X-B3-Traceid: e301c4c07b2ede89
Content-Type: application/hal+json;charset=UTF-8
X-Vcap-Request-Id: 44f30698-4e9b-4e8a-6e05-e6c1feada10d
X-B3-Spanid: e301c4c07b2ede89
X-B3-Sampled: 1
Connection: keep-alive
Content-Length: 2
X-Application-Context: browser:hystrix,cloud:0

...

Properties
{}
```

In this case, the fallback method is very simple. It returns an empty array. The fallback could be much more useful as well.


### Restoring...

Now, start your people app. Access the browser a few times again until service is restored.
