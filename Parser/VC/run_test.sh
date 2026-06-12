#!/bin/bash
javac vc.java

TESTS=(
  t0 t1 t2 t3 t4 t5 t6 t7 t8 t9 t10
  t11 t12 t13 t14 t15 t16 t17 t18 t19 t20
  t21 t22 t23 t24 t24a t24b t24c t25 t26 t27
  t28 t29 t30 t31 t32 t33 t34 t34 t35 t36
  t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47
)

for t in "${TESTS[@]}"; do
  java VC.vc -u Parser/unparsed_${t} Parser/${t}.vc

  if ! diff -q Parser/unparsed_${t} Parser/${t}.sol > /dev/null 2>&1; then
    echo "FAIL: ${t}"
    diff Parser/unparsed_${t} Parser/${t}.sol
    exit 1
  fi

  echo "PASS: ${t}"
done

echo "All tests passed!"