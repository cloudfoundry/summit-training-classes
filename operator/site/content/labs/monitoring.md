---
date: 2016-05-19T11:56:15-03:00
title: Monitoring
---

The Loggregator Firehose plugin for the Cloud Foundry Command Line Interface (cf CLI) allows Cloud Foundry (CF) administrators access to the output of the Loggregator Firehose, which includes logs and metrics from all CF components.

Connecting to the Loggregator Firehose requires either running the nozzle plugin as the default admin user or as a user which has been assigned additional admin scopes. 

In this exercise you will install the plugin to gain access to all logs and metrics. You will also modify the user you created in a prior lab to be able to successfully run the nozzle plugin.  This exercise was selected as it does not require external tools.

## Installing the Plugin

You may need to add the plugin repository to your cf CLI, although it is possible that is already there.

```sh
cf add-plugin-repo CF-Community http://plugins.cloudfoundry.org
```

Now you can install the plugin:

```sh
cf install-plugin "Firehose Plugin" -r CF-Community
```

## Viewing the Firehose

The plugin added a command to your cf cli.  Run the following as the admin user to see the firehose output:

```sh
cf nozzle --debug
```

Now run the nozzle as the user you created in a prior lab. What do you see?

## Assign User Admin Scopes

The above command resulted in an authorization error. This was due to the user not having the appropriate permissions to run the command. Permissions within CF are broken into two categories: User or Administrator/Operator.

User level permissions are governed by setting **Roles** using the CF CLI. Examples of user roles are `SpaceDeveloper`, `OrgManager`. 

Administrator/Operator level permissions are governed by setting **Scopes** using the UAA CLI (uaac). Examples of these scopes include `cloud_controller.admin` and `doppler.firehose`.

To remedy the above authorization failure, the user requires the operator level scopes of `cloud_controller.admin` and `doppler.firehose`. Let's go assign them.

Install `uaac`
```sh
gem install cf-uaac --no-ri --no-rdoc
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

Now login to CF with the above user. You should be able to successfully run `nozzle --debug`.


## Beyond the Class

* http://docs.cloudfoundry.org/adminguide/cli-user-management.html
* http://docs.cloudfoundry.org/adminguide/uaa-user-management.html
* github.com/logsearch/logsearch-for-cloudfoundry
* logsearch.io
* https://github.com/cloudfoundry-community/bosh-gen
* https://github.com/pivotal-cf-experimental/datadog-config-oss
