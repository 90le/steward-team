# steward-team — Steward 软件团队自举开发仓

一支 5 角色 AI 软件团队在这里写真实代码：**小丘**（需求/问答/哨兵）、**小助**（PM/PRD/需求评审/代码评审）、**小码**（开发）、**小检**（独立验证）、**小衡**（架构/发布门）。团队运行在 OpenClaw 上，通过 GitHub label 状态机协作——没有总控，状态机就是编排者。

## 如何向团队提需求

1. 在本仓库开一个 issue，写清楚：背景与问题、期望行为（What）、验收标准（用户可感知）。
2. 给 issue 打 `status/approved`（或交给小丘分类打标）。
3. 之后流水线自动接管：

```text
approved → dev-claimed(小码) → in-dev → PR → code-review(小助)
     → qa(小检，独立复跑+证据分级) → 发布门(小衡，清单核对+合并) → landed
```

- 评审/验证不通过会打回并给出逐条意见；需求自相矛盾会转人工（`status/blocked-human`）。
- 每一步都有群播报与运行日志留痕。

## 铁律（详见 CONSTITUTION.md）

- 小码只写这个仓库；octo-server 等外部仓库永久只读。
- PR 必须带 DoD 证据（验证命令+输出，标注证据级别）；QA 只认亲手复跑，弱证据上的 PASS 比 FAIL 危险。
- **bot 永不合并**——合并由人类 owner 的授权执行代理执行；作者不自批；聊天不是批准；fail closed。

## 目录

| 路径 | 内容 |
|---|---|
| `CONSTITUTION.md` | 团队宪法（五门禁） |
| `docs/` | 团队设计投影（TEAM/状态机契约/角色宪章） |
| `scripts/` | 团队公共脚本（`label-guard.sh` 标签机械补打等） |
| `scar.md` | 伤疤库：每次打回/缺陷回写四字段（无回归测试不收） |
| `.github/workflows/` | CI：markdownlint + 结构/链接自检 |

## 文档源头

本仓库 `docs/` 是团队设计的唯一权威源（TEAM/CONSTITUTION/状态机契约/角色宪章），直接在本仓库改、走 PR 评审、可被引用行号、可被 scar 追溯。本地 `octo-steward/10-软件团队/` 已降级为历史快照（archived），不再作为权威源单向投影到本仓库。
