.class public float_add
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
.var 1 is vc$ Lfloat_add; from L0 to L1
	new float_add
	dup
	invokenonvirtual float_add/<init>()V
	astore_1
.var 2 is a F from L0 to L1
	ldc 10.1
	fstore_2
.var 3 is b F from L0 to L1
	ldc 10.2
	fstore_3
.var 4 is c F from L0 to L1
	fload_2
	fload_3
	fadd
	fstore 4
	return
L1:
	return
	
	; set limits used by this method
.limit locals 5
.limit stack 2
.end method
