.class public tc6
.super java/lang/Object
	
.field static a [I
	
	; standard class static initializer 
.method static <clinit>()V
	
	iconst_3
	newarray int
	dup
	iconst_0
	bipush 10
	iastore
	dup
	iconst_1
	bipush 20
	iastore
	dup
	iconst_2
	bipush 30
	iastore
	putstatic tc6/a [I
	
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
.var 1 is vc$ Ltc6; from L0 to L1
	new tc6
	dup
	invokenonvirtual tc6/<init>()V
	astore_1
.var 2 is b [F from L0 to L1
	iconst_3
	newarray float
	dup
	iconst_0
	fconst_0
	fastore
	dup
	iconst_1
	fconst_0
	fastore
	dup
	iconst_2
	fconst_0
	fastore
	astore_2
	aload_2
	iconst_0
	getstatic tc6/a [I
	iconst_0
	iaload
	i2f
	fastore
	aload_2
	iconst_1
	getstatic tc6/a [I
	iconst_1
	iaload
	i2f
	fastore
	aload_2
	iconst_2
	getstatic tc6/a [I
	iconst_2
	iaload
	i2f
	fastore
	return
L1:
	return
	
	; set limits used by this method
.limit locals 3
.limit stack 4
.end method
