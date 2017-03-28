#!/bin/bash

RAILS_DIR=$(dirname $(cd $(dirname $0); pwd -P))
pushd "$RAILS_DIR"

while true ; do
  RAILS_ENV=production bundle exec rake backup_data
  last_backup_name=$(ls -t $RAILS_DIR/backups/ | head -n 1)
  echo "Verzeichnis: $RAILS_DIR/backups/$last_backup_name"
  echo "Warte 5 Minuten"
  sleep 300
done