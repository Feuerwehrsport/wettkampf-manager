#!/usr/bin/env bash

set -e

cd "${0%/*}/../../.."

echo "Running haml-lint"
HAML_LINT_RUBOCOP_CONF=config/rubocop.yml bundle exec haml-lint --config config/haml-lint.yml
