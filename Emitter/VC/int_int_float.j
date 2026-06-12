.class public int_int_float
.super java/lang/Object
	
.field static a I
.field static b I
	
	; standard class static initializer 
.method static <clinit>()V
	
	bipush 10
	ineg
	putstatic int_int_float/a I
	bipush 10
	ineg
	putstatic int_int_float/b I
	
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
.var 1 is vc$ Lint_int_float; from L0 to L1
	new int_int_float
	dup
	invokenonvirtual int_int_float/<init>()V
	astore_1
.var 2 is g F from L0 to L1
	getstatic int_int_float/a I
	getstatic int_int_float/b I
	iadd
	i2f
	fstore_2
	return
L1:
	return
	
	; set limits used by this method
.limit locals 3
.limit stack 2
.end method
