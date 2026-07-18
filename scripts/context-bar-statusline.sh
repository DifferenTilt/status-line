#!/usr/bin/env bash
# Statusline: barra di utilizzo del contesto con scala non lineare.
# Ingrandisce visivamente l'occupazione reale per spingere a tenere il contesto pulito:
# a 30% reale la barra è già gialla e piena al ~58% (displayed = 100*(real/100)^0.42).

set -euo pipefail

INPUT=$(cat)

jq -r '
  def fmtk:
    if . >= 1000000 then
      ((./1000000*10|round)/10) as $v
      | (if $v == ($v|floor) then ($v|floor|tostring) else ($v|tostring) end) + "M"
    elif . >= 1000 then
      ((./1000*10|round)/10) as $v
      | (if $v == ($v|floor) then ($v|floor|tostring) else ($v|tostring) end) + "k"
    else
      (.|round|tostring)
    end;
  (.context_window.used_percentage // 0) as $real0
  | (if $real0 > 100 then 100 elif $real0 < 0 then 0 else $real0 end) as $real
  | (100 * pow(($real/100); 0.42)) as $disp0
  | (if $disp0 > 100 then 100 elif $disp0 < 0 then 0 else $disp0 end) as $disp
  | 24 as $width
  | (($disp / 100 * $width) | floor) as $filled
  | ($width - $filled) as $empty
  | (if $real < 30 then "[32m"
     elif $real < 60 then "[33m"
     elif $real < 85 then "[38;5;208m"
     else "[31m" end) as $color
  | "[0m" as $reset
  | "[2m" as $dim
  | "[97m" as $white
  | (.model.display_name // "Claude") as $model
  | (.context_window.total_input_tokens // 0) as $used
  | (.context_window.context_window_size // 200000) as $max
  | ([range($filled)] | map("█") | join("")) as $filledbar
  | ([range($empty)] | map("░") | join("")) as $emptybar
  | ($model + " " + $dim + "ctx" + $reset + " " + $white + "[" + $reset + $color + $filledbar + $emptybar + $reset + $white + "] " + $reset + ($real|round|tostring) + "%" + $reset + " " + $dim + "(" + ($used|fmtk) + "/" + ($max|fmtk) + ")" + $reset)
' <<< "$INPUT"
