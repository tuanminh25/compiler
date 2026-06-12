.class public float_gteq
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
.method public static main([Ljava/lang/String;)V
L0:
.var 0 is argv [Ljava/lang/String; from L0 to L1
.var 1 is vc$ Lfloat_gteq; from L0 to L1
	new float_gteq
	dup
	invokenonvirtual float_gteq/<init>()V
	astore_1
.var 2 is a F from L0 to L1
	ldc 3.1
	fstore_2
.var 3 is b F from L0 to L1
	ldc 6.1
	fneg
	fstore_3
	fload_2
	fload_3
	fcmpg
	ifge L4
	iconst_0
	goto L5
L4:
	iconst_1
L5:
	ifeq L2
L6:
	return
L7:
	goto L3
L2:
L3:
	return
L1:
	return
	
	; set limits used by this method
.limit locals 4
.limit stack 2
.end method
