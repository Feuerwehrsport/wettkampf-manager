#!/bin/bash

RAILS_DIR=$(dirname $(cd $(dirname $0); pwd -P))
pushd "$RAILS_DIR"

kill $(cat "$RAILS_DIR/tmp/pids/server.pid")