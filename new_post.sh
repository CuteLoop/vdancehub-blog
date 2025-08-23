#!/usr/bin/env bash
# new-post.sh — create a Hugo post and rename it to MM-dd-<slug>.md inside year folder
# Usage: ./new-post.sh <post-slug>
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <post-slug>"
  exit 1
fi

# ---- config you can tweak ----
PROJECT_DIR="my-dance-blog"
# --------------------------------

# slug (normalize a little: trim, spaces->-, lowercase)
raw_slug="$1"
slug="$(echo "$raw_slug" | tr '[:upper:]' '[:lower:]' | sed -E 's/^[[:space:]]+|[[:space:]]+$//g; s/[[:space:]]+/-/g')"

year="$(date +%Y)"
date_prefix="$(date +%m-%d)"

posts_dir="$PROJECT_DIR/content/posts/$year"
hugo_post_path="posts/$year/$slug.md"

# checks
if ! command -v hugo >/dev/null 2>&1; then
  echo "Error: Hugo is not installed or not in PATH."
  exit 1
fi

# ensure folder exists
mkdir -p "$posts_dir"

# run `hugo new` from inside the project
pushd "$PROJECT_DIR" >/dev/null
hugo new "$hugo_post_path" || {
  echo "Error running 'hugo new $hugo_post_path'"
  popd >/dev/null
  exit 1
}
popd >/dev/null

old_file="$posts_dir/$slug.md"
new_file="$posts_dir/$date_prefix-$slug.md"

# rename to include date prefix
if [[ -e "$new_file" ]]; then
  echo "Error: target already exists: $new_file"
  exit 1
fi

if [[ -e "$old_file" ]]; then
  mv "$old_file" "$new_file"
  echo "Post created: $new_file"
else
  echo "Warning: expected $old_file but it wasn't found."
  echo "Check if your Hugo 'new' created the file in a different place."
  exit 1
fi
