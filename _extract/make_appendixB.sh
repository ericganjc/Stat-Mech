#!/bin/zsh
# 生成 appendices/appendixB.tex（术语中英文对照表）
# 依据：各章正文中的 \term{中文}{English}{key} 锚点，按章序（chap01 → chap07）、
#       章内出现顺序排列；同一 key 只取首次出现处；注释行（% 开头）不计入。
# 页码由 \pageref{term:key} 自动取得。
set -e
cd "$(dirname "$0")/.."

OUT=appendices/appendixB.tex

{
  print -r '% ============================================================='
  print -r '%  附录 B —— 术语中英文对照表'
  print -r '%  本文件由 _extract/make_appendixB.sh 自动生成：'
  print -r '%  逐章收集 \term{中文}{English}{key} 锚点，按首次出现顺序排列，页码用 \pageref 自动取得。'
  print -r '%  请勿手工改动表体；改动术语请改各章正文的 \term 调用后重新生成。'
  print -r '% ============================================================='
  print -r '\bichapter{术语中英文对照表}{Glossary}'
  print -r ''
  print -r '本附录收录原文中以意大利斜体标出的术语，按其在正文中首次出现的先后顺序排列。页码取自该术语在全书中首次出现的位置。'
  print -r ''
  print -r '\begin{xltabular}{\textwidth}{@{}l l c@{}}'
  print -r '  \toprule'
  print -r '  \textbf{中文术语} & \textbf{英文术语} & \textbf{页码} \\'
  print -r '  \midrule'
  print -r '  \endfirsthead'
  print -r '  \toprule'
  print -r '  \textbf{中文术语} & \textbf{英文术语} & \textbf{页码} \\'
  print -r '  \midrule'
  print -r '  \endhead'
  print -r '  \midrule'
  print -r '  \multicolumn{3}{r@{}}{\small 续下页} \\'
  print -r '  \endfoot'
  print -r '  \bottomrule'
  print -r '  \endlastfoot'
  print -r ''

  perl -CSD -e '
    # 英文列排版规则（用户 2026-09-16 拍板）：
    #   英文一律写正体（Times New Roman，由 \glossaryfont 指定），不用 \textit；
    #   除人名首字母与专有名词缩写外，其余单词首字母统一小写。
    #   —— 只把“整个术语的首字母”改为小写；人名/缩写出现在词中时保持原样。
    my @kept = qw(
      Bayes Boltzmann Bose Brillouin Carnot Casimir Clausius Debye Einstein
      Fock Fourier Gaussian Gibbs Hamilton Helmholtz Hermit Hilbert Ising Levy
      Liouville Maxwell PDF Poisson Shannon Sommerfeld Stefan Stirling Vlasov Wick
    );
    my %seen;
    for my $f (@ARGV) {
      open(my $fh, "<:encoding(UTF-8)", $f) or die "$f: $!";
      while (my $l = <$fh>) {
        next if $l =~ /^\s*%/;
        while ($l =~ /\\term\{([^{}]*)\}\{([^{}]*)\}\{([^{}]*)\}/g) {
          my ($zh, $en, $key) = ($1, $2, $3);
          next if $seen{$key}++;
          my $out = $en;
          my ($first) = $en =~ /^([A-Za-z]+)/;
          my $is_proper = 0;
          if (defined $first) {
            for my $k (@kept) {
              if (index($first, $k) == 0) { $is_proper = 1; last; }
            }
          }
          $out =~ s/^([A-Z])/\l$1/ unless $is_proper;
          print "  $zh & {\\glossaryfont $out} & \\pageref{term:$key} \\\\\n";
        }
      }
      close($fh);
    }
  ' chapters/chap01.tex chapters/chap02.tex chapters/chap03.tex chapters/chap04.tex \
    chapters/chap05.tex chapters/chap06.tex chapters/chap07.tex

  print -r '\end{xltabular}'
} > $OUT

print -r "已生成 $OUT：$(grep -c 'pageref{term:' $OUT) 条术语"
