#!/usr/bin/env bash

set -e

cd "${0%/*}/../../.."

CHECKSUM=$(git ls-files -z --recurse-submodules | xargs -0 md5sum | md5sum)
CACHESUM=$(cat tmp/rspec_checksum)

if [ "$CHECKSUM" = "$CACHESUM" ]; then
  echo "Skip rspec"
else
  echo "Running rspec"
  bundle exec rspec
fi
