---
title: Setup
---

## Swisscom Application Cloud

We will use Swisscom Application Cloud for this class.

* If you don't have an account, sign up now at: <a href="https://pre-cf-summit-registration.scapp.io/" target="_blank">pre-cf-summit-registration.scapp.io/</a>
* You will also need the Cloud Foundry command line interface: <a href="https://github.com/cloudfoundry/cli#downloads" target="_blank">github.com/cloudfoundry/cli#downloads</a>

If you already have the CLI, be sure you have the most recent version.

```sh
  cf --version
  cf version 6.26.0+9c9a261fd.2017-04-06
```
If your version is not more recent that this one, please install the latest.

### Checking Your Work

Be sure you have correctly installed the cli.  From a terminal window/command prompt:

```sh
cf
```

You should see the self documenting help text.  This will be very useful as you go through the class.


## CF Help

If you checked your work, you noticed the CF cli is self documenting.  You can run `cf help` at any time to see a list of commands.  You can also run `cf <SOME_COMMAND> --help` to see the details for a specific command.

### Login & Target

Use `cf login` to target and login to Pivotal Web Services.

> If you are new to PWS, you will notice you are automatically directed to your org and the 'development' space.

#### Checking Your Work

You should see output similar to:

```sh
API endpoint:   https://api.appcloud.swisscom.com (API version: 2.80.0)
User:           user@gmail.com
Org:            cfsummit2017
Space:          dev
```

Alternatively, you can check where you are logged in and targeted at anytime using `cf target`.
