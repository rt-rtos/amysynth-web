#!/usr/bin/env bash
# Replace one channel of the site with a new build and commit it.
#
#   ./update.sh <site directory or zip of one> [next]
#
# The root of the repo is the stable channel, next/ the nightly. The build's
# files replace the channel's; README.md, LICENSE, this script and the other
# channel stay. The commit message carries the firmware version the page
# names.
set -euo pipefail
cd "$(dirname "$0")"
src=${1:?site directory or zip}
dst=${2:-.}
case $dst in .|next) ;; *) echo "channel: next, or none for the root" >&2; exit 2;; esac
tmp=
if [ -f "$src" ]; then
    tmp=$(mktemp -d); unzip -q "$src" -d "$tmp"; src=$tmp
    [ -f "$src/index.html" ] || src=$(dirname "$(find "$src" -name index.html | head -1)")
fi
[ -f "$src/index.html" ] || { echo "no index.html in $src" >&2; exit 1; }
for f in README.md LICENSE update.sh next; do [ -e "$src/$f" ] && { echo "$src carries $f; refusing" >&2; exit 1; }; done
if [ "$dst" = . ]; then
    git ls-files -z | grep -zvE '^(README\.md|LICENSE|update\.sh|next/)' | xargs -0 -r git rm -q --
else
    git ls-files -z -- "$dst" | xargs -0 -r git rm -q --
    mkdir -p "$dst"
fi
cp -a "$src"/. "$dst"/
[ -n "$tmp" ] && rm -rf "$tmp"
ver=$(sed -n 's/.*name="firmware-version" content="\([^"]*\)".*/\1/p' "$dst/index.html" | head -1)
git add -A
what=Site; [ "$dst" = . ] || what="Site $dst"
git commit -q -m "$what: firmware ${ver:-unknown}" && git log --oneline -1
