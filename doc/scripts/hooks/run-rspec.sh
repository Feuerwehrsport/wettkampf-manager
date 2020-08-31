#!/usr/bin/env bash

set -e

cd "${0%/*}/../../.."

SUM_FILE="tmp/rspec_checksum.$(date -Iseconds)"
git ls-files -z --recurse-submodules | xargs -0 md5sum | grep -F -v "doc/simplecov.json" > $SUM_FILE
git ls-files --others --exclude-standard -z | xargs -0 md5sum >> $SUM_FILE

CHECKSUM=$(cat $SUM_FILE | md5sum)
CACHESUM=$(cat tmp/rspec_checksum)

if [ "$CHECKSUM" = "$CACHESUM" ]; then
  echo "Skip rspec"
else
  echo "Running rspec"
  bundle exec rspec
fi
