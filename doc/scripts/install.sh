#!/bin/bash

set -eu
gem install bundler
bundle --without development test staging
export RAILS_ENV=production

SECRET_KEY_BASE=$(rake secret)
sed -i "s/<%= ENV\[\"CHANGED_BY_BUILDING_TOOL\"\] %>/$SECRET_KEY_BASE/" "config/secrets.yml"


if [[ -f "db/production.sqlite3" ]] ; then
  read -p "Alle vorhandenen Daten löschen? [y/N] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[YyjJ]$ ]] ; then
    rm -rf "db/production.sqlite3"
  fi
fi


RAILS_ENV=production bundle exec rake assets:precompile
RAILS_ENV=production bundle exec rake db:drop
RAILS_ENV=production bundle exec rake db:migrate
RAILS_ENV=production bundle exec rake db:seed
RAILS_ENV=production bundle exec rake import:suggestions  
