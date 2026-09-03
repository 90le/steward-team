# scar — 伤疤库（Meta_Kim 复用）

每次打回/缺陷/返工回写一条；四字段缺回归测试不收（小衡把关）。

| 日期 | failurePattern（什么情况会再犯） | preventionRule（下次怎么防） | 回归测试（文件/命令） | reuseKey（下次运行复用键） |
|---|---|---|---|---|
| 2026-09-03 | 新建/改动 `.github/workflows/` 前未预检 gh token 权限：workflow scope 缺失导致 `git push` 被 GitHub 拒绝写入该目录；cron 会话与交互会话的凭据链可能分歧，同机器 token 不一定同步刷新，等到 push 才发现只能卡点转人工。 | 触碰 `.github/workflows/` 之前先跑一次权限 probe：`gh auth status` 检查 scopes 是否含 `workflow`；缺失就先转人工执行 `gh auth refresh -h github.com -s workflow`，拿到授权确认后再动手写 workflow 文件，不要等推送失败才回头卡点。 | `gh auth status 2>&1 \| grep -q workflow`（退出码非 0 即缺 scope，先卡点不动手） | ci-workflow-scope-probe |
| 2026-09-03 | 解除 `status/blocked-human`/`status/dev-claimed` 推进到 PR 就绪时，只改了 PR 侧标签（打 `status/code-review`），漏改对应 issue 侧标签（issue 仍停在旧状态），造成 issue 与 PR 状态机不同步，容易误导后续审核环节判断当前处于哪个阶段。 | PR 就绪播报前加一步核对：issue 标签必须与 PR 状态同步切换（PR 打 `status/code-review` 时 issue 必须同步改为 `status/in-dev`），核对不一致就先补标签再发播报，播报文案里两个链接（issue/PR）状态要能对上。 | `gh issue view <N> -R 90le/steward-team --json labels` 与 `gh pr view <M> -R 90le/steward-team --json labels` 各取一次，对照状态机映射表确认二者标签一致后才允许发播报 | issue-pr-label-sync-check |
