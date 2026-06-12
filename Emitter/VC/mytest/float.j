.class public mytest/float
.super java/lang/Object
	
	
	; standard class static initializer 
.method static <clinit>()V
	
	
	; set limits used by this method
.limit locals 0
.limit stack 0
	return
.end method
	
	; standard constructor initializer 
.method public <init>()V
.limit stack 1
.limit locals 1
	aload_0
	invokespecial java/lang/Object/<init>()V
	return
.end method
.method public static main([Ljava/lang/String;)V
L0:
.var 0 is argv [Ljava/lang/String; from L0 to L1
.var 1 is vc$ Lmytest/float; from L0 to L1
	new mytest/float
	dup
	invokenonvirtual mytest/float/<init>()V
	astore_1
.var 2 is a F from L0 to L1
	fconst_0
	fstore_2
.var 3 is b F from L0 to L1
	ldc 0.1
	fstore_3
.var 4 is c F from L0 to L1
	fload_2
	fload_3
	fsub
	fstore 4
.var 5 is d F from L0 to L1
	fload_2
	fload_3
	fadd
	fstore 5
	return
L1:
	return
	
	; set limits used by this method
.limit locals 6
.limit stack 2
.end method
