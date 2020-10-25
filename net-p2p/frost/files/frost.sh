#!/bin/sh
set -e

frost_dir="$HOME/.frost"
if ! [ -d "$frost_dir" ]; then
  mkdir "$frost_dir"
fi

cd "$frost_dir"
exec java -jar /opt/frost/frost.jar "$@"
