#!/usr/bin/env bash

VC_DIR="/import/adams/3/z5381092/COMP3131/ass5/VC"

javac vc.java

for i in 1 2 3 4 5 6; do
    INPUT="tc${i}.vc"
    echo "========== Running $INPUT =========="
    java -ea VC.vc "$INPUT"
    echo ""
done