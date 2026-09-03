#!/usr/bin/env bash
# 标签机械补打（治「标签流转」系统性弱点——已三次复发）
# 原则：机械归脚本。只做两类确定性修复，不做语义推断：
#   1) open PR 完全没有 status/* 标签 → 补 status/code-review（评审是所有无标签 PR 的安全入口）
#   2) 已合并的 dev-<N>-* PR → 对应 issue 同步 status/landed
# 用法：bash scripts/label-guard.sh  （输出修复行，模型只负责转述，不参与判断）
set -euo pipefail
REPO="90le/steward-team"
FIXES=0

# 1) 无 status 标签的 open PR → 补 status/code-review
mapfile -t UNLABELED < <(gh pr list -R "$REPO" --state open --json number,labels \
  --jq '.[] | select([.labels[].name] | map(startswith("status/")) | any | not) | .number' 2>/dev/null || true)
for N in "${UNLABELED[@]:-}"; do
  [ -z "$N" ] && continue
  gh pr edit "$N" -R "$REPO" --add-label "status/code-review" >/dev/null
  echo "label-guard: PR #$N 无 status 标签 → 补 status/code-review"
  FIXES=$((FIXES+1))
done

# 2) 已合并的 dev-<N>-* PR → issue 同步 status/landed
mapfile -t MERGED < <(gh pr list -R "$REPO" --state merged --json number,headRefName \
  --jq '.[] | select(.headRefName | test("^dev-[0-9]+-")) | "\(.number) \(.headRefName)"' 2>/dev/null || true)
for E in "${MERGED[@]:-}"; do
  [ -z "$E" ] && continue
  PN=${E%% *}; BR=${E#* }
  ISSUE=$(printf '%s' "$BR" | sed -E 's/^dev-([0-9]+)-.*/\1/')
  [ -z "$ISSUE" ] && continue
  if gh issue view "$ISSUE" -R "$REPO" --json labels --jq '[.labels[].name]' 2>/dev/null | grep -q "status/landed"; then
    continue
  fi
  gh issue edit "$ISSUE" -R "$REPO" --add-label "status/landed" >/dev/null
  echo "label-guard: PR #$PN 已合并 → issue #$ISSUE 同步 status/landed"
  FIXES=$((FIXES+1))
done

echo "label-guard: fixes=$FIXES"
