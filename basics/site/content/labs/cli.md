---
date: 2016-04-19T19:21:15-06:00
title: CLI Basics
---

In this section we will cover the basics of installing and using the CF command line interface (cli).

## Installing

* Select and install the appropriate installer for your laptop: [github.com/cloudfoundry/cli](https://github.com/cloudfoundry/cli#downloads)

#### Checking Your Work

Open a terminal/command prompt and type the following:

```sh
cf
```

You should see an output similar to the following:

```sh
NAME:
   cf - A command line tool to interact with Cloud Foundry

USAGE:
   [environment variables] cf [global options] command [arguments...
...
```

Notice that the CF cli is self documenting.  You can type any command with `--help` to see details.  Typing `cf` only lists all available commands.

```sh
cf <some-command> --help
```

## Logging in

You can use the CLI to log into any cloud foundry you have an account in.

* Use `cf help` to find out how to login to Pivotal Web Services

The API endpoint you need is `api.run.pivotal.io`.

```sh
cf login --help
```

#### Checking Your Work

You can see where you are logged in using the following:

```sh
cf target
```

* _Are you logged into Pivotal Web Services?_
* _What org and space are you targeting?_

## Targeting Orgs & Spaces

You can change the org and space you are targeting without logging in again.

```bash
$ cf target -o ORG -s SPACE
```

## Beyond the Class

  * Add the person next to you to your PWS space
  * Create an account on [IBM Bluemix](https://console.ng.bluemix.net/registration/)
  * Use [Targets cf cli plugin](https://github.com/guidowb/cf-targets-plugin) with PWS &amp; Bluemix
  * Submit a localisation pull request to [cf cli](https://github.com/cloudfoundry/cli/blob/master/cf/i18n/README-i18n.md)
