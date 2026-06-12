.class public callexpr_3
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
.method square(I)I
L0:
.var 0 is this Lcallexpr_3; from L0 to L1
.var 1 is a I from L0 to L1
	iload_1
	iload_1
	imul
	ireturn
L1:
	nop
	
	; set limits used by this method
.limit locals 2
.limit stack 2
.end method
.method public static main([Ljava/lang/String;)V
L0:
.var 0 is argv [Ljava/lang/String; from L0 to L1
.var 1 is vc$ Lcallexpr_3; from L0 to L1
	new callexpr_3
	dup
	invokenonvirtual callexpr_3/<init>()V
	astore_1
.var 2 is x I from L0 to L1
	aload_1
	iconst_3
	invokevirtual callexpr_3/square(I)I
	aload_1
	iconst_4
	invokevirtual callexpr_3/square(I)I
	iadd
	istore_2
	return
L1:
	return
	
	; set limits used by this method
.limit locals 3
.limit stack 3
.end method
