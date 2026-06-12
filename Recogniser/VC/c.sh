#!/usr/bin/env bash

javac vc.java


PASS=0
FAIL=0
SKIP=0

for f in Recogniser/t*.vc; do
  [ -e "$f" ] || continue
  b="${f%.vc}"
  base=$(basename "$b")

  # Skip t19-t27 (illegal VC programs, no exact match required)
  num=$(echo "$base" | sed 's/t//')
  if [ "$num" -ge 19 ] && [ "$num" -le 27 ] 2>/dev/null; then
    echo "SKIP: $f (illegal program, no exact match required)"
    ((SKIP++))
    continue
  fi

  java VC.vc "$f" > "${b}.out" 2>&1

  if diff -u "${b}.sol" "${b}.out" > /dev/null 2>&1; then
    echo "PASS: $f"
    ((PASS++))
  else
    echo "FAIL: $f"
    diff -u "${b}.sol" "${b}.out"
    ((FAIL++))
  fi
done

echo ""
echo "Results: $PASS passed, $FAIL failed, $SKIP skipped"


# #!/bin/bash


# # java VC.vc my_tests/empty.vc
# java VC.vc my_tests/func-decl.vc
# # java VC.vc my_tests/var-decl.vc

