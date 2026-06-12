#!/usr/bin/env bash

# javac vc.java

# java VC.vc Recogniser/t9.vc 
# java VC.vc my_tests/hard.vc

# for f in my_tests/*.vc; do
#   echo "=== $f ==="
#   java VC.vc "$f"
# done




# java VC.vc my_tests/string_lit.vc
# java VC.vc my_tests/boolean_lit.vc
# java VC.vc my_tests/float_lit.vc
# java VC.vc my_tests/int_lit.vc
# java VC.vc my_tests/operator_accept.vc
# java VC.vc my_tests/string_expr.vc
# java VC.vc my_tests/bool_expr.vc
# java VC.vc  my_tests/float_expr.vc
# java VC.vc  my_tests/int_expr.vc
# java VC.vc  my_tests/_expr.vc

# java VC.vc  my_tests/unary_expr.vc
# java VC.vc  my_tests/mult_expr.vc
# java VC.vc  my_tests/add_expr.vc
# java VC.vc  my_tests/rel_expr.vc
# java VC.vc  my_tests/eq_expr.vc
# java VC.vc  my_tests/condAND_expr.vc
# java VC.vc  my_tests/condOR_expr.vc
# java VC.vc  my_tests/singleAssign_expr.vc
# java VC.vc  my_tests/manyAssign_expr.vc

# java VC.vc  my_tests/complex_expr.vc
# java VC.vc  my_tests/complex_arg.vc

# java VC.vc  my_tests/proper_arglist.vc

# java VC.vc  my_tests/arglist_full.vc
# java VC.vc  my_tests/arglist_empty.vc


# java VC.vc  my_tests/iden_arrayExpr.vc
# java VC.vc  my_tests/iden_expr.vc
# java VC.vc  my_tests/iden_only.vc
# java VC.vc  my_tests/iden_arglist.vc

# java VC.vc  my_tests/types.vc
# java VC.vc  my_tests/empty_expr_stmt.vc
# java VC.vc  my_tests/expr_stmt.vc

# java VC.vc  my_tests/return_stmt.vc
# java VC.vc  my_tests/return_empty_stmt.vc

# java VC.vc  my_tests/continue_stmt.vc
# java VC.vc  my_tests/break_stmt.vc


# java VC.vc  my_tests/while_stmt.vc
# java VC.vc  my_tests/for1_stmt.vc
# java VC.vc  my_tests/for1_stmt.vc
# java VC.vc  my_tests/if_stmt.vc
# java VC.vc  my_tests/all_stmt.vc 
# java VC.vc  my_tests/compound_stmtlist.vc 
# java VC.vc  my_tests/compound_stmt_empty.vc 

# java VC.vc  my_tests/init.vc
# java VC.vc  my_tests/var.vc

# java VC.vc Parser/t3.vc 
# java VC.vc Parser/t2.vc 

# java VC.vc -u Parser/unparsed_t2 Parser/t2.vc 
# diff Parser/unparsed_t3 Parser/t3.sol



javac vc.java
# java VC.vc  my_tests/compound_stmt.vc
# java VC.vc  my_tests/proper_para_list.vc

# java VC.vc  my_tests/para_list.vc
# java VC.vc  my_tests/func.vc
# java VC.vc -u Parser/unparsed_t4 Parser/t4.vc 
# code Parser/unparsed_t4

# java VC.vc -u Parser/unparsed_t18 Parser/t18.vc 
# diff Parser/unparsed_t18 Parser/t18.sol

# java VC.vc -u Parser/unparsed_t43 Parser/t43.vc 
# diff Parser/unparsed_t43 Parser/t43.sol

# java VC.vc -u Parser/unparsed_t45 Parser/t45.vc 
# diff Parser/unparsed_t45 Parser/t45.sol


java VC.vc -u Parser/unparsed_t1 Parser/t1.vc 
diff Parser/unparsed_t1 _tp/Parser/t1.sol  
