#!/bin/bash

set -ex

pushd basics/site
  hugo
popd

pushd basics/slides
  hugo
popd

mkdir built
cp -r cloud-native/site/public/* ../built/
mkdir -p ../built/slides
cp -r cloud-native/slides/public/* ../built/slides/
