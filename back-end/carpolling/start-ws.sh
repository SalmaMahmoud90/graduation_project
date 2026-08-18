#!/bin/bash
set -euo pipefail

# Run from the script's own directory so relative paths (.venv) resolve.
cd "$(dirname "$0")"

# Activate the virtual environment
source .venv/bin/activate

# Single-process ASGI server for WebSockets ONLY (nginx routes /ws/ here).
#
# IMPORTANT: keep this ONE process. Every connection for a ride group lives in
# the same in-memory channel layer, so a single process makes group broadcasts
# work without Redis. Do NOT add a second instance or a multi-worker manager
# in front of it — that would split the channel layer and break broadcasts.
exec daphne -b 127.0.0.1 -p 3016 carpolling.asgi:application
