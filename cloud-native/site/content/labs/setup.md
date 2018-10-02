---
title: Setup
---

## anynines Public PaaS

We will use anynines public PaaS for this class.

* If you don't have an account, sign up now at: <a href="https://paas.anynines.com/" target="_blank">paas.anynines.com/</a>
* You will also need the Cloud Foundry command line interface: <a href="https://github.com/cloudfoundry/cli#downloads" target="_blank">github.com/cloudfoundry/cli#downloads</a>

If you already have the CLI, be sure you have the most recent version.

```sh
  cf --version
  cf version 6.35.2+88a03e995.2018-03-15
```
If your version is not more recent that this one, please install <a href="https://docs.cloudfoundry.org/cf-cli/install-go-cli.html" target="_blank">the latest</a>.

### Checking Your Work

Be sure you have correctly installed the cli.  From a terminal window/command prompt:

```sh
cf
```

You should see the self documenting help text.  This will be very useful as you go through the class.


## CF Help

If you checked your work, you noticed the CF cli is self documenting.  You can run `cf help` at any time to see a list of commands.  You can also run `cf <SOME_COMMAND> --help` to see the details for a specific command.

### Login & Target

Use `cf login` to target and login to anynines public PaaS.

> If you are new to anynines public PaaS, you will notice that three spaces has been created for you (production, development, test).

#### Checking Your Work

You should see output similar to:

```sh
cf login
API endpoint: https://api.aws.ie.a9s.eu

Email> owolf+cftraining@anynines.com

Password>
Authenticating...
OK

Targeted org owolf+cftraining_anynines_com

Select a space (or press enter to skip):
1. production
2. staging
3. test

Space> 3
Targeted space test

API endpoint:   https://api.aws.ie.a9s.eu (API version: 2.100.0)
User:           owolf+cftraining@anynines.com
Org:            owolf+cftraining_anynines_com
Space:          test
```

Alternatively, you can check where you are logged in and targeted at anytime using `cf target`.
