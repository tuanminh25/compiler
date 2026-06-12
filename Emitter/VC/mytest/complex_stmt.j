.class public mytest/complex_stmt
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
.var 1 is vc$ Lmytest/complex_stmt; from L0 to L1
	new mytest/complex_stmt
	dup
	invokenonvirtual mytest/complex_stmt/<init>()V
	astore_1
.var 2 is i I from L0 to L1
	iconst_0
	istore_2
.var 3 is j I from L0 to L1
	iconst_0
	istore_3
.var 4 is sum I from L0 to L1
	iconst_0
	istore 4
.var 5 is flag Z from L0 to L1
	iconst_1
	istore 5
.var 6 is done Z from L0 to L1
	iconst_0
	istore 6
	iload 5
	ifeq L2
L4:
	iload_2
	iconst_0
	if_icmpeq L8
	iconst_0
	goto L9
L8:
	iconst_1
L9:
	ifeq L6
L10:
	iload 4
	iconst_1
	iadd
	istore 4
L11:
	goto L7
L6:
L12:
	iload 4
	iconst_2
	iadd
	istore 4
L13:
L7:
L5:
	goto L3
L2:
L14:
	iload 4
	iconst_3
	iadd
	istore 4
L15:
L3:
	iconst_0
	istore_2
L16:
	iload_2
	bipush 10
	if_icmplt L19
	iconst_0
	goto L20
L19:
	iconst_1
L20:
	ifeq L17
L21:
	iload_2
	iconst_5
	if_icmpeq L25
	iconst_0
	goto L26
L25:
	iconst_1
L26:
	ifeq L23
L27:
	goto L17
L28:
	goto L24
L23:
L24:
	iload 4
	iload_2
	iadd
	istore 4
L22:
L18:
	iload_2
	iconst_1
	iadd
	istore_2
	goto L16
L17:
	iconst_0
	istore_2
L29:
	iload_2
	iconst_5
	if_icmplt L32
	iconst_0
	goto L33
L32:
	iconst_1
L33:
	ifeq L30
L34:
	iload_2
	iconst_2
	if_icmpeq L38
	iconst_0
	goto L39
L38:
	iconst_1
L39:
	ifeq L36
L40:
	goto L31
L41:
	goto L37
L36:
L37:
	iload 4
	iload_2
	iadd
	istore 4
L35:
L31:
	iload_2
	iconst_1
	iadd
	istore_2
	goto L29
L30:
L42:
	iload 5
	ifeq L43
L44:
	iload 4
	iconst_1
	iadd
	istore 4
	iload 4
	bipush 30
	if_icmpgt L48
	iconst_0
	goto L49
L48:
	iconst_1
L49:
	ifeq L46
L50:
	goto L43
L51:
	goto L47
L46:
L47:
L45:
	goto L42
L43:
	iconst_0
	istore_2
L52:
	iload_2
	iconst_5
	if_icmplt L54
	iconst_0
	goto L55
L54:
	iconst_1
L55:
	ifeq L53
L56:
	iload_2
	iconst_1
	iadd
	istore_2
	iload_2
	iconst_3
	if_icmpeq L60
	iconst_0
	goto L61
L60:
	iconst_1
L61:
	ifeq L58
L62:
	goto L52
L63:
	goto L59
L58:
L59:
	iload 4
	iload_2
	iadd
	istore 4
L57:
	goto L52
L53:
	iconst_0
	istore_2
L64:
	iload_2
	iconst_3
	if_icmplt L67
	iconst_0
	goto L68
L67:
	iconst_1
L68:
	ifeq L65
L69:
	iconst_0
	istore_3
L71:
	iload_3
	iconst_5
	if_icmplt L74
	iconst_0
	goto L75
L74:
	iconst_1
L75:
	ifeq L72
L76:
	iload_3
	iconst_2
	if_icmpeq L80
	iconst_0
	goto L81
L80:
	iconst_1
L81:
	ifeq L78
L82:
	goto L73
L83:
	goto L79
L78:
L79:
	iload_3
	iconst_4
	if_icmpeq L86
	iconst_0
	goto L87
L86:
	iconst_1
L87:
	ifeq L84
L88:
	goto L72
L89:
	goto L85
L84:
L85:
	iload 4
	iconst_1
	iadd
	istore 4
L77:
L73:
	iload_3
	iconst_1
	iadd
	istore_3
	goto L71
L72:
L70:
L66:
	iload_2
	iconst_1
	iadd
	istore_2
	goto L64
L65:
	iload 5
	ifeq L92
	iload 6
	iconst_1
	ixor
	goto L93
L92:
	iconst_0
L93:
	ifeq L90
L94:
	iload 4
	bipush 10
	iadd
	istore 4
L95:
	goto L91
L90:
L96:
	iload 4
	bipush 20
	iadd
	istore 4
L97:
L91:
	iload 5
	iconst_1
	ixor
	ifne L100
	iload 6
	goto L101
L100:
	iconst_1
L101:
	ifeq L98
L102:
	iload 4
	bipush 100
	iadd
	istore 4
L103:
	goto L99
L98:
L104:
	iload 4
	sipush 200
	iadd
	istore 4
L105:
L99:
	iload 4
	iconst_0
	if_icmplt L108
	iconst_0
	goto L109
L108:
	iconst_1
L109:
	ifeq L106
L110:
	iconst_1
	ineg
	invokestatic VC/lang/System/putIntLn(I)V
	return
L111:
	goto L107
L106:
L107:
	iload 4
	invokestatic VC/lang/System/putIntLn(I)V
	return
L1:
	return
	
	; set limits used by this method
.limit locals 7
.limit stack 2
.end method
