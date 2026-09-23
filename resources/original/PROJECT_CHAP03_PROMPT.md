# 第 3 章开场提示（用于手工新建任务）

用途：2026-09-15 用 `create_thread` 自动开的第 3 章任务（thread `01a0a5c1-8f7b-75b1-8dfd-310447d65f19`）
开局即被 DeepSeek 接口拒绝（`invalid_request_error: missing field call_id`），已成死任务。
下面这段就是从那个任务里取回的原开场提示，手工新建任务后整段粘贴即可。

````
继续《统计力学自学讲义》项目，工作目录 /Users/ericgan/PhD/Statistical-Mechanics。本轮任务：编写**第 3 章「气体动理论（Kinetic Theory of Gases）」**。

开场请先完整读一遍 `PROJECT_HANDOFF.md`——它记录了这个项目的全部硬性要求、LaTeX 宏与编号约定、环境事实、每章标准流程、当前进度和各章页码范围，是唯一权威交接文档。除此之外**只读 `text.pdf` 的第 3 章相关页面**（正文 p.59–85，习题 p.87–97 直接跳过，开篇请先用 text.pdf 核对本章正文的起止页，必要时修正 PROJECT_HANDOFF.md 里的页码表）。文件夹里的其它文档（`notes/`、`Statistical Physics of Particles (Mehran Kardar).pdf` 等）一律不要打开。`HANDOFF.md`、`LEARNINGS.md` 只是项目最早的通用规范参考，本轮无需重读。

本章要点复述（细节以 PROJECT_HANDOFF.md 为准）：

1. **严格照原文翻译，不加任何自己的思考、推导、注释、改写**；原文疑似笔误照译，另记入 `errata.tex`（该文件独立编译，用 `./build-errata.sh` 验证）。
2. 只译正文不译习题；公式、图、表编号与原文一一对应，按章编号。
3. 章、节标题中英双语，中文在前、英文在后。人名一律不译。
4. 图只放占位框 + 中文图注，用户自己截图；命名 `fig/fig3-<图号>.png|jpg|pdf`。
5. 术语行内格式「中文（*English*）」用 `\term{中文}{English}{3.key}`；**同一术语全书只在首次出现处埋锚点**，第 1、2 章已锚定的词本章只保留意大利斜体英文（可查 `chapters/chap01.tex`、`chap02.tex` 末尾的术语注释块）。
6. 章末追加「本章斜体术语清单」注释块，区分「附录 B 候选术语」与「强调性斜体（不收录）」。
7. 流程：`bash _extract/render.sh <起页> <止页>` 渲染原文 → 每 4–6 页读一次 `_extract/pages/*-small.jpg` 缩图 → 译入 `chapters/chap03.tex`（用 `% p.NN` 标记原页）→ `./build.sh` 检查溢出与失效引用 → 用几行脚本核对 `chapters/chap03.aux` 里的编号连续性。
8. **一章一交付**：本章编译通过后即停下来交给用户检查，报告编译结果、编号核对结果、术语清单和需要用户拍板的事项，等用户确认后再开第 4 章。

上下文卫生（重要）：本机用 DeepSeek 接口，单次请求体积上限约 55MB，历史图片是主要风险。只读缩图（`-small.jpg`），同一张图不重复读，单任务累积图片控制在个位数，命令输出只取片段；每轮结束时提醒用户注意对话体积。
````
