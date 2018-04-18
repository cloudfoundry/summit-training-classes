---
title: Setup
---

## anynines Public PaaS

We will use anynines public PaaS for this class.

* Once you provide us with your e-mail address, we're going to invite you to <a href="https://paas.anynines.com/" target="_blank">paas.anynines.com/</a>
* You will also need the Cloud Foundry command line interface: <a href="https://github.com/cloudfoundry/cli#downloads" target="_blank">github.com/cloudfoundry/cli#downloads</a>

If you already have the CLI, be sure you have a recent version.

```sh
  cf --version
  cf version 6.35.2+88a03e995.2018-03-15
```
If your version is not more recent that this one, please install <a href="https://docs.cloudfoundry.org/cf-cli/install-go-cli.html" target="_blank">the latest</a>.

### Checking Your Work

Be sure you have correctly installed the cli. From a terminal window/command prompt:

```sh
cf
```

You should see the self-documenting help text. This will be very useful as you go through the class.


## CF Help

If you checked your work, you noticed the CF CLI is self-documenting.  You can run `cf help` at any time to see a list of commands. You can also run `cf <SOME_COMMAND> --help` to see the details for a specific command.

### Login & Target

Use `cf login` to target and login to anynines public PaaS.

> You will notice that three spaces has been created for the organisation we're going to use today (boston2018): production, staging, test.

#### Checking Your Work

You should see output similar to:

```sh
cf login
API endpoint: https://api.de.a9s.eu

Email> owolf+cftraining@anynines.com

Password>
Authenticating...
OK

Targeted org boston2018
```

Then create your own space with:

```sh
cf create-space <YOUR-NAME>
```

