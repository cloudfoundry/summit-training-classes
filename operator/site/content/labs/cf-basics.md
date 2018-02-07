---
date: 2016-04-19T19:21:15-06:00
title: CF Basics
---

In this exercise, we will log in to our Cloud Foundry Foundation that we just deployed, create an org, space and user, and assign the user to a role so they can deploy an app.  We'll finish up by deploying an application.


## Getting Started: Cloud Foundry CLI

### Installing

Cloud Foundry has its own command line interface. If it is not already installed in your environment, you can download from here. [https://github.com/cloudfoundry/cli#downloads](https://github.com/cloudfoundry/cli#downloads).

The CLI is self documenting. You can get the list of commands by running:

```sh
  cf help -a
```

You can also get details on a specific command with:

```sh
  cf help <command>
```


### Logging in

To start a session with CF, you need to login.  You do this by targeting the `api` endpoint of the cloud foundry installation.  The url should be something like `https://api.<system_domain>`. You passed through `bosh-lite.com` as the variable 'system_domain' (referred to in numerous sections of the Cloud Foundry deployment manifest) when you ran `bosh deploy` in the first lab.

Verify that:

- running `host bosh-lite.com` resolves to the address `10.244.0.34`

Run this to get the cf admin password:

```sh
bosh interpolate --path /cf_admin_password ~/deployments/vbox/deployment-vars.yml
```

Now let's log in using the password from the previous command and the username `admin`

```sh
cf login -a https://api.bosh-lite.com --skip-ssl-validation
```

*Note: We are skipping ssl validation because we are using self-signed certificates.*

### Checking Your Work

If you run the following, you should see that you are logged in to your cloud foundry installation.

```sh
$ cf target

api endpoint:   https://api.bosh-lite.com
api version:    2.102.0
user:           admin
org:            system
No space targeted, use 'cf target -s SPACE'
```

## Creating an Organization

The next step is to add an organization.

* Use `cf help -a` to find the right command to create an organization.  You can name the organization anything you want.

There are also `cf` commands that allow you to list all the organizations in your installation or view the details on a specific organization.  Try them.

Once you create an organization, you have to target it so that the rest of the commands we run in this exercise pertain to that organization.

* Use `cf help -a` to target your new organization.

### Checking Your Work

If you run the following, you should see that you are logged in to your cloud foundry installation, and targeted to your organization.

```sh
$ cf target

api endpoint:   https://api.bosh-lite.com
api version:    2.102.0
user:           admin
org:            example-org
```

## Creating a Space

The next step is to add a space to your organization.

* Use `cf help -a` to find the right command to create a space inside your organization.  Name the space `dev`.

There are also `cf` commands that allow you to list all the spaces in your organization or view the details on a specific space.  Try them.

Once you create a space, you have to be sure to target it so that the rest of the commands we run in this exercise pertain to that domain.

* Use `cf help -a` to target your new space.

### Checking Your Work

If you run the following, you should see that you are logged in to your cloud foundry installation, and targeted to your organization and space.

```sh
$ cf target

api endpoint:   https://api.bosh-lite.com
api version:    2.102.0
user:           admin
org:            example-org
space:          dev
```

## Adding a new User

The next step is to create a user and add them to the correct role.

### Creating a new User

* Use `cf help -a` to create a new user.

### Assign your User to the SpaceDeveloper Role

* User `cf help -a` to assign your new user the space developer role in your `dev` space.

### Checking Your Work

If you run the following, you should see your new user assigned to the `SpaceDeveloper` role:

```sh
$ cf space-users <org> <space>

Getting users in org example-org / space dev as admin

SPACE MANAGER
  admin

SPACE DEVELOPER
  admin
  test-user

SPACE AUDITOR
  No SPACE AUDITOR found
```

## Pushing your First App

Now it is time to push your first app to Cloud Foundry!

* Use `cf login` to log in as the user you just created.  Make sure you also target your organization and space.

* Now push a sample app:

```bash
cd ~/workspace
git clone https://github.com/Altoros/cf-example-sinatra
cd cf-example-sinatra
cf push myapp
```

### Logs & Events

CF provides a large number of commands to help you manage your apps.  Among them is the ability to view app details, recent events and logs.

```sh
cf app myapp
cf events myapp
cf logs myapp --recent
```

### Checking Your Work

If you run the following, you should see your app running in your space:

```sh
cf apps
```

## Beyond the Class

* CF_TRACE=true cf ...
* cf curl
   * https://blog.starkandwayne.com/2015/03/20/admin-scripting-your-way-around-cloud-foundry/
   * http://apidocs.cloudfoundry.org/
* cf buildpacks
   * https://docs.cloudfoundry.org/adminguide/buildpacks.html
* CF CLI plugins
   * https://docs.cloudfoundry.org/devguide/installcf/use-cli-plugins.html
