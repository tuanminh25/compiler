.class public mytest/short_circuit
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
.var 1 is vc$ Lmytest/short_circuit; from L0 to L1
	new mytest/short_circuit
	dup
	invokenonvirtual mytest/short_circuit/<init>()V
	astore_1
.var 2 is a Z from L0 to L1
	iconst_1
	istore_2
.var 3 is b Z from L0 to L1
	iconst_0
	istore_3
.var 4 is x I from L0 to L1
	iconst_1
	istore 4
.var 5 is y I from L0 to L1
	iconst_0
	istore 5
	iload_2
	ifeq L4
	iload_3
	goto L5
L4:
	iconst_0
L5:
	ifeq L2
L6:
	iconst_1
	invokestatic VC/lang/System/putIntLn(I)V
L7:
	goto L3
L2:
L8:
	iconst_0
	invokestatic VC/lang/System/putIntLn(I)V
L9:
L3:
	iload_2
	ifne L12
	iload_3
	goto L13
L12:
	iconst_1
L13:
	ifeq L10
L14:
	iconst_1
	invokestatic VC/lang/System/putIntLn(I)V
L15:
	goto L11
L10:
L16:
	iconst_0
	invokestatic VC/lang/System/putIntLn(I)V
L17:
L11:
	return
L1:
	return
	
	; set limits used by this method
.limit locals 6
.limit stack 2
.end method
