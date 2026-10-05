#!/bin/bash
# 응답이 끝날 때마다 변경사항을 자동 커밋하고 현재 브랜치로 푸시한다.
cd "$CLAUDE_PROJECT_DIR" 2>/dev/null || exit 0

branch=$(git branch --show-current)
# 기본 브랜치에는 자동 푸시하지 않는다
case "$branch" in ""|main|master) exit 0 ;; esac

[ -z "$(git status --porcelain)" ] && exit 0

git add -A
git commit -q -m "chore: auto-save $(date '+%Y-%m-%d %H:%M')

Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>" || exit 0

for delay in 0 2 4 8 16; do
  sleep "$delay"
  git push -q -u origin "$branch" && exit 0
done
echo "auto-push 실패: 네트워크를 확인하세요" >&2
exit 0
