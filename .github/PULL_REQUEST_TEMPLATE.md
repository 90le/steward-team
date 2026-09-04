<!--
小码出 PR 固定结构（02-状态机与工作流契约.md 阶段 4 DoD）：
五段缺一不填 = 视为未就绪。证据必须是亲跑命令 + 真实输出，禁止「已测试通过」类无凭据表述。
-->

## 需求链接

<!-- 关联 issue，例如：Closes #7 -->

## What 变化

<!-- 一句话概括改了什么；如涉及多文件，按模块列点 -->

## 验证证据

<!--
命令 + 输出摘要，并标注证据级别。证据四档定义（原文摘自 docs/04-角色-小检.md:12，不要重新表述）：
「证据分级判定：每条结论标注 structural_smoke / ui_warning_or_system_message / skipped_or_needs_auth / runtime_live_pass 四档；只有 runtime_live_pass 支撑「通过」。」
-->

```bash
# 命令
```

```text
# 输出摘要
```

证据级别：<!-- structural_smoke / ui_warning_or_system_message / skipped_or_needs_auth / runtime_live_pass -->

## 影响面

<!-- 改动波及的文件/模块/角色；是否影响现有 CI、其他角色的读取路径 -->

## 回滚方式

<!-- 如何撤回本次改动，例如：revert 本 PR / 删除新增文件 -->
