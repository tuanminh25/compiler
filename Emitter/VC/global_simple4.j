.class public global_simple4
.super java/lang/Object
	
.field static x F
	
	; standard class static initializer 
.method static <clinit>()V
	
	fconst_0
	putstatic global_simple4/x F
	
	; set limits used by this method
.limit locals 0
.limit stack 1
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
.var 1 is vc$ Lglobal_simple4; from L0 to L1
	new global_simple4
	dup
	invokenonvirtual global_simple4/<init>()V
	astore_1
	iconst_3
	i2f
	putstatic global_simple4/x F
	return
L1:
	return
	
	; set limits used by this method
.limit locals 2
.limit stack 2
.end method
