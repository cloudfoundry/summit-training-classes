#!/bin/sh

rm -rf site/public

# build site
pushd site
hugo
popd

# build slides
pushd slides
hugo
popd

# move slide to a /slides dir under site
mkdir -p site/public/slides
cp -fr slides/public/* site/public/slides