#!/bin/sh

# Make sure you are logged in before running this script!!!
cf target -o cfcommunity -s cforg
cf push cloud-native-workshop -b staticfile_buildpack -p site/public/ 