.class public float_int_div
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
.var 1 is vc$ Lfloat_int_div; from L0 to L1
	new float_int_div
	dup
	invokenonvirtual float_int_div/<init>()V
	astore_1
.var 2 is a I from L0 to L1
	iconst_3
	ineg
	istore_2
.var 3 is b F from L0 to L1
	ldc 10.12312
	fstore_3
.var 4 is c F from L0 to L1
	iload_2
	i2f
	fload_3
	fdiv
	fstore 4
	return
L1:
	return
	
	; set limits used by this method
.limit locals 5
.limit stack 2
.end method
