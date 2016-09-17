---
title: Pushing a data service
---

In this exercise, you will push a restful data microservice.

> Note: Currently this microservice does not adhere to all of the 12 factor app principles.

## The App

The app is a very simple Spring Data Rest application. You can download the jar file here: <a href="/resources/people.jar" target="_blank">people.jar</a>.

If you are comfortable with git and gradle, you can also clone the source here <a href="https://github.com/spgreenberg/people" target="_blank">github.com/spgreenberg/people</a> and build it yourself.


### Push

Use `cf push` to deploy the application.  You should:

* Create 1 instance of the app
* Allocate 750M of memory
* Use the -p flag to point to the jar file
* Use --random-route to ensure no collisions with other students

```sh
cf push people --random-route -b java_buildpack -p ...
```

#### Checking Your Work

Make sure your app deployed correctly:

```sh
cf apps
...

name     requested state   instances   memory   disk   urls
people   started           1/1         750M     1G     people-<RANDOM_ROUTE>.cfapps.io
```

The app also has an endpoint called `/people`.  You should also be able to curl it:

> On Windows, if you don't have curl you can get it from here: <a href="https://curl.haxx.se/download.html" target="_blank">curl.haxx.se/download.html</a>

```sh
curl people-<RANDOM_ROUTE>.cfapps.io/people
...

{
  "_embedded" : {
    "people" : [ ]
  },
  "_links" : {
    "self" : {
      "href" : "http://people-<RANDOM_ROUTE>.cfapps.io/people"
    },
    "profile" : {
      "href" : "http://people-<RANDOM_ROUTE>.cfapps.io/profile/people"
    },
    "search" : {
      "href" : "http://people-<RANDOM_ROUTE>.cfapps.io/people/search"
    }
  },
  "page" : {
    "size" : 20,
    "totalElements" : 0,
    "totalPages" : 0,
    "number" : 0
  }
}
```

## Adding Data

You can add data by issuing a curl request to POST to the people endpoint.  Be sure to replace your information and URL below:

```sh
curl -X POST -H "Content-Type:application/json" -d '{"firstName":"Steve", "lastName":"Greenberg", "company":"Pivotal"}' http://people-<RANDOM_ROUTE>.cfapps.io/people
```

Now, you should see the data:

```sh
curl http://people-<RANDOM_ROUTE>.cfapps.io/people
...

{
  "_embedded" : {
    "people" : [ {
      "firstName" : "Steve",
      "lastName" : "Greenberg",
      "company" : "Pivotal",
      "_links" : {
        "self" : {
          "href" : "http://people-<RANDOM_ROUTE>.cfapps.io/people/1"
        },
        "person" : {
          "href" : "http://people-<RANDOM_ROUTE>.cfapps.io/people/1"
        }
      }
    } ]
  },
  "_links" : {
    "self" : {
      "href" : "http://people-<RANDOM_ROUTE>.cfapps.io/people"
    },
    "profile" : {
      "href" : "http://people-<RANDOM_ROUTE>.cfapps.io/profile/people"
    },
    "search" : {
      "href" : "http://people-<RANDOM_ROUTE>.cfapps.io/people/search"
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

### Restart your App

* Now restart your app with `cf restart`.
* Curl your app again:

```sh
curl http://people-<RANDOM_ROUTE>.cfapps.io/people
```

What happened?  Why?  Not very durable, right?  We will correct this in the next exercise.


## Beyond the Class

* What aspects of 12 factor have you already experienced?  <a href="http://12factor.net" target="_blank">12factor.net</a>
