#!/usr/bin/env bash
# 编译勘误清单（独立文档）
set -euo pipefail

XELATEX=/Library/TeX/texbin/xelatex
cd "$(dirname "$0")"

$XELATEX -interaction=nonstopmode -halt-on-error errata.tex
$XELATEX -interaction=nonstopmode -halt-on-error errata.tex

echo "---- 完成：errata.pdf ----"
