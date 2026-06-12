.class public local_global
.super java/lang/Object
	
.field static a I
.field static b F
.field static c F
	
	; standard class static initializer 
.method static <clinit>()V
	
	bipush 10
	ineg
	putstatic local_global/a I
	bipush 20
	i2f
	putstatic local_global/b F
	getstatic local_global/a I
	i2f
	putstatic local_global/c F
	
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
.var 1 is vc$ Llocal_global; from L0 to L1
	new local_global
	dup
	invokenonvirtual local_global/<init>()V
	astore_1
.var 2 is g F from L0 to L1
	getstatic local_global/a I
	i2f
	getstatic local_global/b F
	fadd
	fstore_2
.var 3 is e F from L0 to L1
	getstatic local_global/c F
	getstatic local_global/b F
	fdiv
	fstore_3
	return
L1:
	return
	
	; set limits used by this method
.limit locals 4
.limit stack 2
.end method
