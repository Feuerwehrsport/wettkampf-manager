#!/bin/bash

RAILS_DIR=$(dirname $(cd $(dirname $0); pwd -P))
pushd "$RAILS_DIR"

rm -rf "$RAILS_DIR/public/assets"
RAILS_ENV=production bundle exec rake assets:precompile
RAILS_ENV=production bundle exec rake db:migrate
RAILS_ENV=production bundle exec rake import_suggestions  
