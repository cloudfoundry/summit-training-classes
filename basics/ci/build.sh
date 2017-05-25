#!/bin/bash

set -ex

pushd basics/site
  hugo  
popd

pushd basics/slides
  hugo
popd

mkdir built
cp -r basics/site/public/* ../built/
mkdir -p ../built/slides
cp -r basics/slides/public/* ../built/slides/
