#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
PUBLIC_DIR="$SCRIPT_DIR/public"
DOCS_DIR="$PROJECT_ROOT/docs"
AUTH_SNIPPET="$SCRIPT_DIR/auth-snippet.html"

# ============================================================
# Document registry: "source filename" → "url-slug.html"
# To add a new doc, add one line here and one card in index.html
# ============================================================
declare -A DOCS=(
    ["NFQ - Knowledge Driven Framework docs.html"]="kdd-operational.html"
    ["NFQ - Knowledge Driven Framework foundation.html"]="kdd-foundation.html"
    ["NFQ - Spec Graph vs Vector DB.html"]="spec-graph-vs-vector-db.html"
    ["NFQ - Anatomy of a Coding Agent.html"]="anatomy-coding-agent.html"
    ["NFQ - KDD Adoption Program AMS.html"]="kdd-adoption-ams.html"
    ["NFQ - KDD Adoption Program SDLC.html"]="kdd-adoption-sdlc.html"
    ["NFQ - AI 4 SDLC.html"]="ai-4-sdlc.html"
)

# ============================================================
# Extract auth snippet sections into temp files
# ============================================================
extract_section() {
    local file="$1" start="$2" end="$3" out="$4"
    sed -n "/$start/,/$end/p" "$file" | grep -v "$start" | grep -v "$end" > "$out"
}

TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

extract_section "$AUTH_SNIPPET" "__AUTH_HEAD_START__" "__AUTH_HEAD_END__" "$TMP_DIR/head.html"
extract_section "$AUTH_SNIPPET" "__AUTH_BODY_START__" "__AUTH_BODY_END__" "$TMP_DIR/body.html"
extract_section "$AUTH_SNIPPET" "__AUTH_SCRIPT_START__" "__AUTH_SCRIPT_END__" "$TMP_DIR/script.html"

# ============================================================
# Build public directory
# ============================================================
echo "Building public directory..."
rm -rf "$PUBLIC_DIR"
mkdir -p "$PUBLIC_DIR"

# Copy index (portal page — auth is already embedded)
cp "$SCRIPT_DIR/index.html" "$PUBLIC_DIR/index.html"

# Render Related Links from markdown into index.html
python3 - "$PUBLIC_DIR/index.html" "$SCRIPT_DIR/related-links.md" <<'PYEOF'
import re, sys, html
index_path, md_path = sys.argv[1], sys.argv[2]
with open(md_path, 'r', encoding='utf-8') as f:
    md = f.read()
pattern = re.compile(r'^\s*-\s*\[([^\]]+)\]\(([^)]+)\)\s*[—-]\s*(.+?)\s*$', re.M)
cards = []
for title, url, desc in pattern.findall(md):
    cards.append(
        '        <a href="' + html.escape(url, quote=True) + '" target="_blank" rel="noopener" class="doc-card">\n'
        '            <span class="badge external">Link</span>\n'
        '            <h3>' + html.escape(title) + '</h3>\n'
        '            <p>' + html.escape(desc) + '</p>\n'
        '            <div class="card-footer">Open &rarr;</div>\n'
        '        </a>'
    )
rendered = '\n\n'.join(cards) if cards else '<!-- no related links -->'
with open(index_path, 'r', encoding='utf-8') as f:
    html_src = f.read()
html_src = html_src.replace('<!-- @related-links@ -->', rendered)
with open(index_path, 'w', encoding='utf-8') as f:
    f.write(html_src)
print(f"  index.html (portal, {len(cards)} related links)")
PYEOF

# Copy and inject auth into each doc using sed + temp files
for src in "${!DOCS[@]}"; do
    dest="${DOCS[$src]}"
    src_path="$DOCS_DIR/$src"

    if [[ ! -f "$src_path" ]]; then
        echo "  WARN: $src not found, skipping"
        continue
    fi

    cp "$src_path" "$PUBLIC_DIR/$dest"

    # Inject auth head before </head> (first occurrence only)
    sed -i '' -e '/<\/head>/{
        r '"$TMP_DIR/head.html"'
        }' "$PUBLIC_DIR/$dest"

    # Inject auth body after <body> (first occurrence only)
    sed -i '' -e '/<body>/{
        r '"$TMP_DIR/body.html"'
        }' "$PUBLIC_DIR/$dest"

    # Inject auth script before </body> — only the LAST </body>
    # Use a python one-liner to avoid sed issues with special chars
    python3 -c "
import sys
with open(sys.argv[1], 'r') as f:
    html = f.read()
with open(sys.argv[2], 'r') as f:
    script = f.read()
# Replace only the last </body>
idx = html.rfind('</body>')
if idx >= 0:
    html = html[:idx] + script + '\n</body>' + html[idx+7:]
with open(sys.argv[1], 'w') as f:
    f.write(html)
" "$PUBLIC_DIR/$dest" "$TMP_DIR/script.html"

    echo "  $dest <- $src"
done

echo ""
echo "Public directory ready: $PUBLIC_DIR"
echo "Files: $(ls "$PUBLIC_DIR" | wc -l | tr -d ' ')"
echo ""

# ============================================================
# Deploy to Firebase (kdd-docs hosting site only)
# ============================================================
cd "$SCRIPT_DIR"
if command -v firebase &> /dev/null; then
    echo "Deploying to hosting:kdd-docs..."
    firebase deploy --only hosting:kdd-docs
else
    echo "Firebase CLI not found. Install with:"
    echo "  npm install -g firebase-tools"
    echo ""
    echo "Then authenticate and set your project:"
    echo "  firebase login"
    echo "  firebase use strata-491313"
    exit 1
fi
