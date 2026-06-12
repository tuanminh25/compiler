#!/usr/bin/env bash

javac vc.java
# java VC.vc mytest/unary1.vc
# java VC.vc mytest/binary1.vc

# java VC.vc mytest/localvardecl.vc
# java VC.vc mytest/simplevar.vc

java VC.vc Checker/t1.vc > Checker/my_t1
diff Checker/my_t1 Checker/t1.sol

java VC.vc Checker/t2.vc > Checker/my_t2
diff Checker/my_t2 Checker/t2.sol

# java VC.vc mytest/legal_complex.vc
# java VC.vc mytest/array.vc
# java VC.vc  mytest/gap.vc
