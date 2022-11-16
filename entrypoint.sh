#!/bin/bash
set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

rake db:create db:migrate
rake searchkick:reindex:all
bin/dev
exec bundle exec "$@"
