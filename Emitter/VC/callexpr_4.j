.class public callexpr_4
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
.method half(F)F
L0:
.var 0 is this Lcallexpr_4; from L0 to L1
.var 1 is a F from L0 to L1
	fload_1
	fconst_2
	fdiv
	freturn
L1:
	nop
	
	; set limits used by this method
.limit locals 2
.limit stack 2
.end method
.method public static main([Ljava/lang/String;)V
L0:
.var 0 is argv [Ljava/lang/String; from L0 to L1
.var 1 is vc$ Lcallexpr_4; from L0 to L1
	new callexpr_4
	dup
	invokenonvirtual callexpr_4/<init>()V
	astore_1
.var 2 is x F from L0 to L1
	aload_1
	ldc 3.0
	invokevirtual callexpr_4/half(F)F
	aload_1
	ldc 4.0
	invokevirtual callexpr_4/half(F)F
	fadd
	fstore_2
	return
L1:
	return
	
	; set limits used by this method
.limit locals 3
.limit stack 3
.end method
