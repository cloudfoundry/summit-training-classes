#!/bin/sh

STC_ORG=${STC_ORG:-'cfcommunity'}
STC_SPACE=${STC_ORG:-'cforg'}

cf api | grep "^No[t ]" && exit 1 

cf target -o ${STC_ORG} -s ${STC_SPACE}
cf push basics-workshop -b staticfile_buildpack -p site/public/ 
