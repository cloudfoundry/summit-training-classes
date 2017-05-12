---
date: 2016-05-19T11:56:15-03:00
title: Monitoring
---

The **CF Top** plugin for the Cloud Foundry Command Line Interface (cf CLI) allows users access to the output of the Loggregator Firehose to view metrics based on privileges. Users with administrative privilege can view routing and application metrics from all CF applications while non-administrative users will only see routing and application metrics within the orgs and spaces they have been assigned.

In this exercise you will install the CF Top plugin to gain access to all metrics. You will also modify the user you created in a prior lab to be able to successfully run the plugin.  This exercise was selected as it does not require external tools.

## Installing the Plugin

You may need to add the plugin repository to your cf CLI, although it is possible that is already there.

```sh
cf add-plugin-repo CF-Community http://plugins.cloudfoundry.org
```

Now you can install the plugin:

```sh
cf install-plugin "top" -r CF-Community
```

## Viewing the Firehose Metrics via CF Top

The plugin added a command to your cf cli.  Run the following as the admin user to see the firehose output:

```sh
cf top
```

Now run the plugin as the user you created in a prior lab. What do you see?

## Assign User Admin Scopes

Running the plugin as a non-administrative user resulted in a limited view of metrics. This was due to the user not having the appropriate permissions to run the command. Permissions within CF are broken into two categories: User or Administrator/Operator.

User level permissions are governed by setting **Roles** using the CF CLI. Examples of user roles are `SpaceDeveloper`, `OrgManager`.

Administrator/Operator level permissions are governed by setting **Scopes** using the UAA CLI (uaac). Examples of these scopes include `cloud_controller.admin` and `doppler.firehose`.

For a complete view of all the metrics, the user requires the operator level scopes of `cloud_controller.admin` and `doppler.firehose`. Let's go assign them.

Install `uaac`
```sh
sudo gem install cf-uaac --no-ri --no-rdoc
```

Target Cloud Foundry's UAA endpoint.
```sh
uaac target https://uaa.bosh-lite.com --skip-ssl-validation
```

Obtain a token by using the credentials from `cf.yml` found under `properties.uaa.admin.client_seret`
```sh
uaac token client get admin
```
Assign the scopes to the user created in a prior lab. Use `uaac member add -h` for guidance.

Now login to CF with the above user. You should be able to successfully run `cf top`.


## Beyond the Class

* https://github.com/ECSTeam/cloudfoundry-top-plugin
* http://docs.cloudfoundry.org/adminguide/cli-user-management.html
* http://docs.cloudfoundry.org/adminguide/uaa-user-management.html
* github.com/logsearch/logsearch-for-cloudfoundry
* logsearch.io
* https://github.com/cloudfoundry-community/bosh-gen
* https://github.com/pivotal-cf-experimental/datadog-config-oss
