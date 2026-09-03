# steward-team — Steward 软件团队自举开发仓

小丘（需求/问答/哨兵）+ 小助（PM/PRD/Review）+ 小码（开发）在这里写真实代码。

## 规则（详见团队宪法）

- 状态机：approved → dev-claimed → in-dev → code-review → qa → landed（合并只由人类执行）
- PR 必须带 DoD 证据：测试/构建输出，标注证据级别
- 作者不自批；聊天不是批准；fail closed

## 文档源头

权威源在本地工程 `octo-steward/10-软件团队/`，本仓库是投影之一。

## CI / 本地自测

每次 push 与 PR 自动运行两个检查（`.github/workflows/ci.yml`），结果直接显示在 PR 页面的 checks 中：

1. **Lint (Markdown)** —— `npx markdownlint-cli2 "**/*.md"`，规则见 `.markdownlint-cli2.jsonc`（关闭了与中文技术文档风格冲突的行长/重复标题等规则，保留能抓真实问题的规则，如断代码块未标语言、标题前后缺空行）。
2. **Test (Structure & Links)** —— `bash scripts/test-structure.sh`，检查规定文件是否存在且非空，并扫描所有 `.md` 中的相对链接是否指向存在的文件（断链即失败）。

提 PR 前本地自测（与 CI 完全同步）：

```bash
npx --yes markdownlint-cli2@0.13.0 "**/*.md" "#node_modules"
bash scripts/test-structure.sh
```
