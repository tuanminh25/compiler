.class public local_simple2
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
.var 1 is vc$ Llocal_simple2; from L0 to L1
	new local_simple2
	dup
	invokenonvirtual local_simple2/<init>()V
	astore_1
.var 2 is b F from L0 to L1
	ldc 3.5
	fstore_2
.var 3 is x F from L0 to L1
	fconst_0
	fstore_3
	fload_2
	fstore_3
	return
L1:
	return
	
	; set limits used by this method
.limit locals 4
.limit stack 2
.end method
