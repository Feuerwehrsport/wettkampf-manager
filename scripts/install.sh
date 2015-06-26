#!/bin/bash

RAILS_DIR=$(dirname $(cd $(dirname $0); pwd -P))
pushd "$RAILS_DIR"

if [[ -f "$RAILS_DIR/db/production.sqlite3" ]] ; then
  read -p "Alle vorhandenen Daten werden gelöscht! Fortsetzen? [y/N] " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[YyjJ]$ ]] ; then
    exit 1
  fi
fi

bundle --without development test staging
rm -rf "$RAILS_DIR/db/*.sqlite3"

"$RAILS_DIR/scripts/deploy.sh"

RAILS_ENV=production bundle exec rake db:seed