#!/bin/bash

# # Compile
# javac vc.java

# # Check if compilation succeeded
# if [ $? -ne 0 ]; then
#     echo "Compilation failed"
#     exit 1
# fi

# # Run - pass test file as argument, default to tokens.vc if none provided
# TEST_FILE=${1:-mytests/empty.vc}
# java VC.vc "$TEST_FILE" 



# NEw

javac vc.java

PASSED=0
FAILED=0
FAILED_TESTS=()

for i in $(seq 1 59); do
    echo " Running test $i "
    INPUT="Scanner/official_tests/test$i"
    EXPECTED="Scanner/official_tests/result$i"
    OUTPUT="Scanner/official_tests/output$i"

    # Run the command and capture output
    java VC.vc "$INPUT" > "$OUTPUT" 2>&1

    # Compare with expected result
    if diff -q "$OUTPUT" "$EXPECTED" > /dev/null 2>&1; then
        PASSED=$((PASSED + 1))
    else
        FAILED=$((FAILED + 1))
        FAILED_TESTS+=("test$i")
    fi
done

TOTAL=$((PASSED + FAILED))
PERCENTAGE=$(echo "scale=2; $PASSED * 100 / $TOTAL" | bc)

echo "=============================="
echo " Test Results"
echo "=============================="
echo "Passed : $PASSED / $TOTAL"
echo "Failed : $FAILED / $TOTAL"
echo "Score  : $PERCENTAGE%"

if [ ${#FAILED_TESTS[@]} -gt 0 ]; then
    echo ""
    echo "Failed tests:"
    for t in "${FAILED_TESTS[@]}"; do
        echo "  - $t"
    done
fi
