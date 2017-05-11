---
date: 2016-05-19T19:21:15-03:00
title: Upgrading
---

In this exercise, we will upgrade the stemcell used by Redis.  You can upgrade CF also, but this will take longer as the cf-release is far larger than Redis.

## Updating the stemcell

Explore https://bosh.io/stemcells for a previous version of the `bosh-warden-boshlite` stemcell.

* Use bosh to upload this stemcell to your director.
* Be sure your deployment is set to Redis.
* Modify the Redis deployment with the stemcell version.
* Deploy the changes.

> Note: Since we are using bosh-lite with single instances per vm type, a zero downtime deployment is not possible.

### Checking Your Work

If you run the following, you should see the new stemcell in use:

```sh
bosh deployments
```

**Congrats!  You just upgraded a running cluster with 2 commands!**

## Beyond the Class

* Release notes
  * https://github.com/cloudfoundry/cf-release/releases
* Team trackers
  * https://github.com/cloudfoundry-community/cf-docs-contrib/wiki
  * See `Roadmap and Trackers` sidebar
* Automated deploy pipelines
  * concourse.ci
