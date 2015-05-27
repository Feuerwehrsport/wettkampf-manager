#!/bin/bash

RAILS_DIR=$(dirname $(cd $(dirname $0); pwd -P))
pushd "$RAILS_DIR"

bundle
rm -rf "$RAILS_DIR/db/*.sqlite3"

"$RAILS_DIR/scripts/deploy.sh"

RAILS_ENV=production bundle exec rake db:seed