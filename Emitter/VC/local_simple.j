.class public local_simple
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
.var 1 is vc$ Llocal_simple; from L0 to L1
	new local_simple
	dup
	invokenonvirtual local_simple/<init>()V
	astore_1
.var 2 is a I from L0 to L1
	iconst_5
	istore_2
.var 3 is x F from L0 to L1
	fconst_0
	fstore_3
	iload_2
	i2f
	fstore_3
	return
L1:
	return
	
	; set limits used by this method
.limit locals 4
.limit stack 2
.end method
