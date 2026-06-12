#!/usr/bin/env bash

OUT="illegal_results.txt"
> "$OUT"

for i in $(seq 19 27); do
  f="Recogniser/t${i}.vc"
  [ -e "$f" ] || continue
  echo "=== t${i}.vc ===" | tee -a "$OUT"
  java VC.vc "$f" >> "$OUT" 2>&1
  echo "" >> "$OUT"
done

echo "Done. Results in $OUT"