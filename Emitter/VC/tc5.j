.class public tc5
.super java/lang/Object
	
.field static a [I
.field static fa [F
	
	; standard class static initializer 
.method static <clinit>()V
	
	iconst_3
	newarray int
	dup
	iconst_0
	iconst_2
	iastore
	dup
	iconst_1
	iconst_4
	iastore
	dup
	iconst_2
	bipush 6
	iastore
	putstatic tc5/a [I
	iconst_3
	newarray float
	dup
	iconst_0
	ldc 1.5
	fastore
	dup
	iconst_1
	ldc 2.5
	fastore
	dup
	iconst_2
	ldc 3.0
	fastore
	putstatic tc5/fa [F
	
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
.var 1 is vc$ Ltc5; from L0 to L1
	new tc5
	dup
	invokenonvirtual tc5/<init>()V
	astore_1
.var 2 is x F from L0 to L1
	getstatic tc5/a [I
	iconst_0
	iaload
	i2f
	getstatic tc5/fa [F
	iconst_0
	faload
	fadd
	fstore_2
.var 3 is y F from L0 to L1
	getstatic tc5/fa [F
	iconst_2
	faload
	getstatic tc5/a [I
	iconst_1
	iaload
	i2f
	fsub
	fstore_3
.var 4 is z F from L0 to L1
	getstatic tc5/a [I
	iconst_2
	iaload
	i2f
	getstatic tc5/fa [F
	iconst_1
	faload
	fmul
	fstore 4
.var 5 is w F from L0 to L1
	getstatic tc5/fa [F
	iconst_2
	faload
	getstatic tc5/a [I
	iconst_0
	iaload
	i2f
	fdiv
	fstore 5
	return
L1:
	return
	
	; set limits used by this method
.limit locals 6
.limit stack 3
.end method
