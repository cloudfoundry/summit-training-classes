#!/bin/bash

set -ex

pushd cloud-native/site
  hugo
popd

pushd cloud-native/slides
  hugo
popd

mkdir built
cp -r cloud-native/site/public/* ../built/
mkdir -p ../built/slides
cp -r cloud-native/slides/public/* ../built/slides/
