# Instructor Notes

This document provides notes for would-be instructors of the Zero To Hero course. Please endeavour to keep this up-to-date when making changes to the slides themselves.

## 1. What is Cloud Foundry?

Students must understand the importance of Cloud Foundry in the wider context of the industry and of digital transformation.

Establish early that this course focuses on the _Application Runtime_ and not the _Container Runtime_.

### Key Takeaways

* Cloud Foundry enables you to **deliver software more quickly**, which in turn allows an organisation to become a continuously-delivering _learning_ organisation. The **step-change in pace is transformative**.
* Cloud Foundry allows freedom and flexibility. It is **portable across IaaSes**, allows the use of **any language** (which may be novel in large enterprises), and the consumption of any data service.
* Cloud Foundry is **primarily suited towards 12 Factor apps**, but can also run monoliths (via Docker-based apps, volume services). It doesn't mean you _should_, though.
* The CFF owns the IP, meaning **the project can't be subverted by one vendor**.

### Notes

This section often takes the longest, as there's a lot of background that can be explained.

You may need to explain what the 12 Factor manifesto is.

For a non-operator audience, the "where to get OS CF" slide is of minimal important. If you've got operators, they'll be keen to expand on this a little.

## 2. Interacting with Cloud Foundry

In addition to enumerating the ways that students can interact with Cloud Foundry, establish a mental model of orgs and spaces before they start pushing apps.

### Key Takeaways

* The **CLI is universal** and will work on any certified Cloud Foundry.
* **Web UIs are mostly proprietary**, and therefore the course does not teach them.
* Apps live in spaces, and **you can't have two apps with the same name in the space space**.

### Notes

Orgs and spaces are usually just logical divisions; however with Isolation Segments, orgs can be tied to particular subsets of underlying infrastructure.

Orgs can separate tenants - if the students are using a public CF like PWS, then they will each have their own org in one big Cloud Foundry. In large enterprises, an org might map to a business unit or a 'big A' application (set of apps).

Spaces are often used like environments, eg "dev", "staging", "UAT".

Quotas are primarily an operator concern, and often at most a curiosity for developers.

## 3. Pushing Your First App

Expose the inner working of `cf push` to enable students to develop an accurate mental model of the system and reason about any issues they may face.

### Key Takeaways

* **Cloud Foundry adds whatever your app needs** to make it runnable.
* Buildpacks allow flexibility, and can be thought of as a little like "plug-ins".
* Cloud Foundry **keeps a copy of your app code**.
* App instances run on Diego Cells.

### Notes

Students will have endured two fairly tedious and uninteresting labs to get to this point, so everything may be seeming a little abstract. At this point, energise the students by emphasising that this is where the exciting stuff starts.

The sequence diagram may seem quite dull, but is important for starting to expose the inner workings of Cloud Foundry, which will be revisited again in the post-lab recap sessions.

Some non-technical students may be confused what an "app instance" is. It may be necessary to delve into what a VM is when talking about Diego Cells, and also to explain containerisation at some level (ranging from "_apps can't see each other_" to a full explanation).

That staging containers are destroyed has security benefits - build tooling is not present in running droplets.

## 4. Buildpacks

Explain the rationale for buildpacks and the benefits they bring.

### Key Takeaways

* Buildpacks save developers from having to know or care how their apps become runnable - **they provide a separation of concerns**.
* **Buildpacks allow operators control** over what middleware and languages are available on their platform.
* Because CF keeps app code and droplets separately, **_operators_ can restage an app** to update its dependencies (and therefore patch security issues), without needing the app team's involvement.
* Buildpacks are _just scripts_.
* Restriction of buildpacks and their capabilities is often important in regulated environments.

### Notes

Students often benefit from examples of what "dependencies" really means in this context, so providing an explanation in relation to languages they're familiar with will help. Perhaps clarify to Java developers that the Java Buildpack does not compile their code or pull down Maven dependencies. By contrast, the Golang buildpack _does_ compile source code!

This module is a good opportunity to highlight the differences between pushing apps and using buildpacks, versus pushing Docker images. The latter can't be restaged and are opaque to the operator - the people running the platform have no idea of what has been pushed. Buildpacks also save a lot of effort in CI pipelines in comparison to building and pushing Docker images.

## 5. Resilience and Availability

Explain the paradox of why cloud environments make failure more likely, but allow for greater resilience.

### Key Takeaways

* **CF is self-healing** and will restart unhealthy apps without paging a human
* When deployed with **BOSH**, there are **additional levels of recoverability**
* **Running more instances of an app results in greater availability**, but apps must be written to allow multiple instances to be run.

### Notes

This is a key moment to remind students that they won't get all the benefits of the cloud that sales people promised them, unless they change their habits.

Explaining why embracing failure leads to increased availability can be somewhat of a tangent. Having more instances means that failure is not absolute, giving us the opportunity to learn from it and adapt. This is in stark contrast to the 'robust' approach of traditional enterprise IT of having one sacred server that is protected at all costs, but when it fails, it fails catastrophically. A sidetrack into the topic of antifragility here is entirely possible.

Talking about BOSH may be appropriate here, explaining how it will restart processes (ie Diego itself), restart missing VMs, and allow VMs to be striped across availability zones. However, it is best to avoid the inaccurate phrase "Four Levels of HA" that was used in the past, as these features make the system very recoverable, but not highly available - you will have downtime, but the system will right itself.

Students may benefit from being reminded that their apps may need to change. For example, leader election or external scheduling may be required when migrating from a monolith to many replicas of an app.

The slide on health management components is often superfluous.

## 6. Debugging

Give students the tools they need to debug broken apps of their own after finishing the course.

### Key Takeaways

* `cf logs` tells you what the app thinks is happening.
* `cf events` tells you what the _platform_ thinks is happening.
* **Logs in Cloud Foundry are not kept indefinitely**.
* Logs in Cloud Foundry are 'best effort' and **may be lost**.
* Use of **`cf ssh` should be discouraged**.

### Notes

Many users do not realise that `cf logs` does not store their logs indefinitely, and also do not realise that log entries may be lost altogether. Some students may perceive this latter point as a weakness of the platform, so explaining the extreme performance impact of guaranteed log delivery in a distributed environment may be required.

Recommend to students that if log entries need to be kept for regulatory purposes, they should be stored in a transactional data store instead.

`cf ssh` is a particularly dangerous command as it can change the state of running applications, completely invalidating testing and governance. Students should be discouraged from using it except when issues cannot be replicated anywhere other than the live environment.

## 7. Dealing with State

Demonstrate the power and flexibility of the service broker model, and ensure students understand the lifecycle of service instances.

### Key Takeaways

* Storing state outside of apps is essential to allow **horizontal scalability**
* Service brokers are like 'plug ins' that allow CF users to provision databases and other services
* Service credentials are provided through environment variables

### Notes

The lab for this module is quite long.

Some students may not be familiar with the term "sticky sessions", and may need some exposition on that pattern. Breaking out to a whiteboard to explain how sticky sessions and app server clustering worked in the past may be helpful. Referencing Zynga's Farmville and the 'shared nothing' architecture where all state was in the database may help to illustrate that pushing the complex logic of data replication to a data service is probably better than doing it in app code.

Explaining service instances in the abstract can be difficult, as a service _could_ be anything, and it could end up running anywhere.

Often students ask how _they_ can connect to service instances, in which case a verbal explanation of service keys may be useful, along with pointing out that one might not have network connectivity between a workstation and the service instance.
