.class public callexpr_1
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
.method add5(IIIII)I
L0:
.var 0 is this Lcallexpr_1; from L0 to L1
.var 1 is a I from L0 to L1
.var 2 is b I from L0 to L1
.var 3 is c I from L0 to L1
.var 4 is d I from L0 to L1
.var 5 is e I from L0 to L1
	iload_1
	iload_2
	iadd
	iload_3
	iadd
	iload 4
	iadd
	iload 5
	iadd
	ireturn
L1:
	nop
	
	; set limits used by this method
.limit locals 6
.limit stack 2
.end method
.method public static main([Ljava/lang/String;)V
L0:
.var 0 is argv [Ljava/lang/String; from L0 to L1
.var 1 is vc$ Lcallexpr_1; from L0 to L1
	new callexpr_1
	dup
	invokenonvirtual callexpr_1/<init>()V
	astore_1
.var 2 is x I from L0 to L1
	aload_1
	iconst_1
	iconst_2
	iconst_3
	iconst_4
	iconst_5
	invokevirtual callexpr_1/add5(IIIII)I
	istore_2
	return
L1:
	return
	
	; set limits used by this method
.limit locals 3
.limit stack 6
.end method
