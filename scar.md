# scar — 伤疤库（Meta_Kim 复用）

每次打回/缺陷/返工回写一条；四字段缺回归测试不收（小衡把关）。

| 日期 | failurePattern（什么情况会再犯） | preventionRule（下次怎么防） | 回归测试（文件/命令） | reuseKey（下次运行复用键） |
|---|---|---|---|---|
| 2026-09-03 | CI workflow 的 `push` 触发未设 `paths` 过滤时，会对目标分支的**每次**合并都实跑该 job 的全部步骤（不限于改动相关文件时），若步骤本身含生产级副作用（如本例 `label-guard.sh` 的 `gh pr/issue --add-label`），会引入未被需求要求的长期自动化触发面 | 新增/修改 workflow 触发器时，`push` 触发必须补齐与 `pull_request` 触发一致的 `paths` 过滤；PR review 阶段用脚本核查两者 paths 是否一致再放行 | `python3 -c "import yaml; d=yaml.safe_load(open('.github/workflows/label-guard-windows-smoke.yml')); o=d[True]; assert o['push']['paths']==o['pull_request']['paths']"`（或等效：为仓库所有 workflow 文件断言 push.paths 与 pull_request.paths 一致） | workflow-push-paths-filter-missing |
