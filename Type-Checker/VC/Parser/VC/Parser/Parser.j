;; Produced by JasminVisitor (JavaClass package)
;; http://www.inf.fu-berlin.de/~dahm/JavaClass/
;; Fri Apr 17 12:35:23 AEST 2026

.source Parser.java
.class public VC/Parser/Parser
.super java/lang/Object

.field private final scanner LVC/Scanner/Scanner;
.field private final errorReporter LVC/ErrorReporter;
.field private currentToken LVC/Scanner/Token;
.field private previousTokenPosition LVC/Scanner/SourcePosition;
.field private final dummyPos LVC/Scanner/SourcePosition;

.method public <init>(LVC/Scanner/Scanner;LVC/ErrorReporter;)V
.limit stack 3
.limit locals 3
.var 0 is this LVC/Parser/Parser; from Label0 to Label0
.var 1 is arg0 LVC/Scanner/Scanner; from Label0 to Label0
.var 2 is arg1 LVC/ErrorReporter; from Label0 to Label0

.line 27
	aload_0
	invokespecial java/lang/Object/<init>()V
.line 25
	aload_0
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	putfield VC.Parser.Parser.dummyPos LVC/Scanner/SourcePosition;
.line 28
	aload_0
	aload_1
	invokestatic java/util/Objects/requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;
	checkcast VC/Scanner/Scanner
	putfield VC.Parser.Parser.scanner LVC/Scanner/Scanner;
.line 29
	aload_0
	aload_2
	invokestatic java/util/Objects/requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;
	checkcast VC/ErrorReporter
	putfield VC.Parser.Parser.errorReporter LVC/ErrorReporter;
.line 30
	aload_0
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	putfield VC.Parser.Parser.previousTokenPosition LVC/Scanner/SourcePosition;
.line 31
	aload_0
	aload_0
	getfield VC.Parser.Parser.scanner LVC/Scanner/Scanner;
	invokevirtual VC/Scanner/Scanner/getToken()LVC/Scanner/Token;
	putfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
Label0:
.line 32
	return

.end method

.method private match(I)V
.limit stack 3
.limit locals 2
.var 0 is this LVC/Parser/Parser; from Label1 to Label1
.var 1 is arg0 I from Label1 to Label1

.line 35
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	iload_1
	if_icmpne Label0
.line 36
	aload_0
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.position LVC/Scanner/SourcePosition;
	putfield VC.Parser.Parser.previousTokenPosition LVC/Scanner/SourcePosition;
.line 37
	aload_0
	aload_0
	getfield VC.Parser.Parser.scanner LVC/Scanner/Scanner;
	invokevirtual VC/Scanner/Scanner/getToken()LVC/Scanner/Token;
	putfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	goto Label1
Label0:
.line 39
	aload_0
	ldc "\"%\" expected here"
	iload_1
	invokestatic VC/Scanner/Token/spell(I)Ljava/lang/String;
	invokevirtual VC/Parser/Parser/syntacticError(Ljava/lang/String;Ljava/lang/String;)LVC/Parser/SyntaxError;
	pop
Label1:
.line 41
	return

.throws VC/Parser/SyntaxError
.end method

.method private accept()V
.limit stack 2
.limit locals 1
.var 0 is this LVC/Parser/Parser; from Label0 to Label0

.line 44
	aload_0
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.position LVC/Scanner/SourcePosition;
	putfield VC.Parser.Parser.previousTokenPosition LVC/Scanner/SourcePosition;
.line 45
	aload_0
	aload_0
	getfield VC.Parser.Parser.scanner LVC/Scanner/Scanner;
	invokevirtual VC/Scanner/Scanner/getToken()LVC/Scanner/Token;
	putfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
Label0:
.line 46
	return

.end method

.method private syntacticError(Ljava/lang/String;Ljava/lang/String;)LVC/Parser/SyntaxError;
.limit stack 4
.limit locals 4
.var 0 is this LVC/Parser/Parser; from Label0 to Label0
.var 1 is arg0 Ljava/lang/String; from Label0 to Label0
.var 2 is arg1 Ljava/lang/String; from Label0 to Label0

.line 49
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.position LVC/Scanner/SourcePosition;
	astore_3
.line 50
	aload_0
	getfield VC.Parser.Parser.errorReporter LVC/ErrorReporter;
	aload_1
	aload_2
	aload_3
	invokevirtual VC/ErrorReporter/reportError(Ljava/lang/String;Ljava/lang/String;LVC/Scanner/SourcePosition;)V
.line 51
	new VC/Parser/SyntaxError
	dup
	invokespecial VC/Parser/SyntaxError/<init>()V
Label0:
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private start(LVC/Scanner/SourcePosition;)V
.limit stack 2
.limit locals 2
.var 0 is this LVC/Parser/Parser; from Label0 to Label0
.var 1 is arg0 LVC/Scanner/SourcePosition; from Label0 to Label0

.line 55
	aload_1
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.position LVC/Scanner/SourcePosition;
	getfield VC.Scanner.SourcePosition.lineStart I
	putfield VC.Scanner.SourcePosition.lineStart I
.line 56
	aload_1
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.position LVC/Scanner/SourcePosition;
	getfield VC.Scanner.SourcePosition.charStart I
	putfield VC.Scanner.SourcePosition.charStart I
Label0:
.line 57
	return

.end method

.method private finish(LVC/Scanner/SourcePosition;)V
.limit stack 2
.limit locals 2
.var 0 is this LVC/Parser/Parser; from Label0 to Label0
.var 1 is arg0 LVC/Scanner/SourcePosition; from Label0 to Label0

.line 60
	aload_1
	aload_0
	getfield VC.Parser.Parser.previousTokenPosition LVC/Scanner/SourcePosition;
	getfield VC.Scanner.SourcePosition.lineFinish I
	putfield VC.Scanner.SourcePosition.lineFinish I
.line 61
	aload_1
	aload_0
	getfield VC.Parser.Parser.previousTokenPosition LVC/Scanner/SourcePosition;
	getfield VC.Scanner.SourcePosition.charFinish I
	putfield VC.Scanner.SourcePosition.charFinish I
Label0:
.line 62
	return

.end method

.method private copyStart(LVC/Scanner/SourcePosition;LVC/Scanner/SourcePosition;)V
.limit stack 2
.limit locals 3
.var 0 is this LVC/Parser/Parser; from Label0 to Label0
.var 1 is arg0 LVC/Scanner/SourcePosition; from Label0 to Label0
.var 2 is arg1 LVC/Scanner/SourcePosition; from Label0 to Label0

.line 65
	aload_2
	aload_1
	getfield VC.Scanner.SourcePosition.lineStart I
	putfield VC.Scanner.SourcePosition.lineStart I
.line 66
	aload_2
	aload_1
	getfield VC.Scanner.SourcePosition.charStart I
	putfield VC.Scanner.SourcePosition.charStart I
Label0:
.line 67
	return

.end method

.method public parseProgram()LVC/ASTs/Program;
.limit stack 4
.limit locals 4
.var 0 is this LVC/Parser/Parser; from Label1 to Label1

.line 72
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_1
.line 73
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
Label3:
.line 76
	aload_0
	invokevirtual VC/Parser/Parser/parseDeclList()LVC/ASTs/ASTList;
	astore_2
.line 77
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 78
	new VC/ASTs/Program
	dup
	aload_2
	aload_1
	invokespecial VC/ASTs/Program/<init>(LVC/ASTs/ASTList;LVC/Scanner/SourcePosition;)V
	astore_3
.line 79
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 39
	if_icmpeq Label0
.line 80
	aload_0
	ldc "\"%\" unknown type"
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.spelling Ljava/lang/String;
	invokevirtual VC/Parser/Parser/syntacticError(Ljava/lang/String;Ljava/lang/String;)LVC/Parser/SyntaxError;
	pop
Label0:
.line 83
	aload_3
Label4:
	areturn
Label5:
.line 84
	astore_2
.line 85
	aconst_null
Label1:
	areturn

.catch VC/Parser/SyntaxError from Label3 to Label4 using Label5
.end method

.method private parseDeclList()LVC/ASTs/ASTList;
.limit stack 5
.limit locals 6
.var 0 is this LVC/Parser/Parser; from Label12 to Label12

.line 91
	aconst_null
	astore_1
.line 92
	aconst_null
	astore_2
.line 94
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_3
.line 95
	aload_0
	aload_3
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 97
	aload_0
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	invokevirtual VC/Parser/Parser/isTypeToken(I)Z
	ifeq Label0
.line 98
	aload_0
	invokevirtual VC/Parser/Parser/parseType()LVC/ASTs/Type;
	astore 4
.line 99
	aload_0
	invokevirtual VC/Parser/Parser/parseIdent()LVC/ASTs/Ident;
	astore 5
.line 100
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 27
	if_icmpne Label1
.line 101
	aload_0
	aload 4
	aload 5
	invokevirtual VC/Parser/Parser/parseRestFuncDecl(LVC/ASTs/Type;LVC/ASTs/Ident;)LVC/ASTs/Decl;
	astore_1
	goto Label0
Label1:
.line 103
	aload_0
	aload 4
	aload 5
	iconst_1
	invokevirtual VC/Parser/Parser/parseRestVarDecl(LVC/ASTs/Type;LVC/ASTs/Ident;Z)LVC/ASTs/ASTList;
	astore_2
Label0:
.line 107
	aload_0
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	invokevirtual VC/Parser/Parser/isTypeToken(I)Z
	ifeq Label3
	aload_0
	invokevirtual VC/Parser/Parser/parseDeclList()LVC/ASTs/ASTList;
	goto Label4
Label3:
	new VC/ASTs/EmptyDeclList
	dup
	aload_0
	getfield VC.Parser.Parser.dummyPos LVC/Scanner/SourcePosition;
	invokespecial VC/ASTs/EmptyDeclList/<init>(LVC/Scanner/SourcePosition;)V
Label4:
	astore 4
.line 109
	aload_1
	ifnull Label5
.line 110
	aload_0
	aload_3
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 111
	new VC/ASTs/DeclList
	dup
	aload_1
	aload 4
	aload_3
	invokespecial VC/ASTs/DeclList/<init>(LVC/ASTs/Decl;LVC/ASTs/ASTList;LVC/Scanner/SourcePosition;)V
	astore_2
	goto Label6
Label5:
.line 112
	aload_2
	ifnull Label7
.line 113
	aload_2
	astore 5
Label9:
.line 114
	aload 5
	invokevirtual VC/ASTs/ASTList/getNext()LVC/ASTs/ASTList;
	invokevirtual VC/ASTs/ASTList/isEmpty()Z
	ifne Label8
.line 115
	aload 5
	invokevirtual VC/ASTs/ASTList/getNext()LVC/ASTs/ASTList;
	astore 5
	goto Label9
Label8:
.line 117
	aload 4
	invokevirtual VC/ASTs/ASTList/isEmpty()Z
	ifne Label10
.line 118
	aload 5
	aload 4
	invokevirtual VC/ASTs/ASTList/setNext(LVC/ASTs/ASTList;)V
Label10:
.line 120
	goto Label6
Label7:
.line 121
	aload 4
	astore_2
Label6:
.line 124
	aload_2
Label12:
	areturn

.throws VC/Parser/SyntaxError

.method private isTypeToken(I)Z
.limit stack 2
.limit locals 2
.var 0 is this LVC/Parser/Parser; from Label4 to Label4
.var 1 is arg0 I from Label4 to Label4

.line 128
	iload_1
	bipush 9
	if_icmpeq Label0
	iload_1
	ifeq Label0
	iload_1
	bipush 7
	if_icmpeq Label0
	iload_1
	iconst_4
	if_icmpne Label3
Label0:
	iconst_1
	goto Label4
Label3:
	iconst_0
Label4:
	ireturn

.end method

.method private parseRestFuncDecl(LVC/ASTs/Type;LVC/ASTs/Ident;)LVC/ASTs/Decl;
.limit stack 7
.limit locals 6
.var 0 is this LVC/Parser/Parser; from Label0 to Label0
.var 1 is arg0 LVC/ASTs/Type; from Label0 to Label0
.var 2 is arg1 LVC/ASTs/Ident; from Label0 to Label0

.line 133
	aload_1
	getfield VC.ASTs.Type.position LVC/Scanner/SourcePosition;
	astore_3
.line 134
	aload_0
	invokevirtual VC/Parser/Parser/parseParaList()LVC/ASTs/ASTList;
	astore 4
.line 135
	aload_0
	invokevirtual VC/Parser/Parser/parseCompoundStmt()LVC/ASTs/Stmt;
	astore 5
.line 136
	aload_0
	aload_3
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 137
	new VC/ASTs/FuncDecl
	dup
	aload_1
	aload_2
	aload 4
	aload 5
	aload_3
	invokespecial VC/ASTs/FuncDecl/<init>(LVC/ASTs/Type;LVC/ASTs/Ident;LVC/ASTs/ASTList;LVC/ASTs/Stmt;LVC/Scanner/SourcePosition;)V
Label0:
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private parseRestVarDecl(LVC/ASTs/Type;LVC/ASTs/Ident;Z)LVC/ASTs/ASTList;
.limit stack 6
.limit locals 11
.var 0 is this LVC/Parser/Parser; from Label9 to Label9
.var 1 is arg0 LVC/ASTs/Type; from Label9 to Label9
.var 2 is arg1 LVC/ASTs/Ident; from Label9 to Label9
.var 3 is arg2 Z from Label9 to Label9

.line 141
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore 4
.line 142
	aload_0
	aload_1
	getfield VC.ASTs.Type.position LVC/Scanner/SourcePosition;
	aload 4
	invokevirtual VC/Parser/Parser/copyStart(LVC/Scanner/SourcePosition;LVC/Scanner/SourcePosition;)V
.line 144
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 29
	if_icmpne Label0
.line 145
	aload_0
	invokevirtual VC/Parser/Parser/accept()V
.line 146
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 34
	if_icmpne Label1
	aload_0
	invokevirtual VC/Parser/Parser/parseExpr()LVC/ASTs/Expr;
	goto Label2
Label1:
	new VC/ASTs/EmptyExpr
	dup
	aload_0
	getfield VC.Parser.Parser.dummyPos LVC/Scanner/SourcePosition;
	invokespecial VC/ASTs/EmptyExpr/<init>(LVC/Scanner/SourcePosition;)V
Label2:
	astore 5
.line 147
	aload_0
	bipush 30
	invokevirtual VC/Parser/Parser/match(I)V
.line 148
	aload_0
	aload 4
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 149
	new VC/ASTs/ArrayType
	dup
	aload_1
	aload 5
	aload 4
	invokespecial VC/ASTs/ArrayType/<init>(LVC/ASTs/Type;LVC/ASTs/Expr;LVC/Scanner/SourcePosition;)V
	astore_1
Label0:
.line 153
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 17
	if_icmpne Label3
.line 154
	aload_0
	invokevirtual VC/Parser/Parser/accept()V
.line 155
	aload_0
	invokevirtual VC/Parser/Parser/parseInitialiser()LVC/ASTs/Expr;
	astore 5
	goto Label4
Label3:
.line 157
	new VC/ASTs/EmptyExpr
	dup
	aload_0
	getfield VC.Parser.Parser.dummyPos LVC/Scanner/SourcePosition;
	invokespecial VC/ASTs/EmptyExpr/<init>(LVC/Scanner/SourcePosition;)V
	astore 5
Label4:
.line 160
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore 6
.line 161
	aload_0
	aload_2
	getfield VC.ASTs.Ident.position LVC/Scanner/SourcePosition;
	aload 6
	invokevirtual VC/Parser/Parser/copyStart(LVC/Scanner/SourcePosition;LVC/Scanner/SourcePosition;)V
.line 162
	aload_0
	aload 6
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 163
	iload_3
	ifeq Label5
.line 164
	new VC/ASTs/GlobalVarDecl
	dup
	aload_1
	aload_2
	aload 5
	aload 6
	invokespecial VC/ASTs/GlobalVarDecl/<init>(LVC/ASTs/Type;LVC/ASTs/Ident;LVC/ASTs/Expr;LVC/Scanner/SourcePosition;)V
	goto Label6
Label5:
.line 165
	new VC/ASTs/LocalVarDecl
	dup
	aload_1
	aload_2
	aload 5
	aload 6
	invokespecial VC/ASTs/LocalVarDecl/<init>(LVC/ASTs/Type;LVC/ASTs/Ident;LVC/ASTs/Expr;LVC/Scanner/SourcePosition;)V
Label6:
	astore 7
.line 167
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore 8
.line 168
	aload_0
	aload_2
	getfield VC.ASTs.Ident.position LVC/Scanner/SourcePosition;
	aload 8
	invokevirtual VC/Parser/Parser/copyStart(LVC/Scanner/SourcePosition;LVC/Scanner/SourcePosition;)V
.line 170
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 32
	if_icmpne Label7
.line 171
	aload_0
	invokevirtual VC/Parser/Parser/accept()V
.line 172
	aload_1
	invokevirtual VC/ASTs/Type/getElementType()Ljava/util/Optional;
	astore 9
.line 173
	aload 9
	invokevirtual java/util/Optional/isPresent()Z
	ifeq Label8
.line 174
	aload 9
	invokevirtual java/util/Optional/get()Ljava/lang/Object;
	checkcast VC/ASTs/Type
	astore_1
Label8:
.line 176
	aload_0
	aload_1
	iload_3
	invokevirtual VC/Parser/Parser/parseInitDeclaratorList(LVC/ASTs/Type;Z)LVC/ASTs/ASTList;
	astore 10
.line 177
	aload_0
	bipush 31
	invokevirtual VC/Parser/Parser/match(I)V
.line 178
	aload_0
	aload 8
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 179
	new VC/ASTs/DeclList
	dup
	aload 7
	aload 10
	aload 8
	invokespecial VC/ASTs/DeclList/<init>(LVC/ASTs/Decl;LVC/ASTs/ASTList;LVC/Scanner/SourcePosition;)V
	areturn
Label7:
.line 181
	aload_0
	bipush 31
	invokevirtual VC/Parser/Parser/match(I)V
.line 182
	aload_0
	aload 8
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 183
	new VC/ASTs/DeclList
	dup
	aload 7
	new VC/ASTs/EmptyDeclList
	dup
	aload_0
	getfield VC.Parser.Parser.dummyPos LVC/Scanner/SourcePosition;
	invokespecial VC/ASTs/EmptyDeclList/<init>(LVC/Scanner/SourcePosition;)V
	aload 8
	invokespecial VC/ASTs/DeclList/<init>(LVC/ASTs/Decl;LVC/ASTs/ASTList;LVC/Scanner/SourcePosition;)V
Label9:
	areturn

.throws VC/Parser/SyntaxError

.method private parseVarDecl()LVC/ASTs/ASTList;
.limit stack 3
.limit locals 3
.var 0 is this LVC/Parser/Parser; from Label0 to Label0

.line 188
	aload_0
	invokevirtual VC/Parser/Parser/parseType()LVC/ASTs/Type;
	astore_1
.line 189
	aload_0
	aload_1
	iconst_0
	invokevirtual VC/Parser/Parser/parseInitDeclaratorList(LVC/ASTs/Type;Z)LVC/ASTs/ASTList;
	astore_2
.line 190
	aload_0
	bipush 31
	invokevirtual VC/Parser/Parser/match(I)V
.line 191
	aload_2
Label0:
	areturn

.throws VC/Parser/SyntaxError

.method private parseInitDeclaratorList(LVC/ASTs/Type;Z)LVC/ASTs/ASTList;
.limit stack 6
.limit locals 6
.var 0 is this LVC/Parser/Parser; from Label1 to Label1
.var 1 is arg0 LVC/ASTs/Type; from Label1 to Label1
.var 2 is arg1 Z from Label1 to Label1

.line 195
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_3
.line 196
	aload_0
	aload_3
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 198
	aload_1
	invokevirtual VC/ASTs/Type/cloneType()LVC/ASTs/Type;
	astore_1
.line 200
	aload_0
	aload_1
	iload_2
	invokevirtual VC/Parser/Parser/parseInitDeclarator(LVC/ASTs/Type;Z)LVC/ASTs/Decl;
	astore 4
.line 202
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 32
	if_icmpne Label0
.line 203
	aload_0
	invokevirtual VC/Parser/Parser/accept()V
.line 204
	aload_0
	aload_1
	iload_2
	invokevirtual VC/Parser/Parser/parseInitDeclaratorList(LVC/ASTs/Type;Z)LVC/ASTs/ASTList;
	astore 5
.line 205
	aload_0
	aload_3
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 206
	new VC/ASTs/DeclList
	dup
	aload 4
	aload 5
	aload_3
	invokespecial VC/ASTs/DeclList/<init>(LVC/ASTs/Decl;LVC/ASTs/ASTList;LVC/Scanner/SourcePosition;)V
	areturn
Label0:
.line 208
	aload_0
	aload_3
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 209
	new VC/ASTs/DeclList
	dup
	aload 4
	new VC/ASTs/EmptyDeclList
	dup
	aload_0
	getfield VC.Parser.Parser.dummyPos LVC/Scanner/SourcePosition;
	invokespecial VC/ASTs/EmptyDeclList/<init>(LVC/Scanner/SourcePosition;)V
	aload_3
	invokespecial VC/ASTs/DeclList/<init>(LVC/ASTs/Decl;LVC/ASTs/ASTList;LVC/Scanner/SourcePosition;)V
Label1:
	areturn

.throws VC/Parser/SyntaxError

.method private parseInitDeclarator(LVC/ASTs/Type;Z)LVC/ASTs/Decl;
.limit stack 6
.limit locals 6
.var 0 is this LVC/Parser/Parser; from Label3 to Label3
.var 1 is arg0 LVC/ASTs/Type; from Label3 to Label3
.var 2 is arg1 Z from Label3 to Label3

.line 214
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_3
.line 215
	aload_0
	aload_3
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 217
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/parseDeclarator(LVC/ASTs/Type;)LVC/Parser/Parser$TypeAndIdent;
	astore 4
.line 219
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 17
	if_icmpne Label0
.line 220
	aload_0
	invokevirtual VC/Parser/Parser/accept()V
.line 221
	aload_0
	invokevirtual VC/Parser/Parser/parseInitialiser()LVC/ASTs/Expr;
	astore 5
	goto Label1
Label0:
.line 223
	new VC/ASTs/EmptyExpr
	dup
	aload_0
	getfield VC.Parser.Parser.dummyPos LVC/Scanner/SourcePosition;
	invokespecial VC/ASTs/EmptyExpr/<init>(LVC/Scanner/SourcePosition;)V
	astore 5
Label1:
.line 225
	aload_0
	aload_3
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 227
	iload_2
	ifeq Label2
.line 228
	new VC/ASTs/GlobalVarDecl
	dup
	aload 4
	getfield VC.Parser.Parser$TypeAndIdent.tAST LVC/ASTs/Type;
	aload 4
	getfield VC.Parser.Parser$TypeAndIdent.iAST LVC/ASTs/Ident;
	aload 5
	aload_3
	invokespecial VC/ASTs/GlobalVarDecl/<init>(LVC/ASTs/Type;LVC/ASTs/Ident;LVC/ASTs/Expr;LVC/Scanner/SourcePosition;)V
	goto Label3
Label2:
.line 229
	new VC/ASTs/LocalVarDecl
	dup
	aload 4
	getfield VC.Parser.Parser$TypeAndIdent.tAST LVC/ASTs/Type;
	aload 4
	getfield VC.Parser.Parser$TypeAndIdent.iAST LVC/ASTs/Ident;
	aload 5
	aload_3
	invokespecial VC/ASTs/LocalVarDecl/<init>(LVC/ASTs/Type;LVC/ASTs/Ident;LVC/ASTs/Expr;LVC/Scanner/SourcePosition;)V
Label3:
.line 227
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private parseDeclarator(LVC/ASTs/Type;)LVC/Parser/Parser$TypeAndIdent;
.limit stack 5
.limit locals 5
.var 0 is this LVC/Parser/Parser; from Label3 to Label3
.var 1 is arg0 LVC/ASTs/Type; from Label3 to Label3

.line 233
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_2
.line 234
	aload_0
	aload_1
	getfield VC.ASTs.Type.position LVC/Scanner/SourcePosition;
	aload_2
	invokevirtual VC/Parser/Parser/copyStart(LVC/Scanner/SourcePosition;LVC/Scanner/SourcePosition;)V
.line 236
	aload_0
	invokevirtual VC/Parser/Parser/parseIdent()LVC/ASTs/Ident;
	astore_3
.line 237
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 29
	if_icmpne Label0
.line 238
	aload_0
	invokevirtual VC/Parser/Parser/accept()V
.line 239
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 34
	if_icmpne Label1
.line 240
	new VC/ASTs/IntExpr
	dup
	aload_0
	invokevirtual VC/Parser/Parser/parseIntLiteral()LVC/ASTs/IntLiteral;
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	invokespecial VC/ASTs/IntExpr/<init>(LVC/ASTs/IntLiteral;LVC/Scanner/SourcePosition;)V
	goto Label2
Label1:
.line 241
	new VC/ASTs/EmptyExpr
	dup
	aload_0
	getfield VC.Parser.Parser.dummyPos LVC/Scanner/SourcePosition;
	invokespecial VC/ASTs/EmptyExpr/<init>(LVC/Scanner/SourcePosition;)V
Label2:
	astore 4
.line 242
	aload_0
	bipush 30
	invokevirtual VC/Parser/Parser/match(I)V
.line 243
	aload_0
	aload_2
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 244
	new VC/ASTs/ArrayType
	dup
	aload_1
	aload 4
	aload_2
	invokespecial VC/ASTs/ArrayType/<init>(LVC/ASTs/Type;LVC/ASTs/Expr;LVC/Scanner/SourcePosition;)V
	astore_1
Label0:
.line 247
	new VC/Parser/Parser$TypeAndIdent
	dup
	aload_1
	aload_3
	invokespecial VC/Parser/Parser$TypeAndIdent/<init>(LVC/ASTs/Type;LVC/ASTs/Ident;)V
Label3:
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private parseArrayInitExpr()LVC/ASTs/ASTList;
.limit stack 6
.limit locals 4
.var 0 is this LVC/Parser/Parser; from Label1 to Label1

.line 251
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_1
.line 252
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 254
	aload_0
	invokevirtual VC/Parser/Parser/parseExpr()LVC/ASTs/Expr;
	astore_2
.line 255
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 32
	if_icmpne Label0
.line 256
	aload_0
	invokevirtual VC/Parser/Parser/accept()V
.line 257
	aload_0
	invokevirtual VC/Parser/Parser/parseArrayInitExpr()LVC/ASTs/ASTList;
	astore_3
.line 258
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 259
	new VC/ASTs/ArrayExprList
	dup
	aload_2
	aload_3
	aload_1
	invokespecial VC/ASTs/ArrayExprList/<init>(LVC/ASTs/Expr;LVC/ASTs/ASTList;LVC/Scanner/SourcePosition;)V
	areturn
Label0:
.line 261
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 262
	new VC/ASTs/ArrayExprList
	dup
	aload_2
	new VC/ASTs/EmptyArrayExprList
	dup
	aload_0
	getfield VC.Parser.Parser.dummyPos LVC/Scanner/SourcePosition;
	invokespecial VC/ASTs/EmptyArrayExprList/<init>(LVC/Scanner/SourcePosition;)V
	aload_1
	invokespecial VC/ASTs/ArrayExprList/<init>(LVC/ASTs/Expr;LVC/ASTs/ASTList;LVC/Scanner/SourcePosition;)V
Label1:
	areturn

.throws VC/Parser/SyntaxError

.method private parseInitialiser()LVC/ASTs/Expr;
.limit stack 4
.limit locals 3
.var 0 is this LVC/Parser/Parser; from Label1 to Label1

.line 267
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_1
.line 268
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 270
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 25
	if_icmpne Label0
.line 271
	aload_0
	invokevirtual VC/Parser/Parser/accept()V
.line 272
	aload_0
	invokevirtual VC/Parser/Parser/parseArrayInitExpr()LVC/ASTs/ASTList;
	astore_2
.line 273
	aload_0
	bipush 26
	invokevirtual VC/Parser/Parser/match(I)V
.line 274
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 275
	new VC/ASTs/ArrayInitExpr
	dup
	aload_2
	aload_1
	invokespecial VC/ASTs/ArrayInitExpr/<init>(LVC/ASTs/ASTList;LVC/Scanner/SourcePosition;)V
	areturn
Label0:
.line 277
	aload_0
	invokevirtual VC/Parser/Parser/parseExpr()LVC/ASTs/Expr;
Label1:
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private parseType()LVC/ASTs/Type;
.limit stack 3
.limit locals 2
.var 0 is this LVC/Parser/Parser; from Label11 to Label11

.line 283
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_1
.line 284
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 286
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	tableswitch 0 9
		Label0
		Label1
		Label1
		Label1
		Label4
		Label1
		Label1
		Label7
		Label1
		Label9
		default: Label1
Label9:
.line 288
	aload_0
	invokevirtual VC/Parser/Parser/accept()V
.line 289
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 290
	new VC/ASTs/VoidType
	dup
	aload_1
	invokespecial VC/ASTs/VoidType/<init>(LVC/Scanner/SourcePosition;)V
	goto Label11
Label0:
.line 293
	aload_0
	invokevirtual VC/Parser/Parser/accept()V
.line 294
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 295
	new VC/ASTs/BooleanType
	dup
	aload_1
	invokespecial VC/ASTs/BooleanType/<init>(LVC/Scanner/SourcePosition;)V
	goto Label11
Label7:
.line 298
	aload_0
	invokevirtual VC/Parser/Parser/accept()V
.line 299
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 300
	new VC/ASTs/IntType
	dup
	aload_1
	invokespecial VC/ASTs/IntType/<init>(LVC/Scanner/SourcePosition;)V
	goto Label11
Label4:
.line 303
	aload_0
	invokevirtual VC/Parser/Parser/accept()V
.line 304
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 305
	new VC/ASTs/FloatType
	dup
	aload_1
	invokespecial VC/ASTs/FloatType/<init>(LVC/Scanner/SourcePosition;)V
	goto Label11
Label1:
.line 307
	aload_0
	ldc_w "\"%\" illegal type (must be one of void, int, float and boolean)"
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.spelling Ljava/lang/String;
	invokevirtual VC/Parser/Parser/syntacticError(Ljava/lang/String;Ljava/lang/String;)LVC/Parser/SyntaxError;
	athrow
Label11:
.line 286
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private parseCompoundStmt()LVC/ASTs/Stmt;
.limit stack 5
.limit locals 4
.var 0 is this LVC/Parser/Parser; from Label2 to Label2

.line 316
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_1
.line 317
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 319
	aload_0
	bipush 25
	invokevirtual VC/Parser/Parser/match(I)V
.line 320
	aload_0
	invokevirtual VC/Parser/Parser/parseDeclStmtList()LVC/ASTs/ASTList;
	astore_2
.line 321
	aload_0
	invokevirtual VC/Parser/Parser/parseStmtList()LVC/ASTs/ASTList;
	astore_3
.line 322
	aload_0
	bipush 26
	invokevirtual VC/Parser/Parser/match(I)V
.line 323
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 325
	aload_2
	invokevirtual VC/ASTs/ASTList/isEmpty()Z
	ifeq Label0
	aload_3
	invokevirtual VC/ASTs/ASTList/isEmpty()Z
	ifeq Label0
.line 326
	new VC/ASTs/EmptyCompStmt
	dup
	aload_1
	invokespecial VC/ASTs/EmptyCompStmt/<init>(LVC/Scanner/SourcePosition;)V
	goto Label2
Label0:
.line 327
	new VC/ASTs/CompoundStmt
	dup
	aload_2
	aload_3
	aload_1
	invokespecial VC/ASTs/CompoundStmt/<init>(LVC/ASTs/ASTList;LVC/ASTs/ASTList;LVC/Scanner/SourcePosition;)V
Label2:
.line 325
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private parseDeclStmtList()LVC/ASTs/ASTList;
.limit stack 3
.limit locals 4
.var 0 is this LVC/Parser/Parser; from Label6 to Label6

.line 331
	aconst_null
	astore_1
.line 333
	aload_0
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	invokevirtual VC/Parser/Parser/isTypeToken(I)Z
	ifeq Label0
.line 334
	aload_0
	invokevirtual VC/Parser/Parser/parseVarDecl()LVC/ASTs/ASTList;
	astore_1
Label4:
.line 335
	aload_0
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	invokevirtual VC/Parser/Parser/isTypeToken(I)Z
	ifeq Label0
.line 336
	aload_0
	invokevirtual VC/Parser/Parser/parseVarDecl()LVC/ASTs/ASTList;
	astore_2
.line 337
	aload_1
	astore_3
Label3:
.line 338
	aload_3
	invokevirtual VC/ASTs/ASTList/getNext()LVC/ASTs/ASTList;
	invokevirtual VC/ASTs/ASTList/isEmpty()Z
	ifne Label2
.line 339
	aload_3
	invokevirtual VC/ASTs/ASTList/getNext()LVC/ASTs/ASTList;
	astore_3
	goto Label3
Label2:
.line 341
	aload_3
	aload_2
	invokevirtual VC/ASTs/ASTList/setNext(LVC/ASTs/ASTList;)V
.line 342
	goto Label4
Label0:
.line 345
	aload_1
	ifnull Label5
	aload_1
	goto Label6
Label5:
	new VC/ASTs/EmptyDeclList
	dup
	aload_0
	getfield VC.Parser.Parser.dummyPos LVC/Scanner/SourcePosition;
	invokespecial VC/ASTs/EmptyDeclList/<init>(LVC/Scanner/SourcePosition;)V
Label6:
	areturn

.throws VC/Parser/SyntaxError

.method private parseStmtList()LVC/ASTs/ASTList;
.limit stack 6
.limit locals 4
.var 0 is this LVC/Parser/Parser; from Label2 to Label2

.line 349
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_1
.line 350
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 352
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 26
	if_icmpeq Label0
.line 353
	aload_0
	invokevirtual VC/Parser/Parser/parseStmt()LVC/ASTs/Stmt;
	astore_2
.line 354
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 26
	if_icmpeq Label1
.line 355
	aload_0
	invokevirtual VC/Parser/Parser/parseStmtList()LVC/ASTs/ASTList;
	astore_3
.line 356
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 357
	new VC/ASTs/StmtList
	dup
	aload_2
	aload_3
	aload_1
	invokespecial VC/ASTs/StmtList/<init>(LVC/ASTs/Stmt;LVC/ASTs/ASTList;LVC/Scanner/SourcePosition;)V
	areturn
Label1:
.line 359
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 360
	new VC/ASTs/StmtList
	dup
	aload_2
	new VC/ASTs/EmptyStmtList
	dup
	aload_0
	getfield VC.Parser.Parser.dummyPos LVC/Scanner/SourcePosition;
	invokespecial VC/ASTs/EmptyStmtList/<init>(LVC/Scanner/SourcePosition;)V
	aload_1
	invokespecial VC/ASTs/StmtList/<init>(LVC/ASTs/Stmt;LVC/ASTs/ASTList;LVC/Scanner/SourcePosition;)V
	areturn
Label0:
.line 363
	new VC/ASTs/EmptyStmtList
	dup
	aload_0
	getfield VC.Parser.Parser.dummyPos LVC/Scanner/SourcePosition;
	invokespecial VC/ASTs/EmptyStmtList/<init>(LVC/Scanner/SourcePosition;)V
Label2:
	areturn

.throws VC/Parser/SyntaxError

.method private parseStmt()LVC/ASTs/Stmt;
.limit stack 1
.limit locals 1
.var 0 is this LVC/Parser/Parser; from Label26 to Label26

.line 368
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	tableswitch 1 25
		Label0
		Label1
		Label2
		Label2
		Label4
		Label5
		Label2
		Label7
		Label2
		Label9
		Label2
		Label2
		Label2
		Label2
		Label2
		Label2
		Label2
		Label2
		Label2
		Label2
		Label2
		Label2
		Label2
		Label2
		Label24
		default: Label2
Label24:
.line 369
	aload_0
	invokevirtual VC/Parser/Parser/parseCompoundStmt()LVC/ASTs/Stmt;
	goto Label26
Label5:
.line 370
	aload_0
	invokevirtual VC/Parser/Parser/parseIfStmt()LVC/ASTs/Stmt;
	goto Label26
Label4:
.line 371
	aload_0
	invokevirtual VC/Parser/Parser/parseForStmt()LVC/ASTs/ForStmt;
	goto Label26
Label9:
.line 372
	aload_0
	invokevirtual VC/Parser/Parser/parseWhileStmt()LVC/ASTs/Stmt;
	goto Label26
Label0:
.line 373
	aload_0
	invokevirtual VC/Parser/Parser/parseBreakStmt()LVC/ASTs/Stmt;
	goto Label26
Label1:
.line 374
	aload_0
	invokevirtual VC/Parser/Parser/parseContinueStmt()LVC/ASTs/Stmt;
	goto Label26
Label7:
.line 375
	aload_0
	invokevirtual VC/Parser/Parser/parseReturnStmt()LVC/ASTs/Stmt;
	goto Label26
Label2:
.line 376
	aload_0
	invokevirtual VC/Parser/Parser/parseExprStmt()LVC/ASTs/Stmt;
Label26:
.line 368
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private parseIfStmt()LVC/ASTs/Stmt;
.limit stack 6
.limit locals 5
.var 0 is this LVC/Parser/Parser; from Label1 to Label1

.line 381
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_1
.line 382
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 384
	aload_0
	bipush 6
	invokevirtual VC/Parser/Parser/match(I)V
.line 385
	aload_0
	bipush 27
	invokevirtual VC/Parser/Parser/match(I)V
.line 386
	aload_0
	invokevirtual VC/Parser/Parser/parseExpr()LVC/ASTs/Expr;
	astore_2
.line 387
	aload_0
	bipush 28
	invokevirtual VC/Parser/Parser/match(I)V
.line 388
	aload_0
	invokevirtual VC/Parser/Parser/parseStmt()LVC/ASTs/Stmt;
	astore_3
.line 390
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	iconst_3
	if_icmpne Label0
.line 391
	aload_0
	invokevirtual VC/Parser/Parser/accept()V
.line 392
	aload_0
	invokevirtual VC/Parser/Parser/parseStmt()LVC/ASTs/Stmt;
	astore 4
.line 393
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 394
	new VC/ASTs/IfStmt
	dup
	aload_2
	aload_3
	aload 4
	aload_1
	invokespecial VC/ASTs/IfStmt/<init>(LVC/ASTs/Expr;LVC/ASTs/Stmt;LVC/ASTs/Stmt;LVC/Scanner/SourcePosition;)V
	areturn
Label0:
.line 396
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 397
	new VC/ASTs/IfStmt
	dup
	aload_2
	aload_3
	aload_1
	invokespecial VC/ASTs/IfStmt/<init>(LVC/ASTs/Expr;LVC/ASTs/Stmt;LVC/Scanner/SourcePosition;)V
Label1:
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private parseForStmt()LVC/ASTs/ForStmt;
.limit stack 7
.limit locals 6
.var 0 is this LVC/Parser/Parser; from Label6 to Label6

.line 402
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_1
.line 403
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 405
	aload_0
	iconst_5
	invokevirtual VC/Parser/Parser/match(I)V
.line 406
	aload_0
	bipush 27
	invokevirtual VC/Parser/Parser/match(I)V
.line 407
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 31
	if_icmpeq Label0
	aload_0
	invokevirtual VC/Parser/Parser/parseExpr()LVC/ASTs/Expr;
	goto Label1
Label0:
	new VC/ASTs/EmptyExpr
	dup
	aload_0
	getfield VC.Parser.Parser.dummyPos LVC/Scanner/SourcePosition;
	invokespecial VC/ASTs/EmptyExpr/<init>(LVC/Scanner/SourcePosition;)V
Label1:
	astore_2
.line 408
	aload_0
	bipush 31
	invokevirtual VC/Parser/Parser/match(I)V
.line 409
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 31
	if_icmpeq Label2
	aload_0
	invokevirtual VC/Parser/Parser/parseExpr()LVC/ASTs/Expr;
	goto Label3
Label2:
	new VC/ASTs/EmptyExpr
	dup
	aload_0
	getfield VC.Parser.Parser.dummyPos LVC/Scanner/SourcePosition;
	invokespecial VC/ASTs/EmptyExpr/<init>(LVC/Scanner/SourcePosition;)V
Label3:
	astore_3
.line 410
	aload_0
	bipush 31
	invokevirtual VC/Parser/Parser/match(I)V
.line 411
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 28
	if_icmpeq Label4
	aload_0
	invokevirtual VC/Parser/Parser/parseExpr()LVC/ASTs/Expr;
	goto Label5
Label4:
	new VC/ASTs/EmptyExpr
	dup
	aload_0
	getfield VC.Parser.Parser.dummyPos LVC/Scanner/SourcePosition;
	invokespecial VC/ASTs/EmptyExpr/<init>(LVC/Scanner/SourcePosition;)V
Label5:
	astore 4
.line 412
	aload_0
	bipush 28
	invokevirtual VC/Parser/Parser/match(I)V
.line 413
	aload_0
	invokevirtual VC/Parser/Parser/parseStmt()LVC/ASTs/Stmt;
	astore 5
.line 415
	new VC/ASTs/ForStmt
	dup
	aload_2
	aload_3
	aload 4
	aload 5
	aload_1
	invokespecial VC/ASTs/ForStmt/<init>(LVC/ASTs/Expr;LVC/ASTs/Expr;LVC/ASTs/Expr;LVC/ASTs/Stmt;LVC/Scanner/SourcePosition;)V
Label6:
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private parseWhileStmt()LVC/ASTs/Stmt;
.limit stack 5
.limit locals 4
.var 0 is this LVC/Parser/Parser; from Label0 to Label0

.line 419
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_1
.line 420
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 422
	aload_0
	bipush 10
	invokevirtual VC/Parser/Parser/match(I)V
.line 423
	aload_0
	bipush 27
	invokevirtual VC/Parser/Parser/match(I)V
.line 424
	aload_0
	invokevirtual VC/Parser/Parser/parseExpr()LVC/ASTs/Expr;
	astore_2
.line 425
	aload_0
	bipush 28
	invokevirtual VC/Parser/Parser/match(I)V
.line 426
	aload_0
	invokevirtual VC/Parser/Parser/parseStmt()LVC/ASTs/Stmt;
	astore_3
.line 427
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 428
	new VC/ASTs/WhileStmt
	dup
	aload_2
	aload_3
	aload_1
	invokespecial VC/ASTs/WhileStmt/<init>(LVC/ASTs/Expr;LVC/ASTs/Stmt;LVC/Scanner/SourcePosition;)V
Label0:
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private parseBreakStmt()LVC/ASTs/Stmt;
.limit stack 3
.limit locals 2
.var 0 is this LVC/Parser/Parser; from Label0 to Label0

.line 432
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_1
.line 433
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 435
	aload_0
	iconst_1
	invokevirtual VC/Parser/Parser/match(I)V
.line 436
	aload_0
	bipush 31
	invokevirtual VC/Parser/Parser/match(I)V
.line 437
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 438
	new VC/ASTs/BreakStmt
	dup
	aload_1
	invokespecial VC/ASTs/BreakStmt/<init>(LVC/Scanner/SourcePosition;)V
Label0:
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private parseContinueStmt()LVC/ASTs/Stmt;
.limit stack 3
.limit locals 2
.var 0 is this LVC/Parser/Parser; from Label0 to Label0

.line 442
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_1
.line 443
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 445
	aload_0
	iconst_2
	invokevirtual VC/Parser/Parser/match(I)V
.line 446
	aload_0
	bipush 31
	invokevirtual VC/Parser/Parser/match(I)V
.line 447
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 448
	new VC/ASTs/ContinueStmt
	dup
	aload_1
	invokespecial VC/ASTs/ContinueStmt/<init>(LVC/Scanner/SourcePosition;)V
Label0:
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private parseReturnStmt()LVC/ASTs/Stmt;
.limit stack 4
.limit locals 3
.var 0 is this LVC/Parser/Parser; from Label2 to Label2

.line 452
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_1
.line 453
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 455
	aload_0
	bipush 8
	invokevirtual VC/Parser/Parser/match(I)V
.line 456
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 31
	if_icmpeq Label0
	aload_0
	invokevirtual VC/Parser/Parser/parseExpr()LVC/ASTs/Expr;
	goto Label1
Label0:
	new VC/ASTs/EmptyExpr
	dup
	aload_0
	getfield VC.Parser.Parser.dummyPos LVC/Scanner/SourcePosition;
	invokespecial VC/ASTs/EmptyExpr/<init>(LVC/Scanner/SourcePosition;)V
Label1:
	astore_2
.line 457
	aload_0
	bipush 31
	invokevirtual VC/Parser/Parser/match(I)V
.line 458
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 459
	new VC/ASTs/ReturnStmt
	dup
	aload_2
	aload_1
	invokespecial VC/ASTs/ReturnStmt/<init>(LVC/ASTs/Expr;LVC/Scanner/SourcePosition;)V
Label2:
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private parseExprStmt()LVC/ASTs/Stmt;
.limit stack 5
.limit locals 3
.var 0 is this LVC/Parser/Parser; from Label1 to Label1

.line 463
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_1
.line 464
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 466
	aload_0
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	invokevirtual VC/Parser/Parser/isExprStart(I)Z
	ifeq Label0
.line 467
	aload_0
	invokevirtual VC/Parser/Parser/parseExpr()LVC/ASTs/Expr;
	astore_2
.line 468
	aload_0
	bipush 31
	invokevirtual VC/Parser/Parser/match(I)V
.line 469
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 470
	new VC/ASTs/ExprStmt
	dup
	aload_2
	aload_1
	invokespecial VC/ASTs/ExprStmt/<init>(LVC/ASTs/Expr;LVC/Scanner/SourcePosition;)V
	areturn
Label0:
.line 472
	aload_0
	bipush 31
	invokevirtual VC/Parser/Parser/match(I)V
.line 473
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 474
	new VC/ASTs/ExprStmt
	dup
	new VC/ASTs/EmptyExpr
	dup
	aload_0
	getfield VC.Parser.Parser.dummyPos LVC/Scanner/SourcePosition;
	invokespecial VC/ASTs/EmptyExpr/<init>(LVC/Scanner/SourcePosition;)V
	aload_1
	invokespecial VC/ASTs/ExprStmt/<init>(LVC/ASTs/Expr;LVC/Scanner/SourcePosition;)V
Label1:
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private isExprStart(I)Z
.limit stack 1
.limit locals 2
.var 0 is this LVC/Parser/Parser; from Label28 to Label28
.var 1 is arg0 I from Label28 to Label28

.line 479
	iload_1
	tableswitch 11 37
		Label0
		Label0
		Label2
		Label2
		Label0
		Label2
		Label2
		Label2
		Label2
		Label2
		Label2
		Label2
		Label2
		Label2
		Label2
		Label2
		Label0
		Label2
		Label2
		Label2
		Label2
		Label2
		Label0
		Label0
		Label0
		Label0
		Label0
		default: Label2
Label0:
.line 483
	iconst_1
	goto Label28
Label2:
.line 484
	iconst_0
Label28:
.line 479
	ireturn

.end method

.method private parseParaList()LVC/ASTs/ASTList;
.limit stack 3
.limit locals 3
.var 0 is this LVC/Parser/Parser; from Label1 to Label1

.line 490
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_1
.line 491
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 493
	aload_0
	bipush 27
	invokevirtual VC/Parser/Parser/match(I)V
.line 494
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 28
	if_icmpne Label0
.line 495
	aload_0
	invokevirtual VC/Parser/Parser/accept()V
.line 496
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 497
	new VC/ASTs/EmptyParaList
	dup
	aload_1
	invokespecial VC/ASTs/EmptyParaList/<init>(LVC/Scanner/SourcePosition;)V
	areturn
Label0:
.line 499
	aload_0
	invokevirtual VC/Parser/Parser/parseProperParaList()LVC/ASTs/ASTList;
	astore_2
.line 500
	aload_0
	bipush 28
	invokevirtual VC/Parser/Parser/match(I)V
.line 501
	aload_2
Label1:
	areturn

.throws VC/Parser/SyntaxError

.method private parseProperParaList()LVC/ASTs/ASTList;
.limit stack 6
.limit locals 4
.var 0 is this LVC/Parser/Parser; from Label1 to Label1

.line 506
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_1
.line 507
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 509
	aload_0
	invokevirtual VC/Parser/Parser/parseParaDecl()LVC/ASTs/ParaDecl;
	astore_2
.line 510
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 32
	if_icmpne Label0
.line 511
	aload_0
	invokevirtual VC/Parser/Parser/accept()V
.line 512
	aload_0
	invokevirtual VC/Parser/Parser/parseProperParaList()LVC/ASTs/ASTList;
	astore_3
.line 513
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 514
	new VC/ASTs/ParaList
	dup
	aload_2
	aload_3
	aload_1
	invokespecial VC/ASTs/ParaList/<init>(LVC/ASTs/Decl;LVC/ASTs/ASTList;LVC/Scanner/SourcePosition;)V
	areturn
Label0:
.line 516
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 517
	new VC/ASTs/ParaList
	dup
	aload_2
	new VC/ASTs/EmptyParaList
	dup
	aload_0
	getfield VC.Parser.Parser.dummyPos LVC/Scanner/SourcePosition;
	invokespecial VC/ASTs/EmptyParaList/<init>(LVC/Scanner/SourcePosition;)V
	aload_1
	invokespecial VC/ASTs/ParaList/<init>(LVC/ASTs/Decl;LVC/ASTs/ASTList;LVC/Scanner/SourcePosition;)V
Label1:
	areturn

.throws VC/Parser/SyntaxError

.method private parseParaDecl()LVC/ASTs/ParaDecl;
.limit stack 5
.limit locals 4
.var 0 is this LVC/Parser/Parser; from Label0 to Label0

.line 522
	aload_0
	invokevirtual VC/Parser/Parser/parseType()LVC/ASTs/Type;
	astore_1
.line 523
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_2
.line 524
	aload_0
	aload_2
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 525
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/parseDeclarator(LVC/ASTs/Type;)LVC/Parser/Parser$TypeAndIdent;
	astore_3
.line 526
	aload_0
	aload_2
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 527
	new VC/ASTs/ParaDecl
	dup
	aload_3
	getfield VC.Parser.Parser$TypeAndIdent.tAST LVC/ASTs/Type;
	aload_3
	getfield VC.Parser.Parser$TypeAndIdent.iAST LVC/ASTs/Ident;
	aload_2
	invokespecial VC/ASTs/ParaDecl/<init>(LVC/ASTs/Type;LVC/ASTs/Ident;LVC/Scanner/SourcePosition;)V
Label0:
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private parseArgList()LVC/ASTs/ASTList;
.limit stack 3
.limit locals 3
.var 0 is this LVC/Parser/Parser; from Label1 to Label1

.line 531
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_1
.line 532
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 534
	aload_0
	bipush 27
	invokevirtual VC/Parser/Parser/match(I)V
.line 535
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 28
	if_icmpne Label0
.line 536
	aload_0
	bipush 28
	invokevirtual VC/Parser/Parser/match(I)V
.line 537
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 538
	new VC/ASTs/EmptyArgList
	dup
	aload_1
	invokespecial VC/ASTs/EmptyArgList/<init>(LVC/Scanner/SourcePosition;)V
	areturn
Label0:
.line 540
	aload_0
	invokevirtual VC/Parser/Parser/parseProperArgList()LVC/ASTs/ASTList;
	astore_2
.line 541
	aload_0
	bipush 28
	invokevirtual VC/Parser/Parser/match(I)V
.line 542
	aload_2
Label1:
	areturn

.throws VC/Parser/SyntaxError

.method private parseProperArgList()LVC/ASTs/ASTList;
.limit stack 6
.limit locals 4
.var 0 is this LVC/Parser/Parser; from Label1 to Label1

.line 547
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_1
.line 548
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 550
	aload_0
	invokevirtual VC/Parser/Parser/parseArg()LVC/ASTs/Arg;
	astore_2
.line 551
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 32
	if_icmpne Label0
.line 552
	aload_0
	invokevirtual VC/Parser/Parser/accept()V
.line 553
	aload_0
	invokevirtual VC/Parser/Parser/parseProperArgList()LVC/ASTs/ASTList;
	astore_3
.line 554
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 555
	new VC/ASTs/ArgList
	dup
	aload_2
	aload_3
	aload_1
	invokespecial VC/ASTs/ArgList/<init>(LVC/ASTs/Arg;LVC/ASTs/ASTList;LVC/Scanner/SourcePosition;)V
	areturn
Label0:
.line 557
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 558
	new VC/ASTs/ArgList
	dup
	aload_2
	new VC/ASTs/EmptyArgList
	dup
	aload_1
	invokespecial VC/ASTs/EmptyArgList/<init>(LVC/Scanner/SourcePosition;)V
	aload_1
	invokespecial VC/ASTs/ArgList/<init>(LVC/ASTs/Arg;LVC/ASTs/ASTList;LVC/Scanner/SourcePosition;)V
Label1:
	areturn

.throws VC/Parser/SyntaxError

.method private parseArg()LVC/ASTs/Arg;
.limit stack 4
.limit locals 3
.var 0 is this LVC/Parser/Parser; from Label0 to Label0

.line 563
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_1
.line 564
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 565
	aload_0
	invokevirtual VC/Parser/Parser/parseExpr()LVC/ASTs/Expr;
	astore_2
.line 566
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 567
	new VC/ASTs/Arg
	dup
	aload_2
	aload_1
	invokespecial VC/ASTs/Arg/<init>(LVC/ASTs/Expr;LVC/Scanner/SourcePosition;)V
Label0:
	areturn

.throws VC/Parser/SyntaxError
.end method

.method  parseIdent()LVC/ASTs/Ident;
.limit stack 4
.limit locals 2
.var 0 is this LVC/Parser/Parser; from Label1 to Label1

.line 571
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 33
	if_icmpeq Label0
.line 572
	aload_0
	ldc_w "identifier expected here"
	ldc_w ""
	invokevirtual VC/Parser/Parser/syntacticError(Ljava/lang/String;Ljava/lang/String;)LVC/Parser/SyntaxError;
	athrow
Label0:
.line 575
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.spelling Ljava/lang/String;
	astore_1
.line 576
	aload_0
	invokevirtual VC/Parser/Parser/accept()V
.line 577
	new VC/ASTs/Ident
	dup
	aload_1
	aload_0
	getfield VC.Parser.Parser.previousTokenPosition LVC/Scanner/SourcePosition;
	invokespecial VC/ASTs/Ident/<init>(Ljava/lang/String;LVC/Scanner/SourcePosition;)V
Label1:
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private acceptOperator()LVC/ASTs/Operator;
.limit stack 4
.limit locals 2
.var 0 is this LVC/Parser/Parser; from Label0 to Label0

.line 582
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.spelling Ljava/lang/String;
	astore_1
.line 583
	aload_0
	invokevirtual VC/Parser/Parser/accept()V
.line 584
	new VC/ASTs/Operator
	dup
	aload_1
	aload_0
	getfield VC.Parser.Parser.previousTokenPosition LVC/Scanner/SourcePosition;
	invokespecial VC/ASTs/Operator/<init>(Ljava/lang/String;LVC/Scanner/SourcePosition;)V
Label0:
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private parseExpr()LVC/ASTs/Expr;
.limit stack 1
.limit locals 1
.var 0 is this LVC/Parser/Parser; from Label0 to Label0

.line 589
	aload_0
	invokevirtual VC/Parser/Parser/parseAssignExpr()LVC/ASTs/Expr;
Label0:
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private parseAssignExpr()LVC/ASTs/Expr;
.limit stack 5
.limit locals 4
.var 0 is this LVC/Parser/Parser; from Label1 to Label1

.line 593
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_1
.line 594
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 596
	aload_0
	invokevirtual VC/Parser/Parser/parseCondOrExpr()LVC/ASTs/Expr;
	astore_2
.line 597
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 17
	if_icmpne Label0
.line 598
	aload_0
	invokevirtual VC/Parser/Parser/acceptOperator()LVC/ASTs/Operator;
	pop
.line 599
	aload_0
	invokevirtual VC/Parser/Parser/parseAssignExpr()LVC/ASTs/Expr;
	astore_3
.line 600
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 601
	new VC/ASTs/AssignExpr
	dup
	aload_2
	aload_3
	aload_1
	invokespecial VC/ASTs/AssignExpr/<init>(LVC/ASTs/Expr;LVC/ASTs/Expr;LVC/Scanner/SourcePosition;)V
	areturn
Label0:
.line 603
	aload_2
Label1:
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private parseCondOrExpr()LVC/ASTs/Expr;
.limit stack 6
.limit locals 6
.var 0 is this LVC/Parser/Parser; from Label2 to Label2

.line 607
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_1
.line 608
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 610
	aload_0
	invokevirtual VC/Parser/Parser/parseCondAndExpr()LVC/ASTs/Expr;
	astore_2
Label1:
.line 611
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 24
	if_icmpne Label0
.line 612
	aload_0
	invokevirtual VC/Parser/Parser/acceptOperator()LVC/ASTs/Operator;
	astore_3
.line 613
	aload_0
	invokevirtual VC/Parser/Parser/parseCondAndExpr()LVC/ASTs/Expr;
	astore 4
.line 614
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore 5
.line 615
	aload_0
	aload_1
	aload 5
	invokevirtual VC/Parser/Parser/copyStart(LVC/Scanner/SourcePosition;LVC/Scanner/SourcePosition;)V
.line 616
	aload_0
	aload 5
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 617
	new VC/ASTs/BinaryExpr
	dup
	aload_2
	aload_3
	aload 4
	aload 5
	invokespecial VC/ASTs/BinaryExpr/<init>(LVC/ASTs/Expr;LVC/ASTs/Operator;LVC/ASTs/Expr;LVC/Scanner/SourcePosition;)V
	astore_2
.line 618
	goto Label1
Label0:
.line 619
	aload_2
Label2:
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private parseCondAndExpr()LVC/ASTs/Expr;
.limit stack 6
.limit locals 6
.var 0 is this LVC/Parser/Parser; from Label2 to Label2

.line 623
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_1
.line 624
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 626
	aload_0
	invokevirtual VC/Parser/Parser/parseEqualityExpr()LVC/ASTs/Expr;
	astore_2
Label1:
.line 627
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 23
	if_icmpne Label0
.line 628
	aload_0
	invokevirtual VC/Parser/Parser/acceptOperator()LVC/ASTs/Operator;
	astore_3
.line 629
	aload_0
	invokevirtual VC/Parser/Parser/parseEqualityExpr()LVC/ASTs/Expr;
	astore 4
.line 630
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore 5
.line 631
	aload_0
	aload_1
	aload 5
	invokevirtual VC/Parser/Parser/copyStart(LVC/Scanner/SourcePosition;LVC/Scanner/SourcePosition;)V
.line 632
	aload_0
	aload 5
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 633
	new VC/ASTs/BinaryExpr
	dup
	aload_2
	aload_3
	aload 4
	aload 5
	invokespecial VC/ASTs/BinaryExpr/<init>(LVC/ASTs/Expr;LVC/ASTs/Operator;LVC/ASTs/Expr;LVC/Scanner/SourcePosition;)V
	astore_2
.line 634
	goto Label1
Label0:
.line 635
	aload_2
Label2:
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private parseEqualityExpr()LVC/ASTs/Expr;
.limit stack 6
.limit locals 6
.var 0 is this LVC/Parser/Parser; from Label3 to Label3

.line 639
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_1
.line 640
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 642
	aload_0
	invokevirtual VC/Parser/Parser/parseRelExpr()LVC/ASTs/Expr;
	astore_2
Label2:
.line 643
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 18
	if_icmpeq Label0
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 16
	if_icmpne Label1
Label0:
.line 644
	aload_0
	invokevirtual VC/Parser/Parser/acceptOperator()LVC/ASTs/Operator;
	astore_3
.line 645
	aload_0
	invokevirtual VC/Parser/Parser/parseRelExpr()LVC/ASTs/Expr;
	astore 4
.line 646
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore 5
.line 647
	aload_0
	aload_1
	aload 5
	invokevirtual VC/Parser/Parser/copyStart(LVC/Scanner/SourcePosition;LVC/Scanner/SourcePosition;)V
.line 648
	aload_0
	aload 5
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 649
	new VC/ASTs/BinaryExpr
	dup
	aload_2
	aload_3
	aload 4
	aload 5
	invokespecial VC/ASTs/BinaryExpr/<init>(LVC/ASTs/Expr;LVC/ASTs/Operator;LVC/ASTs/Expr;LVC/Scanner/SourcePosition;)V
	astore_2
.line 650
	goto Label2
Label1:
.line 651
	aload_2
Label3:
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private parseRelExpr()LVC/ASTs/Expr;
.limit stack 6
.limit locals 6
.var 0 is this LVC/Parser/Parser; from Label2 to Label2

.line 655
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_1
.line 656
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 658
	aload_0
	invokevirtual VC/Parser/Parser/parseAdditiveExpr()LVC/ASTs/Expr;
	astore_2
Label1:
.line 659
	aload_0
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	invokevirtual VC/Parser/Parser/isRelationalOp(I)Z
	ifeq Label0
.line 660
	aload_0
	invokevirtual VC/Parser/Parser/acceptOperator()LVC/ASTs/Operator;
	astore_3
.line 661
	aload_0
	invokevirtual VC/Parser/Parser/parseAdditiveExpr()LVC/ASTs/Expr;
	astore 4
.line 662
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore 5
.line 663
	aload_0
	aload_1
	aload 5
	invokevirtual VC/Parser/Parser/copyStart(LVC/Scanner/SourcePosition;LVC/Scanner/SourcePosition;)V
.line 664
	aload_0
	aload 5
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 665
	new VC/ASTs/BinaryExpr
	dup
	aload_2
	aload_3
	aload 4
	aload 5
	invokespecial VC/ASTs/BinaryExpr/<init>(LVC/ASTs/Expr;LVC/ASTs/Operator;LVC/ASTs/Expr;LVC/Scanner/SourcePosition;)V
	astore_2
.line 666
	goto Label1
Label0:
.line 667
	aload_2
Label2:
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private isRelationalOp(I)Z
.limit stack 2
.limit locals 2
.var 0 is this LVC/Parser/Parser; from Label4 to Label4
.var 1 is arg0 I from Label4 to Label4

.line 671
	iload_1
	bipush 19
	if_icmpeq Label0
	iload_1
	bipush 20
	if_icmpeq Label0
	iload_1
	bipush 21
	if_icmpeq Label0
	iload_1
	bipush 22
	if_icmpne Label3
Label0:
	iconst_1
	goto Label4
Label3:
	iconst_0
Label4:
	ireturn

.end method

.method private parseAdditiveExpr()LVC/ASTs/Expr;
.limit stack 6
.limit locals 6
.var 0 is this LVC/Parser/Parser; from Label3 to Label3

.line 676
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_1
.line 677
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 679
	aload_0
	invokevirtual VC/Parser/Parser/parseMultiplicativeExpr()LVC/ASTs/Expr;
	astore_2
Label2:
.line 680
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 11
	if_icmpeq Label0
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 12
	if_icmpne Label1
Label0:
.line 681
	aload_0
	invokevirtual VC/Parser/Parser/acceptOperator()LVC/ASTs/Operator;
	astore_3
.line 682
	aload_0
	invokevirtual VC/Parser/Parser/parseMultiplicativeExpr()LVC/ASTs/Expr;
	astore 4
.line 683
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore 5
.line 684
	aload_0
	aload_1
	aload 5
	invokevirtual VC/Parser/Parser/copyStart(LVC/Scanner/SourcePosition;LVC/Scanner/SourcePosition;)V
.line 685
	aload_0
	aload 5
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 686
	new VC/ASTs/BinaryExpr
	dup
	aload_2
	aload_3
	aload 4
	aload 5
	invokespecial VC/ASTs/BinaryExpr/<init>(LVC/ASTs/Expr;LVC/ASTs/Operator;LVC/ASTs/Expr;LVC/Scanner/SourcePosition;)V
	astore_2
.line 687
	goto Label2
Label1:
.line 688
	aload_2
Label3:
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private parseMultiplicativeExpr()LVC/ASTs/Expr;
.limit stack 6
.limit locals 6
.var 0 is this LVC/Parser/Parser; from Label3 to Label3

.line 692
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_1
.line 693
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 695
	aload_0
	invokevirtual VC/Parser/Parser/parseUnaryExpr()LVC/ASTs/Expr;
	astore_2
Label2:
.line 696
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 13
	if_icmpeq Label0
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 14
	if_icmpne Label1
Label0:
.line 697
	aload_0
	invokevirtual VC/Parser/Parser/acceptOperator()LVC/ASTs/Operator;
	astore_3
.line 698
	aload_0
	invokevirtual VC/Parser/Parser/parseUnaryExpr()LVC/ASTs/Expr;
	astore 4
.line 699
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore 5
.line 700
	aload_0
	aload_1
	aload 5
	invokevirtual VC/Parser/Parser/copyStart(LVC/Scanner/SourcePosition;LVC/Scanner/SourcePosition;)V
.line 701
	aload_0
	aload 5
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 702
	new VC/ASTs/BinaryExpr
	dup
	aload_2
	aload_3
	aload 4
	aload 5
	invokespecial VC/ASTs/BinaryExpr/<init>(LVC/ASTs/Expr;LVC/ASTs/Operator;LVC/ASTs/Expr;LVC/Scanner/SourcePosition;)V
	astore_2
.line 703
	goto Label2
Label1:
.line 704
	aload_2
Label3:
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private parseUnaryExpr()LVC/ASTs/Expr;
.limit stack 5
.limit locals 4
.var 0 is this LVC/Parser/Parser; from Label1 to Label1

.line 708
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_1
.line 709
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 711
	aload_0
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	invokevirtual VC/Parser/Parser/isUnaryOp(I)Z
	ifeq Label0
.line 712
	aload_0
	invokevirtual VC/Parser/Parser/acceptOperator()LVC/ASTs/Operator;
	astore_2
.line 713
	aload_0
	invokevirtual VC/Parser/Parser/parseUnaryExpr()LVC/ASTs/Expr;
	astore_3
.line 714
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 715
	new VC/ASTs/UnaryExpr
	dup
	aload_2
	aload_3
	aload_1
	invokespecial VC/ASTs/UnaryExpr/<init>(LVC/ASTs/Operator;LVC/ASTs/Expr;LVC/Scanner/SourcePosition;)V
	areturn
Label0:
.line 717
	aload_0
	invokevirtual VC/Parser/Parser/parsePrimaryExpr()LVC/ASTs/Expr;
Label1:
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private isUnaryOp(I)Z
.limit stack 2
.limit locals 2
.var 0 is this LVC/Parser/Parser; from Label3 to Label3
.var 1 is arg0 I from Label3 to Label3

.line 722
	iload_1
	bipush 11
	if_icmpeq Label0
	iload_1
	bipush 12
	if_icmpeq Label0
	iload_1
	bipush 15
	if_icmpne Label2
Label0:
	iconst_1
	goto Label3
Label2:
	iconst_0
Label3:
	ireturn

.end method

.method private parsePrimaryExpr()LVC/ASTs/Expr;
.limit stack 5
.limit locals 5
.var 0 is this LVC/Parser/Parser; from Label13 to Label13

.line 726
	new VC/Scanner/SourcePosition
	dup
	invokespecial VC/Scanner/SourcePosition/<init>()V
	astore_1
.line 727
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/start(LVC/Scanner/SourcePosition;)V
.line 729
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	tableswitch 27 37
		Label0
		Label1
		Label1
		Label1
		Label1
		Label1
		Label6
		Label7
		Label8
		Label9
		Label10
		default: Label1
Label6:
.line 731
	aload_0
	invokevirtual VC/Parser/Parser/parseIdent()LVC/ASTs/Ident;
	astore_2
.line 732
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 27
	if_icmpne Label12
.line 733
	aload_0
	invokevirtual VC/Parser/Parser/parseArgList()LVC/ASTs/ASTList;
	astore_3
.line 734
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 735
	new VC/ASTs/CallExpr
	dup
	aload_2
	aload_3
	aload_1
	invokespecial VC/ASTs/CallExpr/<init>(LVC/ASTs/Ident;LVC/ASTs/ASTList;LVC/Scanner/SourcePosition;)V
	goto Label13
Label12:
.line 736
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 29
	if_icmpne Label14
.line 737
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 738
	new VC/ASTs/SimpleVar
	dup
	aload_2
	aload_1
	invokespecial VC/ASTs/SimpleVar/<init>(LVC/ASTs/Ident;LVC/Scanner/SourcePosition;)V
	astore_3
.line 739
	aload_0
	invokevirtual VC/Parser/Parser/accept()V
.line 740
	aload_0
	invokevirtual VC/Parser/Parser/parseExpr()LVC/ASTs/Expr;
	astore 4
.line 741
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 742
	aload_0
	bipush 30
	invokevirtual VC/Parser/Parser/match(I)V
.line 743
	new VC/ASTs/ArrayExpr
	dup
	aload_3
	aload 4
	aload_1
	invokespecial VC/ASTs/ArrayExpr/<init>(LVC/ASTs/Var;LVC/ASTs/Expr;LVC/Scanner/SourcePosition;)V
	goto Label13
Label14:
.line 745
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 746
	new VC/ASTs/SimpleVar
	dup
	aload_2
	aload_1
	invokespecial VC/ASTs/SimpleVar/<init>(LVC/ASTs/Ident;LVC/Scanner/SourcePosition;)V
	astore_3
.line 747
	new VC/ASTs/VarExpr
	dup
	aload_3
	aload_1
	invokespecial VC/ASTs/VarExpr/<init>(LVC/ASTs/Var;LVC/Scanner/SourcePosition;)V
	goto Label13
Label0:
.line 751
	aload_0
	invokevirtual VC/Parser/Parser/accept()V
.line 752
	aload_0
	invokevirtual VC/Parser/Parser/parseExpr()LVC/ASTs/Expr;
	astore_2
.line 753
	aload_0
	bipush 28
	invokevirtual VC/Parser/Parser/match(I)V
.line 754
	aload_2
	goto Label13
Label7:
.line 757
	aload_0
	invokevirtual VC/Parser/Parser/parseIntLiteral()LVC/ASTs/IntLiteral;
	astore_2
.line 758
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 759
	new VC/ASTs/IntExpr
	dup
	aload_2
	aload_1
	invokespecial VC/ASTs/IntExpr/<init>(LVC/ASTs/IntLiteral;LVC/Scanner/SourcePosition;)V
	goto Label13
Label8:
.line 762
	aload_0
	invokevirtual VC/Parser/Parser/parseFloatLiteral()LVC/ASTs/FloatLiteral;
	astore_2
.line 763
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 764
	new VC/ASTs/FloatExpr
	dup
	aload_2
	aload_1
	invokespecial VC/ASTs/FloatExpr/<init>(LVC/ASTs/FloatLiteral;LVC/Scanner/SourcePosition;)V
	goto Label13
Label9:
.line 767
	aload_0
	invokevirtual VC/Parser/Parser/parseBooleanLiteral()LVC/ASTs/BooleanLiteral;
	astore_2
.line 768
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 769
	new VC/ASTs/BooleanExpr
	dup
	aload_2
	aload_1
	invokespecial VC/ASTs/BooleanExpr/<init>(LVC/ASTs/BooleanLiteral;LVC/Scanner/SourcePosition;)V
	goto Label13
Label10:
.line 772
	aload_0
	invokevirtual VC/Parser/Parser/parseStringLiteral()LVC/ASTs/StringLiteral;
	astore_2
.line 773
	aload_0
	aload_1
	invokevirtual VC/Parser/Parser/finish(LVC/Scanner/SourcePosition;)V
.line 774
	new VC/ASTs/StringExpr
	dup
	aload_2
	aload_1
	invokespecial VC/ASTs/StringExpr/<init>(LVC/ASTs/StringLiteral;LVC/Scanner/SourcePosition;)V
	goto Label13
Label1:
.line 776
	aload_0
	ldc_w "illegal primary expression"
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.spelling Ljava/lang/String;
	invokevirtual VC/Parser/Parser/syntacticError(Ljava/lang/String;Ljava/lang/String;)LVC/Parser/SyntaxError;
	athrow
Label13:
.line 729
	areturn

.throws VC/Parser/SyntaxError
.end method

.method private parseIntLiteral()LVC/ASTs/IntLiteral;
.limit stack 4
.limit locals 2
.var 0 is this LVC/Parser/Parser; from Label1 to Label1

.line 782
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 34
	if_icmpne Label0
.line 783
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.spelling Ljava/lang/String;
	astore_1
.line 784
	aload_0
	invokevirtual VC/Parser/Parser/accept()V
.line 785
	new VC/ASTs/IntLiteral
	dup
	aload_1
	aload_0
	getfield VC.Parser.Parser.previousTokenPosition LVC/Scanner/SourcePosition;
	invokespecial VC/ASTs/IntLiteral/<init>(Ljava/lang/String;LVC/Scanner/SourcePosition;)V
	areturn
Label0:
.line 787
	aload_0
	ldc_w "integer literal expected here"
	ldc_w ""
	invokevirtual VC/Parser/Parser/syntacticError(Ljava/lang/String;Ljava/lang/String;)LVC/Parser/SyntaxError;
Label1:
	athrow

.throws VC/Parser/SyntaxError
.end method

.method private parseFloatLiteral()LVC/ASTs/FloatLiteral;
.limit stack 4
.limit locals 2
.var 0 is this LVC/Parser/Parser; from Label1 to Label1

.line 792
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 35
	if_icmpne Label0
.line 793
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.spelling Ljava/lang/String;
	astore_1
.line 794
	aload_0
	invokevirtual VC/Parser/Parser/accept()V
.line 795
	new VC/ASTs/FloatLiteral
	dup
	aload_1
	aload_0
	getfield VC.Parser.Parser.previousTokenPosition LVC/Scanner/SourcePosition;
	invokespecial VC/ASTs/FloatLiteral/<init>(Ljava/lang/String;LVC/Scanner/SourcePosition;)V
	areturn
Label0:
.line 797
	aload_0
	ldc_w "float literal expected here"
	ldc_w ""
	invokevirtual VC/Parser/Parser/syntacticError(Ljava/lang/String;Ljava/lang/String;)LVC/Parser/SyntaxError;
Label1:
	athrow

.throws VC/Parser/SyntaxError
.end method

.method private parseBooleanLiteral()LVC/ASTs/BooleanLiteral;
.limit stack 4
.limit locals 2
.var 0 is this LVC/Parser/Parser; from Label1 to Label1

.line 802
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 36
	if_icmpne Label0
.line 803
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.spelling Ljava/lang/String;
	astore_1
.line 804
	aload_0
	invokevirtual VC/Parser/Parser/accept()V
.line 805
	new VC/ASTs/BooleanLiteral
	dup
	aload_1
	aload_0
	getfield VC.Parser.Parser.previousTokenPosition LVC/Scanner/SourcePosition;
	invokespecial VC/ASTs/BooleanLiteral/<init>(Ljava/lang/String;LVC/Scanner/SourcePosition;)V
	areturn
Label0:
.line 807
	aload_0
	ldc_w "boolean literal expected here"
	ldc_w ""
	invokevirtual VC/Parser/Parser/syntacticError(Ljava/lang/String;Ljava/lang/String;)LVC/Parser/SyntaxError;
Label1:
	athrow

.throws VC/Parser/SyntaxError
.end method

.method private parseStringLiteral()LVC/ASTs/StringLiteral;
.limit stack 4
.limit locals 2
.var 0 is this LVC/Parser/Parser; from Label1 to Label1

.line 812
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.kind I
	bipush 37
	if_icmpne Label0
.line 813
	aload_0
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.position LVC/Scanner/SourcePosition;
	putfield VC.Parser.Parser.previousTokenPosition LVC/Scanner/SourcePosition;
.line 814
	aload_0
	getfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
	getfield VC.Scanner.Token.spelling Ljava/lang/String;
	astore_1
.line 815
	aload_0
	aload_0
	getfield VC.Parser.Parser.scanner LVC/Scanner/Scanner;
	invokevirtual VC/Scanner/Scanner/getToken()LVC/Scanner/Token;
	putfield VC.Parser.Parser.currentToken LVC/Scanner/Token;
.line 816
	new VC/ASTs/StringLiteral
	dup
	aload_1
	aload_0
	getfield VC.Parser.Parser.previousTokenPosition LVC/Scanner/SourcePosition;
	invokespecial VC/ASTs/StringLiteral/<init>(Ljava/lang/String;LVC/Scanner/SourcePosition;)V
	areturn
Label0:
.line 818
	aload_0
	ldc_w "string literal expected here"
	ldc_w ""
	invokevirtual VC/Parser/Parser/syntacticError(Ljava/lang/String;Ljava/lang/String;)LVC/Parser/SyntaxError;
Label1:
	athrow

.throws VC/Parser/SyntaxError
.end method
