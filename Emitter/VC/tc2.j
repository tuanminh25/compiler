.class public tc2
.super java/lang/Object
	
.field static a [I
	
	; standard class static initializer 
.method static <clinit>()V
	
	iconst_5
	newarray int
	dup
	iconst_0
	iconst_4
	iastore
	dup
	iconst_1
	bipush 6
	iastore
	dup
	iconst_2
	bipush 8
	iastore
	dup
	iconst_3
	bipush 10
	iastore
	dup
	iconst_4
	iconst_3
	iastore
	putstatic tc2/a [I
	
	; set limits used by this method
.limit locals 0
.limit stack 4
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
.var 1 is vc$ Ltc2; from L0 to L1
	new tc2
	dup
	invokenonvirtual tc2/<init>()V
	astore_1
.var 2 is x I from L0 to L1
	getstatic tc2/a [I
	iconst_0
	iaload
	getstatic tc2/a [I
	iconst_1
	iaload
	iadd
	istore_2
.var 3 is y I from L0 to L1
	getstatic tc2/a [I
	iconst_2
	iaload
	getstatic tc2/a [I
	iconst_0
	iaload
	isub
	istore_3
.var 4 is z I from L0 to L1
	getstatic tc2/a [I
	iconst_1
	iaload
	getstatic tc2/a [I
	iconst_4
	iaload
	imul
	istore 4
.var 5 is w I from L0 to L1
	getstatic tc2/a [I
	iconst_2
	iaload
	getstatic tc2/a [I
	iconst_4
	iaload
	idiv
	istore 5
	return
L1:
	return
	
	; set limits used by this method
.limit locals 6
.limit stack 3
.end method
