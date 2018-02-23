---
date: 2018-02-16T19:21:15-03:00
title: Upgrading with BOSH
---

In this exercise, we will upgrade the stemcell used by MySQL.  You can also upgrade Cloud Foundry, but this will take longer as cf-deployment is far larger than MySQL.

## Updating the stemcell

Search https://bosh.io/stemcells for a newer **minor** version of the Ubuntu Trusty `bosh-warden-boshlite` stemcell. If there are no newer versions, use an older minor version to downgrade instead (the process is the same).

* Use BOSH to upload this stemcell to your director.
* Modify the MySQL deployment manifest with the new stemcell version.
* Deploy the change.

**Note:** This deploy can take a long time depending on how many packages need to be compiled.

**Note:** Releases may not work with stemcells significantly higher or lower than those specified by default in their manifest. Check the release's documentation for details.

**Note:** In non-BOSH Lite v2 environments, where there is more than one VM for each instance, deploying/upgrading with BOSH incurs zero downtime.

### Checking Your Work

Run the BOSH command that logs out the details of all of your deployments. If all went well, you should see the new stemcell is in use.

```sh
Using environment 'env' as client 'admin'

Name      Release(s)                   Stemcell(s)                                          Team
...
cf-mysql  cf-mysql/36.10.0             bosh-warden-boshlite-ubuntu-trusty-go_agent/3468.22  -        latest
          routing/0.154.0
```

**Note:** The same logic applies to changing the version of a *release* being used by one of your BOSH deployments. Simply upload the new release, change the manifest, and re-deploy.

**Congrats! You just upgraded a running cluster with two commands!**

## Beyond the Class

* Release notes
  * https://github.com/cloudfoundry/cf-deployment/releases
* Team trackers
  * https://github.com/cloudfoundry-community/cf-docs-contrib/wiki
  * See `Roadmap and Trackers` sidebar
* Automated deploy pipelines
  * concourse.ci
