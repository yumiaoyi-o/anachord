#!/usr/bin/env sh

cat ~/.local/state/blood/sequences.txt 2>/dev/null

exec "$@"
