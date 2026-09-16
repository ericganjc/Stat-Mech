#!/usr/bin/env bash
# 统计力学自学讲义：编译脚本（xelatex 双遍，解析目录与交叉引用）
set -euo pipefail

XELATEX=/Library/TeX/texbin/xelatex
cd "$(dirname "$0")"

$XELATEX -interaction=nonstopmode -halt-on-error main.tex
$XELATEX -interaction=nonstopmode -halt-on-error main.tex

echo "---- 检查：排版溢出 / 失效引用 ----"
grep -nE "Overfull|Float too large|Reference .* undefined|LaTeX Warning: Citation" main.log | head -40 || true
echo "---- 完成：main.pdf ----"
