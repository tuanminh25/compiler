#!/usr/bin/env bash

VC_DIR="/import/adams/3/z5381092/COMP3131/ass5/VC"

# Accept input file as first argument, default to mytest/simple.vc
INPUT="${1:-mytest/simple.vc}"

# Derive .j and _expect paths from the input filename
BASENAME="${INPUT%.vc}"      # strip .vc extension
TEST_VC="$BASENAME.vc"
TEST_J="$BASENAME.j"
# EXPECT="${BASENAME}_expect"
EXPECT="new/${BASENAME}.j"
# EXPECT="mytest/${BASENAME}.j"

# Class name for `java` invocation: strip leading ./, convert path separators to dots, strip extension
CLASS=$(echo "$BASENAME" | sed 's|^\./||; s|/|.|g; s|\.[^.]*$||')

cd "$VC_DIR"

echo "=== Compiling VC compiler ==="
javac vc.java || { echo "FAIL: Could not compile VC compiler"; exit 1; }
echo "OK: VC compiler compiled"

echo ""
echo "========================================"
echo "TEST: $TEST_VC"
echo "========================================"

echo ""
echo "=== Running VC compiler on $TEST_VC ==="
java -ea VC.vc "$TEST_VC" || { echo "FAIL: VC compiler crashed on $TEST_VC"; exit 1; }
echo "OK: .j file generated at $TEST_J"

echo ""
echo "=== CHECKPOINT 1: Comparing generated .j against expected ==="
if diff "$TEST_J" "$EXPECT"; then
    echo "PASS: .j file matches expected"
else
    echo "FAIL: .j file does not match expected (see diff above)"
    exit 1
fi

echo ""
echo "=== CHECKPOINT 2: Assembling with Jasmin ==="
if printf 'jasmin "%s"\n' "$TEST_J" | 3131; then
    echo "PASS: Jasmin assembled successfully"
else
    echo "FAIL: Jasmin assembly failed"
    exit 1
fi

# echo ""
# echo "=== CHECKPOINT 3: Running the compiled program ==="
# if java "$CLASS"; then
#     echo "PASS: Program ran successfully"
# else
#     echo "FAIL: Program execution failed"
#     exit 1
# fi

echo ""
echo "=== All checkpoints passed ==="
