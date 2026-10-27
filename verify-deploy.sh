#!/usr/bin/env bash
# Confirm what is actually SERVED, not what the Pages status API claims.
#
# The legacy Pages build reported "building" for ~10 minutes after a deploy had
# already gone live, so status is not a reliable signal. This fetches the real
# front page (the planner) with a cache-buster and compares it with the local
# copy byte for byte, or checks for a marker string if one is given.
#
#   ./verify-deploy.sh            served index.html == local index.html
#   ./verify-deploy.sh 'marker'   served index.html contains 'marker'
set -u
URL="https://fielke-mate.github.io/pyrenees-planning/index.html"
MARKER="${1:-}"
WANT=$(sha1sum < index.html)
for i in $(seq 1 40); do
  TMP=$(mktemp)
  curl -sS "${URL}?cb=$(date +%s)" -o "$TMP" 2>/dev/null || true
  if [ -s "$TMP" ]; then
    if [ -n "$MARKER" ]; then grep -qF "$MARKER" "$TMP"; else [ "$(sha1sum < "$TMP")" = "$WANT" ]; fi
    if [ $? -eq 0 ]; then
      echo "live after $((i*15))s  ($(wc -c < "$TMP") bytes)"
      rm -f "$TMP"; exit 0
    fi
  fi
  rm -f "$TMP"
  sleep 15
done
echo "not live after 10 minutes"; exit 1
