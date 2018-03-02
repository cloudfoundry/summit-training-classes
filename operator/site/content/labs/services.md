---
date: 2018-02-16T19:21:15-03:00
title: Deploying MySQL
---

In this section, we'll use BOSH to add MySQL as a 'service' to your Cloud Foundry deployment. Then, as a user of Cloud Foundry, you will create an instance of this service and bind it to your app.

MySQL is one of many BOSH releases that includes a 'service broker'. This enables these services to integrate with a range of platforms, including Cloud Foundry, and advertise a catalog of services to app developers through the platform's marketplace.

## Deploying MySQL

* First, clone the MySQL BOSH **Release** repo:

```sh
git clone https://github.com/cloudfoundry/cf-mysql-release.git ~/workspace/cf-mysql-release
```

* At the time of writing, the MySQL release next requires you to run the following commands from the main directory of the repo:

```sh
git checkout tags/v36.10.0
./scripts/update
bosh create-release
```

Finally run `bosh upload-release` to send the release to your Director.

* Now, clone the MySQL BOSH **Deployment** repo:

```sh
git clone https://github.com/EngineerBetter/cf-mysql-deployment.git ~/workspace/cf-mysql-deployment
```

We're now ready to deploy MySQL with the following command. Note that you need to pass through your Cloud Foundry admin password and system domain as variables. Can you remember where to find these?

```sh
cd ~/workspace/cf-mysql-deployment
bosh -d cf-mysql deploy \
  cf-mysql-deployment.yml --vars-store mysql-creds.yml \
  -o ./operations/add-broker.yml \
  --vars-file bosh-lite/default-vars.yml \
  --var cf_mysql_external_host=p-mysql.$SYSTEM_DOMAIN \
  --var cf_mysql_host=$BOSH_ENVIRONMENT \
  --var cf_admin_password=$CF_ADMIN_PASSWORD \
  --var cf_api_url=https://api.$SYSTEM_DOMAIN \
  --var cf_skip_ssl_validation=true
```

```sh
Task 217

Task 217 | 14:48:17 | Preparing deployment: Preparing deployment (00:00:00)
                    L Error: Instance group 'mysql' references an unknown vm type 'massive'
```

What happened? BOSH is complaining that your manifest is referring to a type of VM that it doesn't recognise.

To fix this, you'll need to make changes to your `cloud-config` and update your BOSH Director with the new `cloud-config`, and finally redeploy MySQL.

### Cloud Config

Every BOSH Director has a cloud config that defines IaaS-specific configuration, allowing deployment manifests themselves to be IaaS-agnostic. You added a cloud config when first deploying Cloud Foundry, but it didn't include a VM description that the MySQL manifest was expecting.

### Checking Your Work

Before moving on, check that you now have a MySQL deployment with the `bosh deployments` command.

You can also see the MySQL VMs (in our case, containers mimicking VMs) that have been created:

```sh
$ bosh vms

...
Deployment 'cf-mysql'

Instance                                         Process State  AZ  IPs           VM CID                                VM Type  Active
arbitrator/5657c922-6128-48ac-94b5-67a1aec69e51  running        z3  10.244.0.144  d0e6eda5-8a04-4ede-614e-c49be6fafa7f  default  false
broker/7c3e7334-5d6d-4117-8239-d57f77967345      running        z1  10.244.0.147  008f6980-c47a-4853-69b4-f268be089eb6  default  false
broker/de86395f-1b72-4ce2-91f3-5d9590433eaa      running        z2  10.244.0.148  362e5ad6-8911-4d75-48eb-0b800cc1d859  default  false
...
```

## Register the Service Broker

A BOSH errand is included in the MySQL release that 'registers' its service broker with Cloud Foundry. You can see the available errands by running:

```sh
bosh errands -d <deployment-name>
```

Let's run the errand `broker-registrar` with `bosh run-errand`.

### Checking Your Work

At this point, you should see MySQL available in the cf marketplace:

```sh
$ cf marketplace
Getting services from marketplace in org system / space test as admin...
OK

service   plans        description
p-mysql   10mb, 20mb   MySQL databases on demand
```

## Using the MySQL Service

Let's provision a database for an app. Use `cf create-service` to create a new instance of the MySQL service.

### Checking Your Work

If you run the following, you should see your service instance:

```sh
$ cf services
Getting services in org system / space test as admin...
OK

name         service   plan   bound apps   last operation
mydatabase   p-mysql   20mb                create succeeded
```

### Binding your Service Instance

In order for your app to be able to use the service, you must `bind` it.  Find and run the command to bind the service instance to your application.

### Checking Your Work

There are many several to check and see what services are bound to an app.  One way is to re-run `cf services`.

### How does it work?

Run the following:

```sh
  cf env <your-app>
```

You should see json outputted to the command line.  Find the section that looks like:

```

  System-Provided:
  {
    VCAP_SERVICES: {
    ...
  }
```

Under here you should see the MySQL service.  The connection credentials were provided by the service broker and handed to the application via an environment variable called `VCAP_SERVICES`.

## Beyond the Class

Review the documentation on [Application Security Groups](https://docs.pivotal.io/pivotalcf/adminguide/app-sec-groups.html).

It is best practice to restrict outgoing access by default through the use of the system-wide `running` and `staging` security groups.  Then, allow exceptions on a space by space basis by binding security groups to spaces.
