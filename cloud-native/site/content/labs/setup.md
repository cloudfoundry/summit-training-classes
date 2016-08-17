---
title: Setup
---

## Pivotal Web Services

We will use Pivotal Web Services for this class.  

* If you don't have an account, sign up now at: <a href="https://try.run.pivotal.io/homepage" target="_blank">try.run.pivotal.io/homepage</a>
* You will also need the Cloud Foundry command line interface: <a href="https://console.run.pivotal.io/tools" target="_blank">console.run.pivotal.io/tools</a>

If you already have the CLI, be sure you have the same recent version above.

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
API endpoint:   https://api.run.pivotal.io (API version: 2.56.0)   
User:           sgreenberg@pivotal.io   
Org:            Pivotal-Enablement   
Space:          development
```

Alternatively, you can check where you are logged in and targeted at anytime using `cf target`.
