#!/usr/bin/env bash

VC_DIR="/import/adams/3/z5381092/COMP3131/ass5/VC"

INPUT="${1:?Usage: e.sh <testname>}"

javac vc.java
java -ea VC.vc "$INPUT"


echo ""
echo "=== CHECKPOINT 2: Assembling with Jasmin ==="
if printf 'jasmin "%s"\n' "${INPUT%.vc}.j" | 3131; then
    echo "PASS: Jasmin assembled successfully"
else
    echo "FAIL: Jasmin assembly failed"
    exit 1
fi

echo ""
echo "=== CHECKPOINT 3: Running the compiled program ==="
if java "${INPUT%.vc}"; then
    echo "PASS: Program ran successfully"
else
    echo "FAIL: Program execution failed"
    exit 1
fi


code "${INPUT%.vc}.j"