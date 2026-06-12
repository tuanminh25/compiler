#!/usr/bin/env bash
set -e
VC_DIR="/import/adams/3/z5381092/COMP3131/ass5/VC"
TESTS=("max.vc" "gcd.vc" "bubble.vc")

cd "$VC_DIR"

echo "=== Compiling VC compiler ==="
javac vc.java || { echo "FAIL: Could not compile VC compiler"; exit 1; }
echo "OK"

for TEST_VC in "${TESTS[@]}"; do
    BASENAME="${TEST_VC%.vc}"
    TEST_J="$BASENAME.j"
    EXPECT="new//$BASENAME.j"

    echo ""
    echo "========================================"
    echo "TEST: $TEST_VC"
    echo "========================================"

    echo "--- Running VC compiler ---"
    java -ea VC.vc "$TEST_VC" || { echo "FAIL: compiler crashed"; exit 1; }

    echo "--- Comparing .j against expected ---"
    diff "$TEST_J" "$EXPECT" || { echo "FAIL: .j mismatch (see diff above)"; exit 1; }
    echo "PASS: .j matches"

    echo "--- Assembling with Jasmin ---"
    printf 'jasmin "%s"\n' "$TEST_J" | 3131 || { echo "FAIL: Jasmin failed"; exit 1; }
    echo "PASS: Jasmin OK"
done

echo ""
echo "=== All tests passed ==="