#!/usr/bin/env bash

javac vc.java
# java VC.vc Recogniser/t9.vc 

java VC.vc my_tests/global_var.vc


# for f in my_tests/*.vc; do
#   echo "=== $f ==="
#   java VC.vc "$f"
# done