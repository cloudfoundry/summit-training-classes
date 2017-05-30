#!/usr/bin/env bash
fly -t cicd set-pipeline -c pipeline.yml -p cloud-native-training -l credentials.yml