.class public local_simple3
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
.method foo(FI)F
L0:
.var 0 is this Llocal_simple3; from L0 to L1
.var 1 is x F from L0 to L1
.var 2 is a I from L0 to L1
	iload_2
	i2f
	fstore_1
	fload_1
	freturn
L1:
	nop
	
	; set limits used by this method
.limit locals 3
.limit stack 1
.end method
.method public static main([Ljava/lang/String;)V
L0:
.var 0 is argv [Ljava/lang/String; from L0 to L1
.var 1 is vc$ Llocal_simple3; from L0 to L1
	new local_simple3
	dup
	invokenonvirtual local_simple3/<init>()V
	astore_1
	return
L1:
	return
	
	; set limits used by this method
.limit locals 2
.limit stack 2
.end method
