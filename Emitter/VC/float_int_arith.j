.class public float_int_arith
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
.var 1 is vc$ Lfloat_int_arith; from L0 to L1
	new float_int_arith
	dup
	invokenonvirtual float_int_arith/<init>()V
	astore_1
.var 2 is a F from L0 to L1
	iconst_3
	ineg
	i2f
	fstore_2
.var 3 is b I from L0 to L1
	bipush 10
	istore_3
.var 4 is c F from L0 to L1
	fload_2
	iload_3
	i2f
	fadd
	fstore 4
	return
L1:
	return
	
	; set limits used by this method
.limit locals 5
.limit stack 2
.end method
