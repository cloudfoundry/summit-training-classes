---
date: 2016-09-19T14:00:15-03:00
title: Prepare AWS to deploy BOSH Lite v2
---

This step-by-step guide shows how to configure an AWS account to deploy BOSH Lite v2.



To verify that worked, run `bosh env`. You should see output like this:

```sh
Using environment ‘34.235.181.111’ as client ‘admin’

Name      bosh-1
UUID      e1944296-f3ef-4d64-a11e-a4e45b50ad80
Version   264.7.0 (00000000)
CPI       warden_cpi
Features  compiled_package_cache: disabled
          config_server: disabled
          dns: disabled
          snapshots: disabled
User      admin

Succeeded
```
