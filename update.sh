#!/usr/bin/env bash
# Replace the site with a new build and commit it.
#
#   ./update.sh <site directory or zip of one>
#
# The build's files replace the ones here; README.md, LICENSE and this script
# stay. The commit message carries the firmware version the page names.
set -euo pipefail
cd "$(dirname "$0")"
src=${1:?site directory or zip}
tmp=
if [ -f "$src" ]; then
    tmp=$(mktemp -d); unzip -q "$src" -d "$tmp"; src=$tmp
    [ -f "$src/index.html" ] || src=$(dirname "$(find "$src" -name index.html | head -1)")
fi
[ -f "$src/index.html" ] || { echo "no index.html in $src" >&2; exit 1; }
for f in README.md LICENSE update.sh; do [ -e "$src/$f" ] && { echo "$src carries $f; refusing" >&2; exit 1; }; done
git ls-files -z | grep -zvE '^(README\.md|LICENSE|update\.sh)$' | xargs -0 -r git rm -q --cached --
cp -a "$src"/. .
[ -n "$tmp" ] && rm -rf "$tmp"
ver=$(sed -n 's/.*name="firmware-version" content="\([^"]*\)".*/\1/p' index.html | head -1)
git add -A
git commit -q -m "Site: firmware ${ver:-unknown}" && git log --oneline -1
