.class public tc1
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
.var 1 is vc$ Ltc1; from L0 to L1
	new tc1
	dup
	invokenonvirtual tc1/<init>()V
	astore_1
.var 2 is c [I from L0 to L1
	iconst_3
	newarray int
	dup
	iconst_0
	iconst_5
	iastore
	dup
	iconst_1
	bipush 10
	iastore
	dup
	iconst_2
	bipush 15
	iastore
	astore_2
.var 3 is x I from L0 to L1
	aload_2
	iconst_0
	iaload
	istore_3
.var 4 is y I from L0 to L1
	aload_2
	iconst_2
	iaload
	istore 4
	return
L1:
	return
	
	; set limits used by this method
.limit locals 5
.limit stack 4
.end method
