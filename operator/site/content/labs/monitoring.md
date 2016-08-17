---
date: 2016-05-19T11:56:15-03:00
title: Monitoring
---

The Loggregator Firehose plugin for the Cloud Foundry Command Line Interface (cf CLI) allows Cloud Foundry (CF) administrators access to the output of the Loggregator Firehose, which includes logs and metrics from all CF components.

In this exercise you will install the plugin to gain access to all logs and metrics.  This exercise was selected as it does not require external tools.

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

The plugin added a command to your cf cli.  If you run the following, you can see the firehose:

```sh
cf nozzle --debug
```

## Beyond the Class

* github.com/logsearch/logsearch-for-cloudfoundry
* logsearch.io
* https://github.com/cloudfoundry-community/bosh-gen
* https://github.com/pivotal-cf-experimental/datadog-config-oss
