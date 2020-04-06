#!/bin/sh
set -e

apt-get update && apt-get install -y postgresql-client

bundle install
rails db:drop
rails db:setup
rails db:seed RAILS_ENV=test

exec "/bin/bash"