---
date: 2016-05-19T19:21:15-03:00
title: Cloud Config 
---

In this exercise, we will convert the redis deployment manifest to a v2 manifest. To do so, we will need to create a cloud config and upload this to the Director.

## Create and Upload Cloud Config


* Create a cloud-config.yml file using the format below. See http://bosh.io/docs/cloud-config.html for a reference.

```sh
---
azs: <-- Not needed for a bosh-lite install
  ...
vm_types:
  ...
disk_types:
  ...
compilation:
  ...
networks: <-- The entire "networks" block from the redis deployment manifest can be used here
  ...
```

* Use bosh to upload the cloud config to the director

## Convert a v1 manifest to a v2 manifest

Convert the redis deployment manifest to the v2 manifest format.

* A v2 deployment manifest requires the following blocks. See http://bosh.io/docs/manifest-v2.html for block requirements.

```sh
---
name:
director_uuid:
releases:
  ...
stemcells: <-- Minor changes. See above bosh.io link for requirements
  ...
instance_groups: <--  "jobs" block in v1 manifest renamed to "instance_groups" in v2 manifest
  ...
  vm_type: <-- VM type to use. Specified in cloud-config
  stemcell: <-- alias specified in the stemcells block above
  jobs: <-- "templates" section in v1 manifest renamed to "jobs" in v2 manifest
    ...
properties:
  ...
update:
  ...

# The "compilation" block is removed from a v2 manifest as it is now in the cloud-config
# The "resource_pools" block is removed in a v2 manifest and replaced by specifying "vm_types" in the cloud-config
```

## Deploy V2 Manifest
* Use bosh to deploy redis using the v2 manifest

## Beyond the Class

* bosh cli v2
  * http://bosh.io/docs/cli-v2.html 
* BOSH Runtime Config 
  * http://bosh.io/docs/runtime-config.html
* BOSH CPI Config 
  * http://bosh.io/docs/cpi-config.html
