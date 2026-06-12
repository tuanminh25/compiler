.class public global
.super java/lang/Object
	
.field static a I
.field static b F
.field static c F
.field static d Z
.field static e Z
.field static g F
	
	; standard class static initializer 
.method static <clinit>()V
	
	bipush 10
	putstatic global/a I
	bipush 20
	i2f
	putstatic global/b F
	ldc 1.12
	fneg
	putstatic global/c F
	iconst_1
	putstatic global/d Z
	iconst_0
	putstatic global/e Z
	getstatic global/a I
	i2f
	putstatic global/g F
	
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
.var 1 is vc$ Lglobal; from L0 to L1
	new global
	dup
	invokenonvirtual global/<init>()V
	astore_1
	return
L1:
	return
	
	; set limits used by this method
.limit locals 2
.limit stack 2
.end method
