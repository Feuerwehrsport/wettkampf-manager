#!/usr/bin/env bash

echo "Running pre-push hook"
./doc/scripts/hooks/run-rspec.sh

# $? stores exit value of the last command
if [ $? -ne 0 ]; then
  echo "Code must be clean before commiting"
  exit 1
fi
