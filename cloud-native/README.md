# Cloud Foundry Foundation microservices training

## Prerequisites for building sites/slides
* [Hugo](https://gohugo.io/)

## Development

The site and the slides are in two different Hugo sites.
You can run them in different terminal windows using `hugo serve`.
The links to the slides on the agenda page will be broken because they
are only configured to work when the sites are built via `scripts/build.sh`.

## Building

Run `./scripts/build.sh`

## Deployment to CF

1. Make sure you have access to the cfcommunity org and cforg space on PWS.
1. Make sure you are logged in.
1. Run `./scripts/deploy.sh`.

Deployed to http://cloud-native-workshop.cfapps.io/.
