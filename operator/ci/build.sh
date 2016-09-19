#!/bin/bash

set -ex

pushd operator/site
  hugo
popd

pushd operator/slides
  hugo
popd

mkdir built
cp -r operator/site/public/* ../built/
mkdir -p ../built/slides
cp -r operator/slides/public/* ../built/slides/
