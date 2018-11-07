---
date: 2016-04-19T19:21:15-06:00
title: CLI Basics
---

In this section we will cover the basics of installing and using the CF command line interface (CLI).

## Install the CLI

{{% do %}}Select and install the appropriate installer for your laptop: [github.com/cloudfoundry/cli](https://github.com/cloudfoundry/cli#downloads){{% /do %}}
{{% do %}}After the installer has finished, run the `cf` command{{% /do %}}

{{% checking %}}

You should see output similar to the following:

```sh
NAME:
   cf - A command line tool to interact with Cloud Foundry

USAGE:
   [environment variables] cf [global options] command [arguments...
...
```

{{% /checking %}}

Notice that the CF CLI is self documenting.  You can type any command with `--help` to see details.  Typing `cf` only lists all available commands.

```sh
cf <some-command> --help
```

## Log In

You can use the CLI to log into any Cloud Foundry you have an account in.

{{% do %}}Use `cf help -a` to find out how to login to Pivotal Web Services/The Swisscom Application Cloud/anynines public PaaS. The API endpoint you need for Pivotal Web Services is `api.run.pivotal.io`. The anynines public PaaS endpoint is `https://api.de.a9s.eu`. You can find the URL to use for The Swisscom Application Cloud by clicking on 'Settings' when looking at your space in the Swisscom UI. {{% /do %}}
{{% question %}}Are you logged into Pivotal Web Services/The Swisscom Application Cloud/anynines public PaaS?{{% /question %}}
{{% question %}}What org and space are you targeting?{{% /question %}}

{{% checking %}}

You can see where you are logged in using `cf target`. You should see something similar to:

```sh
API endpoint:   https://api.endpoint.io
API version:    2.78.0
User:           me@example.com
Org:            my-org
Space:          my-space
```

{{% /checking %}}

## Target Orgs & Spaces

You can change the org and space you are targeting without logging in again.

```bash
$ cf target -o ORG -s SPACE
```

## Beyond the Class

  * Add the person next to you to your Cloud Foundry space
  * Create an account on [IBM Cloud](https://console.ng.bluemix.net/registration/)
  * Use [Targets CF CLI plugin](https://github.com/guidowb/cf-targets-plugin)
  * Submit a localisation pull request to [CF CLI](https://github.com/cloudfoundry/cli/blob/master/cf/i18n/README-i18n.md)
