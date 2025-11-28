#!/bin/sh

set -e

cd "$(dirname "$0")"

cleanup() {
  rm -rf tmp
}
trap 'cleanup' EXIT

################################################################################
# common functions copied from other repository
################################################################################

prepare_publish() {
  branch=$1
  git clone --single-branch --branch "$branch" https://github.com/infoaOrganization/ox_lib.git tmp || (
    git init tmp &&
    git -C tmp remote add origin https://github.com/infoaOrganization/ox_lib.git &&
    git -C tmp checkout -b "$branch"
  )
  find tmp -type f | grep -v ^tmp/\\.git | xargs rm -f
  find tmp -type d | grep -v ^tmp/\\.git | grep -v ^tmp\$ | xargs rm -rf
}

finalize_publish() {
  branch=$1
  git -C tmp add .
  git -C tmp commit -m "release $(date +%Y-%m-%d)"
  git -C tmp push origin "$branch"
  cleanup
}

################################################################################
# release
################################################################################

sh build.sh

prepare_publish release

cp -r imports resource locales fxmanifest.lua init.lua tmp
mkdir -p tmp/web
cp -r web/build tmp/web/build

finalize_publish release
