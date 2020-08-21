#!/usr/bin/env bash

echo "Running pre-commit hook"
./doc/scripts/hooks/run-rubocop.sh
./doc/scripts/hooks/run-haml-lint.sh

# $? stores exit value of the last command
if [ $? -ne 0 ]; then
  echo "Code must be clean before commiting"
  exit 1
fi
