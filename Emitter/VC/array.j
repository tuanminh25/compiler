.class public array
.super java/lang/Object
	
.field static a [I
	
	; standard class static initializer 
.method static <clinit>()V
	
	iconst_3
	newarray int
	dup
	iconst_0
	bipush 10
	ineg
	iastore
	dup
	iconst_1
	iconst_1
	iastore
	dup
	iconst_2
	iconst_2
	iastore
	putstatic array/a [I
	
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
.var 1 is vc$ Larray; from L0 to L1
	new array
	dup
	invokenonvirtual array/<init>()V
	astore_1
.var 2 is g I from L0 to L1
	getstatic array/a [I
	iconst_0
	iaload
	istore_2
.var 3 is f I from L0 to L1
	getstatic array/a [I
	iconst_1
	iaload
	istore_3
.var 4 is j I from L0 to L1
	getstatic array/a [I
	iconst_2
	iaload
	istore 4
	return
L1:
	return
	
	; set limits used by this method
.limit locals 5
.limit stack 2
.end method
