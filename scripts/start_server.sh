#!/bin/bash

RAILS_DIR=$(dirname $(cd $(dirname $0); pwd -P))
pushd "$RAILS_DIR"

RAILS_ENV=production rails server -e production -p 3000 -b 0.0.0.0 -d