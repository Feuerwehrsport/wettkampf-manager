#!/usr/bin/env bash

set -e

cd "${0%/*}/../../.."

echo "Running rubocop"
bundle exec rubocop --config config/rubocop.yml
