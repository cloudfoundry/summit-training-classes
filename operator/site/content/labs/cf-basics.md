---
date: 2018-02-16T19:21:15-03:00
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

To start using Cloud Foundry, you need to login by targeting the `api` endpoint created in your installation.

During the deployment process, BOSH generated the file `deployment-vars.yml`. This file contains admin credentials that you'll need to use the Cloud Foundry CLI. Run the following to get your admin password:

```sh
bosh interpolate --path /cf_admin_password $path_to_your_deployment_vars_yml_file
```

Let's login using our endpoint, which will be structured as below - using the `system_domain` variable we passed through when deploying Cloud Foundry earlier. After running the command, you will be prompted for your username (`admin`) and password.

```sh
cf login -a https://api.$SYSTEM_DOMAIN --skip-ssl-validation
```

**Note:** We are skipping SSL validation because we are using self-signed certificates.

### Checking Your Work

Running `cf target` should produce output similar to the following, which will confirm that you're now logged in:

```sh
$ cf target

api endpoint:   https://api.bosh-lite.com
api version:    2.102.0
user:           admin
org:            system
No space targeted, use 'cf target -s SPACE'
```

## Creating an Organization

The next step is to add an organization - an environment with a shared quota of computing resources.

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

Organizations are subdivided into one or more spaces. Let's add a space to your organization.

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
