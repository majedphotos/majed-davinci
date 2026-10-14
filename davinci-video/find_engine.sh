#!/bin/bash
# يلقى محرّك بلقن الفيديو (majed-video) على الجهاز ويطبع:  ENGINE=<المسار>
#   bash find_engine.sh        ← بالترتيب: $ENGINE · جنب هالبلقن بالكاش (أحدث نسخة) · أي متجر · سكل منصّب يدوي
# مسار البلقن فيه رقم النسخة ويتغيّر مع كل تحديث — فلا تحفظ المسار، شغّل هالسكربت كل جلسة.
DV="$(cd "$(dirname "$0")" && pwd)"
ok() { [ -f "$1/SKILL.md" ] && [ -f "$1/references/start.md" ] && [ -f "$1/scripts/motion-kit.js" ]; }
# الأحدث برقم النسخة (ملف VERSION) مو بترتيب المسار — جهاز فيه متجرين (قديم وجديد) يطلع المسار القديم «أكبر» أبجدياً
pick() { while read -r d; do ok "$d" && printf "%s\t%s\n" "$(cat "$d/VERSION" 2>/dev/null || echo 0)" "$d"; done | sort -V -k1,1 | tail -1 | cut -f2-; }
latest() { ls -d "$@" 2>/dev/null | pick; }
E=""
ok "${ENGINE:-/nonexistent}" && E="$ENGINE"
[ -z "$E" ] && E="$(latest "$DV"/../../../majed-video/*/video-ad-editor)"
[ -z "$E" ] && E="$(latest "$HOME"/.claude/plugins/cache/*/majed-video/*/video-ad-editor)"
[ -z "$E" ] && ok "$HOME/.claude/skills/video-ad-editor" && E="$HOME/.claude/skills/video-ad-editor"
[ -z "$E" ] && E="$(find "$HOME/.claude" -maxdepth 8 -path '*video-ad-editor/references/start.md' 2>/dev/null | sed 's|/references/start.md$||' | pick)"
if [ -z "$E" ]; then
  echo "❌ بلقن الفيديو (majed-video) مو منصّب — هالسكل يحتاجه." >&2
  echo "   نصّبه: /plugin marketplace add majedphotos/majed-plugins  ثم  /plugin install majed-video@majed-plugins" >&2
  exit 1
fi
E="$(cd "$E" && pwd)"
# قوالب دافنشي تحمل نسخة من motion-kit.js — نخليها نفس نسخة المحرّك
cmp -s "$E/scripts/motion-kit.js" "$DV/scripts/ograf_titles/motion-kit.js" || cp "$E/scripts/motion-kit.js" "$DV/scripts/ograf_titles/motion-kit.js" 2>/dev/null || true
echo "ENGINE=$E"
echo "DV=$DV"
echo "VERSION=$(cat "$E/VERSION" 2>/dev/null || echo ?)"
