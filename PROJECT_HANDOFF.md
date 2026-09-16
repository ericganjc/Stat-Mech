# 交接：统计力学自学讲义（Kardar 正文翻译）

> 新任务开场只需读本文件 + `text.pdf` 的当章页面，不必读其它任何文件。

## 一、任务与硬性要求

把 Kardar, *Statistical Physics of Particles*（Cambridge 2007）正文译成中文 LaTeX 讲义。

1. 中文讲义，`main.tex` 主文档 + 每章一个独立 tex，`\include` 交叉引用编译。
2. **只译正文，不译习题**。跳过页码：29–33、53–55、87–97、121–125、149–155、175–180、202–210（第 7 章习题自 p.202 下半页起）。
3. 图只放占位框 + 中文图注，用户自己截图；图文件名 `fig/fig<章>-<图号>.png|jpg|pdf`，文件存在时自动替换占位框，tex 不用改。
4. 卷首顺序：标题页 → abstract（留空占位，用户最后写）→ 全书目录。
5. 章、节标题双语，**中文在前、英文在后**（目录条目为「中文（English）」）。
6. 全书末尾两个附录：A = 物理量符号及含义（**不记页码**，改为逐条给出该物理量的**量纲**）；B = 术语中英文对照（中文/英文/首次出现页码，按首次出现排序）。
7. **人名一律不译**（Boltzmann、Gibbs、Carnot、Kelvin、Clausius、Joule、Helmholtz、Legendre、Maxwell、Nernst、van der Waals…）。
8. **翻译纪律**：严格照原文翻译，不加任何自己的思考、推导、注释、勘误；原文疑似笔误照译，另记入 `errata.tex`。
9. 一章一章做，每章编译通过后交用户检查，确认后才开下一章；每章附「本章斜体术语清单」供用户圈定附录 B。
10. 用户已确认：强调性斜体**不**收入附录 B（正文用 `\emph{}` 呈现即可）；术语行内格式为「中文（*English*）」。
11. **每轮交付报告必须分别汇报两项体量指标，不得合并叙述**（用户要求，第 5 章交付后）：(a) **对话体积** = 本会话 rollout 文件的磁盘体积（MB，`ls -l ~/.codex/sessions/**/<session>.jsonl`）；(b) **token 用量** = 最近一次请求的 input token 与上下文窗口上限（取自 rollout 里的 `last_token_usage`）。两者是不同东西，必须分别给出数字。
12. 用户核 `text.pdf` 后的更正（第 5 章交付后）：原书**小节标题为粗体、行内小标题也为粗体**，都不是斜体；因此小节标题中的词（如 The cluster expansion、Mean-field theory of condensation、Variational methods）不属于「原文中的斜体术语」，一律不收入附录 B、不埋锚点。

## 二、文件

| 文件 | 说明 |
| --- | --- |
| `main.tex` | 主文档：标题页、abstract 占位、目录、7 章 include、2 附录 |
| `preamble.tex` | 导言区与全部自定义宏 |
| `chapters/chap01.tex` … `chap07.tex` | 各章正文 |
| `appendices/appendixA.tex`、`appendixB.tex` | 附录骨架，条目随各章推进逐步补 |
| `errata.tex` + `build-errata.sh` | 独立编译的「正文疑似笔误清单」+ 非翻译性改动记录 |
| `fig/` | 用户自截图片，命名 `fig1-5.png` 等；`fig/README.md` 是命名规则 |
| `_extract/render.sh` | 渲染原文页面为缩图：`bash _extract/render.sh <起页> <止页>` |
| `_extract/text_full.txt` | 原文文本层（525 KB）。公式多是 `(cid:)` 乱码，但**prose、图注、术语原词可查**，适合核对措辞 |

编译：`./build.sh`（xelatex ×2，并检查溢出与失效引用）。勘误：`./build-errata.sh`。

## 三、宏与约定

- `\bichapter{中文}{English}`、`\bisection{}{}`、`\bisubsection{}{}`
- `\term{中文}{English}{1.key}` → 输出「中文（*English*）」并埋锚点 `\label{term:1.key}`，供附录 B 用 `\pageref` 取首次出现页码；同一术语全书只标第一次出现处
- `\cnfigure{fig1-5}{中文图注}` → 图浮动体 + 占位框；`\figfile` 自动找 `fig/fig1-5.*`
- `\inexd` → 原文的 đ（d 加横杠）；**不要**用 `\dj`
- 向量与力的集合用 `\bm{X}`、`\bm{J}`、`\bm{\mu}`
- 公式、图、表均按章编号，与原文一一对应；`\label{eq:1.13}`、`\label{fig:fig1-5}`
- 原文不编号的式子用 `equation*`

## 四、环境事实（踩过的坑）

1. ctex 必须 `fontset=fandol`（macnew 缺字体）。
2. xelatex 在 `/Library/TeX/texbin/xelatex`，TeX Live 2026。
3. 渲染**英文原文**用 pdftoppm（`_extract/render.sh` 已配好）；渲染**中文 PDF** 必须用 `/usr/local/bin/gs`（pdftoppm 会 Adobe-GB1 报错）。
4. `shrink-image.sh` 是 zsh 脚本，用 `zsh` 调用（用 bash 会报 `print: command not found`）。
5. 图片体积规则：读图前先缩图，只读 `-small.jpg`；单任务累积图片尽量控制在个位数。页面缩图约 150–250 KB，远小于原图；上下文压缩时历史图片会被丢弃，所以长任务本身是安全的，但要警惕单次请求体积。
6. 命令输出只取片段（`head`/`tail`/`grep`/`grep -o`）。

## 五、每章的标准流程

1. `bash _extract/render.sh <起页> <止页>`，分批读 4–6 页（`_extract/pages/p-0NN-small.jpg`）。
2. 逐段译入 `chapters/chapNN.tex`，用注释 `% p.NN` 标记原文页。
3. `./build.sh`，检查 `Overfull`、`Reference undefined`。
4. 用几行 Python 比对 `chapters/chapNN.aux`：`\newlabel{eq:N.M}` 的编号必须等于 `N.M`，且不缺号；图号同理。原文图注顺序可用 `grep -o "Fig\.[0-9]\+\.[0-9]\+" _extract/text_full.txt` 取出来比对。
5. 把本章斜体术语清单追加到该章文件末尾的注释块（术语 + 页码；强调类另列）。
6. 交付：结论先行，报告编译结果、编号核对结果、术语清单、需要用户拍板的事项。

## 六、进度

- **第 1 章 热力学 Thermodynamics（p.1–29 顶部）已完成**：式 (1.1)–(1.83)、图 1.1–1.23、表 1.1–1.2，编译通过，正文 23 页，图号与原文逐一核对一致。用户已验收。
  - 已修：图 1.14/1.15 的先后顺序（见 `errata.tex`）。
- **第 2 章 概率论 Probability（p.35–52）已完成并验收**：式 (2.1)–(2.74)、图 2.1–2.8，脚本核对编号连续性全部通过；`main.pdf` 共 50 页；零 Overfull（仅第 1 章 p.175 处 0.95pt 的历史遗留）、零失效引用、零重复标签。用户已确认满意。
  - 用户拍板：p.35 的 **likelihood 作为术语收录**（正文已用 `\term{似然}{likelihood}{2.likelihood}`）；p.43 的「例子」（Example 斜体）属强调，不收入附录 B。
  - 术语锚点约定（新增）：**同一术语全书只在首次出现处埋锚点**（附录 B 只收首次出现页码）。故第 2 章的 Intensive/Extensive（第 1 章 p.5）、entropy（第 1 章 p.13）只保留意大利斜体英文、不再 `\term`；p.44 的 expectation value 同理不重复。
  - p.44 原文中「联合矩的图形表示」是一幅**无编号**插图，讲义中用无编号 fbox 占位（非 `\cnfigure`）。
  - `errata.tex` 新增一条：p.39 原文拼作 *curtosis*（通常作 kurtosis）。
- **第 3 章 气体动理论 Kinetic theory of gases（正文 p.57–87 上半）已译完，待用户验收**：式 (3.1)–(3.130)、图 3.1–3.8（全部为占位框），`main.pdf` 共 76 页；脚本核对 130 个公式编号连续无缺号、8 个图号与原文一致；零失效引用、零重复标签；唯一 Overfull 仍是第 1 章 p.175 处 0.95pt 的历史遗留。
  - 页码修正（重要）：第 3 章正文实际自 **p.57**（3.1 General definitions）起、至 **p.87 上半页**（式 3.130 之后的收尾段）止；同页下半起为「Problems for chapter 3」。第七章页码表据此把第 3 章正文页改为 57–87。小节起始页：3.1 p.57 / 3.2 p.59 / 3.3 p.62 / 3.4 p.65 / 3.5 p.71 / 3.6 p.75 / 3.7 p.78 / 3.8 p.82 / 3.9 p.84。
  - 图占位：`fig/fig3-1`…`fig3-8`（用户自行截图，命名 `fig3-<图号>.png|jpg|pdf`）。
  - `errata.tex` 新增一条：p.66 式 (3.31) 下方正文把平均自由**时间** $\tau_\times$ 说成粒子两次碰撞间走过的典型「距离」（*distance*）。
  - 术语锚点：本章埋锚点 40 处（`3.microstate` … `3.fourier-equation`，见 `chapters/chap03.tex` 末尾注释块）；objective / PDF / unconditional PDF / entropy / Wick's theorem 等已在第 1、2 章锚定，本章只保留意大利斜体、不再 `\term`。
- **第 4 章 经典统计力学 Classical statistical mechanics（正文 p.98–120 上半）已译完，待用户验收**：式 (4.1)–(4.112)、图 4.1–4.11（全部为占位框）、表 4.1，`main.pdf` 共 96 页；脚本核对 112 个公式编号连续无缺号、11 个图号与原文逐一一致；零失效引用、零重复标签；唯一 Overfull 仍是第 1 章 p.175 处 0.95pt 的历史遗留（第 4 章曾出现 77.5pt 溢出，已把混合熵的多组分推广式改为独立显示式消除）。
  - 页码修正（重要）：第 4 章正文自 **p.98**（4.1 一般定义）起、至 **p.120 上半页**（式 4.112 与化学势收尾段）止；同页下半起为「Problems for chapter 4」（p.120–125）。小节起始页：4.1 p.98 / 4.2 p.98 / 4.3 p.102 / 4.4 p.105 / 4.5 p.107 / 4.6 p.110 / 4.7 p.113 / 4.8 p.115 / 4.9 p.117–118。
  - 术语锚点：本章埋锚点 21 处（`4.microcanonical` … `4.isobaric`，见 `chapters/chap04.tex` 末尾注释块）。第 2 章已埋锚点的 mixing entropy（原文作 entropy of mixing）、thermodynamic limit 本章只保留意大利斜体英文，原先重复埋下的两处锚点已删除；entropy、equilibrium、enthalpy、susceptibility、ideal gas 等第 1 章已锚定的词同样只保留斜体。
  - 图占位：`fig/fig4-1`…`fig4-11`（用户自行截图，命名 `fig4-<图号>.png|jpg|pdf`）。
  - `errata.tex`：第 4 章正文未发现新的笔误条目；「非翻译性改动」表新增第 4 章正文起止页、图 4.1–4.11、以及混合熵/热力学极限不重复埋锚点三条记录。
  - 术语锚点最终清单（用户拍板后）：本章埋锚点 22 处，即注释块「附录 B 候选」全部条目（含新增的 identical「全同」、distinct「不同」、average energy）；第零/第一/第二定律、Helmholtz 自由能、Gibbs 自由能、巨势的锚点改记到第 1 章（见下）。
- **第 5 章 相互作用粒子 Interacting particles（正文 p.126–148 上半）已译完，待用户验收**：式 (5.1)–(5.90)、图 5.1–5.6（占位框），`main.pdf` 共 114 页；脚本核对 90 个公式编号连续无缺号、6 个图号与原文一致；零失效引用、零重复标签；唯一 Overfull 为第 1 章 p.175 处 0.95pt 的历史遗留。
  - 页码确认：正文自 **p.126**（5.1 累积量展开）起、至 **p.148 上半页**（式 5.90 与临界指数收尾段）止；习题 p.148–155 不译。小节起始页：5.1 p.126 / 5.2 p.130 / 5.3 p.134 / 5.4 p.138 / 5.5 p.140 / 5.6 p.143 / 5.7 p.145 / 5.8 p.146。
  - 术语锚点：本章埋锚点 **25 处**（`5.pairwise`、`5.translational`、`5.cumulant-expansion`、`5.symmetry-factor`、`5.disjoint`、`5.disconnected`、`5.one-particle-reducible`、`5.one-particle-irreducible`、`5.hard-core`、`5.virial-expansion`、`5.virial-coefficients`、`5.linked-cluster`、`5.fugacity`、`5.excluded-volume`、`5.ring-diagrams`、`5.dense-gas`、`5.van-der-waals-params`、`5.maxwell-construction`、`5.uniform-density`、`5.gibbs-inequality`、`5.corresponding-states`、`5.critical-isochore`、`5.first-order`、`5.second-order`、`5.critical-exponents`，详见 `chapters/chap05.tex` 末尾注释块）。
  - 回补第 1 章锚点（按用户「凡原文中第一次出现的术语都加入」的裁定）：`1.van-der-waals-eq`（van der Waals equation，p.26）、`1.critical-point`（p.26）、`1.critical-isotherm`（p.26）；第 5 章相应位置改作「中文（*English*）」形式，未重复埋锚点。
  - 图占位：`fig/fig5-1`…`fig5-6`（用户自行截图，命名 `fig5-<图号>.png|jpg|pdf`）。
  - `errata.tex` 新增一条：p.135 原文「in the high-temperature limit, $\beta u_0\gg1$」中 $\beta u_0\gg1$ 与「高温极限」矛盾（疑为 $\ll1$），讲义照原文译出；用户裁决「先不处理」，该条保留在清单中备查。
  - 用户拍板（第 5 章交付后）：(1) p.135 的 errata 条目**先不处理**；(2) 小节标题为**粗体**、非斜体，标题里的词**不收录**（`chap03`/`chap04`/`chap05` 末尾注释块的相应表述已更正）；(3) 图 5.1–5.6 的占位框**先不处理**（用户自行截图）。另按用户要求：**附录 A 不记页码，改为逐条列出量纲**（`appendices/appendixA.tex` 表头已改）。
- **第 6 章 量子统计力学 Quantum statistical mechanics（正文 p.156–175 中部）已译完，待用户验收**：式 (6.1)–(6.93)、图 6.1–6.7（占位框；本章无表格），`main.pdf` 共 130 页；脚本核对 93 个公式编号连续无缺号（6.1–6.93，每一处 `\newlabel{eq:6.N}` 的编号都等于 6.N）、7 个图号与原文 Fig. 6.1–6.7 逐一一致；零失效引用、零重复标签；唯一 Overfull 为第 1 章 p.175 处 0.95pt 的历史遗留。
  - 页码核对（重要）：正文自 **p.156**（p.156 首行即章标题「6 Quantum statistical mechanics」）起、至 **p.175 中部**（式 6.93 与扩散方程的收尾段）止；同页「Problems for chapter 6」起为习题（p.175–180），不译。**旧页码表所记第 6 章正文自 161 起有误，已修正为 156–175。** 小节起始页：6.1 p.156 / 6.2 p.161 / 6.3 p.167 / 6.4 p.170 / 6.5 p.172。顺带核对：**第 7 章正文自 p.181 起**（p.181 首行即「7 Ideal quantum gases」），旧表所记 185 有误，已修正。
  - 译程备注：chap06.tex 初次编译时有 17.3pt（p.157 正则变换括注）、17.5pt（p.167 周期性边界条件下波矢一段）、4.0pt（p.168 零点压力 $P_0$ 一段）三处 Overfull，均为段落内行内公式过宽、行内断点不足所致；已在相应段落就地加 `\emergencystretch=2em`（局部、不影响其它章节）消除，译文措辞与公式均未改。
  - 术语锚点：本章埋锚点 **37 处**（`6.stiffness` … `6.thermal-wavelength`，逐条见 `chapters/chap06.tex` 末尾注释块）。positive definite、normal modes、canonical、translation symmetry、microstates、macrostates、ensemble、unbiased、mixed / pure state、equilibrium、microcanonical / canonical / grand canonical ensemble 等前章已锚定，本章只保留意大利斜体英文、不重复埋锚点；本章小节标题（6.1 Dilute polyatomic gases … 6.5 Quantum macrostates）与行内小标题（如 p.174 的 \textbf{例子。}）按用户裁决一律为粗体、非斜体，标题里的词不收录、不埋锚点。
  - 图占位：`fig/fig6-1`…`fig6-7`（用户自行截图，命名 `fig6-<图号>.png|jpg|pdf`）。
  - `errata.tex`：第 6 章正文未发现新的原文笔误条目；「非翻译性改动」表新增第 6 章正文起止页、图 6.1–6.7、第 6 章三处溢出行处理、第 7 章起始页修正四条记录。
- **第 7 章 理想量子气体 Ideal quantum gases（正文 p.181–202 上半）已译完，待用户验收**：式 (7.1)–(7.68)、图 7.1–7.16（占位框；本章无表格），`main.pdf` 共 159 页（含附录 A、B）；脚本核对 68 个公式编号连续无缺号（7.1–7.68，每一处 `\newlabel{eq:7.N}` 的编号都等于 7.N）、16 个图号与原文 Fig. 7.1–7.16 逐一一致，且各图所在页码与原文文本层给出的页码逐一吻合（图 7.1 p.186 / 7.2–7.6 p.191–193 / 7.7–7.10 p.195–197 / 7.11–7.16 p.198–201）；零失效引用、零重复标签；唯一 Overfull 仍是第 1 章 p.175 处 0.95pt 的历史遗留。
  - 页码核对（重要）：正文自 **p.181**（p.181 首行即章标题「7 Ideal quantum gases」）起、至 **p.202 上半页**（式 7.68 的旋子谱与中子散射证实段）止；同页下半起为「Problems for chapter 7」（p.202–210），不译。**旧页码表所记「正文 181–201、习题 203–210」有误，已修正为正文 181–202、习题 202–210。** 小节起始页：7.1 p.181 / 7.2 p.184 / 7.3 p.187 / 7.4 p.188 / 7.5 p.190 / 7.6 p.194 / 7.7 p.198。
  - 术语锚点：本章埋锚点 **30 处**（`7.anyons` … `7.rotons`，逐条见 `chapters/chap07.tex` 末尾注释块）。任意子、奇偶性、表示、自旋、自旋简并度、平均（玻色/费米）占有数、量子简并极限、费米能/费米海/费米波数/费米压强/费米温度、Sommerfeld 展开、玻色–爱因斯坦凝聚、Clausius–Clapeyron 方程、超流体、机械热效应、喷泉效应、正常密度、热扩散、二流体模型、正常/超流成分、超漏、旋子等均为原文首次出现，故锚点在本章；逸度、维里系数、热波长、声子、理想气体、熵、化学势、占有数、密度矩阵、波函数、本征态、相空间、配分函数、系综、巨正则系综等前章已锚定，本章只保留中文译名、不重复埋锚点（附录 B 页码仍取首次出现处）。
  - 小节标题（7.1 Hilbert space of identical particles … 7.7 Superfluid He⁴）按用户裁决一律为粗体、非斜体，标题里的词不收录、不埋锚点。
  - 译程备注（均为排版层面，详见 `errata.tex`）：式 (7.22) 由原文单行改为 `aligned` 两行排布；p.185 一段就地加 `\emergencystretch=2em`；7.7 节标题的 He⁴ 用 `\texorpdfstring` 包裹以消除 PDF 书签告警。译文措辞与全部公式内容均未改动。
  - 图占位：`fig/fig7-1`…`fig7-16`（用户自行截图，命名 `fig7-<图号>.png|jpg|pdf`）。
  - `errata.tex`：第 7 章正文经逐页核对未发现新的原文笔误条目。
- **附录 A、B 已补齐（第 7 章交付时一并完成；附录 B 排版于 2026-09-16 定稿）**：附录 A「物理量符号及含义」按章分组列出全书物理量与关键统计量约 110 条，逐条给出**量纲**（基本量纲 $\mathsf{M}$、$\mathsf{L}$、$\mathsf{T}$、$\Theta$、$\mathsf{I}$ 与粒子数 $\mathsf{N}$），**不记页码**；同一符号在不同章表示不同物理量时（$\Omega$、$\rho$、$\mu$）分别列出。附录 B「术语中英文对照」由 `_extract/make_appendixB.sh` 从各章 `\term` 锚点自动抽取生成（按全书首次出现排序、按 key 去重保序），共 **262 条**，页码由 `\pageref{term:key}` 自动取；改动正文锚点后重跑该脚本即可同步。两表均改用 `xltabular`（`preamble.tex` 新增该宏包）以支持跨页。**附录 B 英文列排版**：不用意大利斜体，统一 Times New Roman 正体（`\glossaryfont`），并按「人名与专有名词缩写保留首字母大写、其余词条首字母小写」的规则生成（见下方拍板第 5 条）。
- **用户拍板（第 3 章交付后）：凡原文中第一次出现的术语一律收入附录 B**。即各章术语清单里「附录 B 候选」一栏的条目全部收录，不再逐个筛选；仍只在全书首次出现处埋 `\term` 锚点（附录 B 的页码取该锚点）。强调性斜体（`\emph{}`）依旧不收录。
- **用户要求（第 4 章交付后）：每执行完一轮对话，在交付报告里报告当前对话的体积**（本机 DeepSeek 单请求约 55 MB 上限，历史图片是主要风险），以便用户判断是否需要开新任务。
- **用户拍板（第 4 章交付后）**：
  1. 「回第 1 章首次出现处补锚点」：已在 `chap01.tex` 为 **Helmholtz 自由能（p.17）、Gibbs 自由能（p.18）、巨势（p.18）** 补埋 `\term` 锚点；同批补埋 **热力学第零定律（p.2）、第一定律（p.6）、第二定律（p.9）**，并按「凡第一次出现的都加入」的原则一并补了 **第三定律（p.26）**（用户未单独提及，如不要可撤）。第 4 章相应位置改为「中文（*English*）」形式、不重复埋锚点。
  2. identical / distinct **收录**，词条写作「**全同**」「不同」（第 4 章正文措辞已按此改写）；**此后所有术语都必须采用规范的中文物理学术词汇翻译**。
  3. average energy **收录**（锚点在 p.113）。
  4. 第零/第一/第二定律 **收录**（锚点在第 1 章）。
  5. Boltzmann 等先验平衡概率假设 **不收录**（仍以 `\emph{}`／`\textit{}` 呈现）。
- **用户拍板与要求（第 7 章交付时）**：
  1. 第 7 章习题自 **p.202 下半页**起（旧表记 203 起），页码表已据此修正；「跳过页码」清单同步改为 202–210。
  2. 本轮**不再回头复查第 1–6 章内容**（用户明确要求，避免上下文溢出），只做第 7 章、附录 A/B 与全文编译检查。
  3. 附录 A 只列符号、含义与**量纲**，不记页码；附录 B 的页码由术语锚点自动取（沿用第 5 章交付后的裁定）。
  4. 遗留项已拍板（2026-09-16）：p.198 的 **wetting agent** 定译「**润湿剂**」（原「浸润剂」）；p.192 的 **fermi pressure** 定译「**费米压强**」（原「费米压」）。两处均已改 `chapters/chap07.tex` 正文术语名、该章末尾注释块，以及 `appendices/appendixA.tex` 的对应条目。
  5. **附录 B 英文列排版**（2026-09-16 拍板）：英文**不用意大利斜体**，统一用 **Times New Roman 正体**（字体族在 `preamble.tex` 中定义为 `\glossaryfont`）；**人名**（Boltzmann、Gibbs、Stirling、Levy、Wick 等）与**专有名词缩写**（PDF）保留首字母大写，其余词条的首字母**一律小写**；原文本来写作小写的（如 `fermi energy`、`van der Waals equation`）保持原样。该规则由 `_extract/make_appendixB.sh` 在生成时自动执行，各章正文里 `\term` 的英文拼写不改动。

## 七、各章页码范围（正文）

| 章 | 标题 | 正文页 | 习题页 |
| --- | --- | --- | --- |
| 1 | Thermodynamics 热力学 | 1–29 | 29–33 |
| 2 | Probability 概率论 | 35–52 | 53–55 |
| 3 | Kinetic theory of gases 气体动理论 | 57–87（正文止于 p.87 上半页） | 87–97 |
| 4 | Classical statistical mechanics 经典统计力学 | 98–120（正文止于 p.120 上半页） | 120–125 |
| 5 | Interacting particles 相互作用粒子 | 126–148（正文止于 p.148 上半页） | 148–155 |
| 6 | Quantum statistical mechanics 量子统计力学 | 156–175（正文止于 p.175 中部） | 175–180 |
| 7 | Ideal quantum gases 理想量子气体 | 181–202（正文止于 p.202 上半页） | 202–210 |

（第 3 章页码已用 `text.pdf` 核对修正为 57–87；第 4 章已核对修正为 98–120；第 5 章已核对修正为 126–148；**第 6 章已核对修正为 156–175**。
第 6 章核对时正式确认：第 6 章正文自 **p.156** 起（p.156 首行即「6 Quantum statistical mechanics」），至 **p.175 中部**止（式 6.93 与扩散方程收尾段），同页起为「Problems for chapter 6」（p.175–180）；旧表所记 161 有误，已修正。
**第 7 章已核对修正为 181–202**（习题 202–210）。
第 7 章核对结论：正文自 **p.181** 起（p.181 首行即章标题「7 Ideal quantum gases」），至 **p.202 上半页**止（式 7.68 的旋子谱与 Landau 谱的中子散射证实段）；同页下半起为「Problems for chapter 7」（p.202–210）。**旧表所记「正文 181–201、习题 203–210」有误**，本表已改为正文 181–202、习题 202–210。
全书正文页码至此全部核对完毕：1–29、35–52、57–87、98–120、126–148、156–175、181–202；余下各页为习题，不译。）

## 八、预算

第 1 章约 13 万 token；全书 7 章预估 100–120 万 token，预留 150 万。
