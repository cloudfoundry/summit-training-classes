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
