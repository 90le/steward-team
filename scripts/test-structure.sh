#!/usr/bin/env bash
# structure-test: 最小化的仓库结构/链接自检（无外部依赖，纯 bash + grep）。
# 用途：CI 的 "test" 步骤，以及本地自测（见 README「CI / 本地自测」）。
set -euo pipefail

fail=0

log_fail() {
  echo "FAIL: $1"
  fail=1
}

log_pass() {
  echo "PASS: $1"
}

# 1) 必需文件存在且非空
required_files=(
  "README.md"
  "CONSTITUTION.md"
  "scar.md"
  "docs/00-TEAM.md"
  "docs/02-状态机与工作流契约.md"
  "docs/03-角色-小码.md"
  "docs/04-角色-小检.md"
  "docs/05-角色-小衡.md"
)

for f in "${required_files[@]}"; do
  if [ ! -s "$f" ]; then
    log_fail "必需文件缺失或为空: $f"
  else
    log_pass "必需文件存在: $f"
  fi
done

# 2) 扫描所有 .md 文件中的相对链接 [text](path)，确认目标文件存在
broken_links=0
while IFS= read -r -d '' mdfile; do
  dir=$(dirname "$mdfile")
  # 提取形如 (path) 的链接目标，排除 http/https/mailto/# 锚点
  while IFS= read -r link; do
    [ -z "$link" ] && continue
    case "$link" in
      http://*|https://*|mailto:*|\#*) continue ;;
    esac
    # 去掉链接内的锚点部分 path#anchor -> path
    target="${link%%#*}"
    [ -z "$target" ] && continue
    resolved="$dir/$target"
    if [ ! -e "$resolved" ]; then
      log_fail "断链: $mdfile 引用了不存在的路径 '$link' (解析为 $resolved)"
      broken_links=1
    fi
  done < <(grep -oE '\]\([^)]+\)' "$mdfile" | sed -E 's/^\]\(//; s/\)$//')
done < <(find . -name "*.md" -not -path "./.git/*" -not -path "./node_modules/*" -print0)

if [ "$broken_links" -eq 0 ]; then
  log_pass "所有 Markdown 相对链接均可解析"
fi

if [ "$fail" -ne 0 ]; then
  echo "---"
  echo "structure-test: 未通过"
  exit 1
fi

echo "---"
echo "structure-test: 全部通过"
