#!/usr/bin/env bash
# 渲染原文 PDF 的指定页范围，并缩图（最长边 1200px）后只保留 -small.jpg
# 用法：bash _extract/render.sh <起始页> <结束页> [输出目录]
set -euo pipefail

first=$1
last=$2
out=${3:-/Users/ericgan/PhD/Statistical-Mechanics/_extract/pages}
pdf=${SRC_PDF:-/Users/ericgan/PhD/Statistical-Mechanics/text.pdf}

PB=/Users/ericgan/.cache/codex-runtimes/codex-primary-runtime/dependencies/bin/override/pdftoppm

mkdir -p "$out"
"$PB" -png -r 150 -f "$first" -l "$last" "$pdf" "$out/p"
for f in "$out"/p-*.png; do
  bash /Users/ericgan/.codex/tools/shrink-image.sh "$f" >/dev/null
  rm -f "$f"
done
ls "$out"
