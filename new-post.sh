#!/usr/bin/env bash
set -euo pipefail

if [ $# -eq 0 ]; then
  echo "Usage: ./new-post.sh \"My Post Title\""
  exit 1
fi

TITLE="$1"
DATE=$(date +%Y-%m-%d)
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')
FILENAME="_posts/${DATE}-${SLUG}.md"

mkdir -p _posts

cat > "$FILENAME" << EOF
---
layout: post
title: "${TITLE}"
date: ${DATE}
tags: []
description: ""
canonical_url:
---

EOF

echo "Created: $FILENAME"
