/*
 * Emitter.java
 * 
 * This class handles code generation for the VC compiler, producing
 * JVM bytecode (emitted as Jasmin assembly). It transforms VC's abstract syntax
 * into valid JVM instructions while preserving language semantics.
 *
 * A partial implementation for scalar types is provided, demonstrating:
 * - Field declaration translation
 * - Class initializer (<clinit>) generation
 * - Call expression translation
 * - Function declaration translation
 *
 * The default constructor (<init>) generation is also implemented.
 *
 * The starter code also demonstrates how to use `frame.push()` and `frame.pop()` to calculate 
 * the stack size required by `.limit stack`.
 * 
 *
 * Your implementation Tasks:
 * - All partially visit methods
 * - All unimplemented visit methods
 * - Array-related functionality, including:
 *   - Array field declarations with correct JVM descriptors
 *   - <clinit> generation for static array initialization
 *     (Note: JVM automatically zero-initializes array memory)
 *   - Dynamic array allocation
 *   - Array load/store operations
 *
 * You can examine the tree drawer, unparser, and tree printer, all of which use 
 * the visitor design pattern, to understand how to implement the type checker.
 *
 * Development Options:
 * 1. Extend the existing framework (recommended)
 * 2. Create an independent implementation
 */

package VC.CodeGen;

import VC.ASTs.*;
import VC.ErrorReporter;
import VC.StdEnvironment;

public final class Emitter implements Visitor {

    private ErrorReporter errorReporter;
    private String inputFilename;
    private String classname;
    private String outputFilename;
    
    public Emitter(String inputFilename, ErrorReporter reporter) {
        this.inputFilename = inputFilename;
        errorReporter = reporter;
        
        int i = inputFilename.lastIndexOf('.');
        if (i > 0) {
            classname = inputFilename.substring(0, i);
        } else {
            classname = inputFilename;
		}
        
    }
    
    // ast must be a Program node
    
    public final void gen(AST ast) {
        ast.visit(this, null); 
        JVM.dump(classname + ".j");
    }
        
    // =========================== PROGRAMS ===========================
 
    @Override
    public Object visitProgram(Program ast, Object o) {
    
		/* This method is designed for scalar variables only. 
		 * Additional code is required to handle global array 
		 * declarations and initializations.
		 */


        // Generates the default constructor initialiser 
        emit(JVM.CLASS, "public", classname);
        emit(JVM.SUPER, "java/lang/Object");
    
        emit("");
    
        // Four passes:
    
        // (1) Generate .field definition statements since
        //     these are required to appear before method definitions.
        //
        // This can also be done using a separate visitor.

        ASTList<Decl> list = ast.FL;
        while (!list.isEmpty()) { 
            ASTList<Decl> dlAST = list;
            if (dlAST.getHead() instanceof GlobalVarDecl vAST) {
                if (vAST.T instanceof ArrayType vType) {
                    emit(JVM.STATIC_FIELD, vAST.I.spelling, "[" + VCtoJavaType(vType.T));         
                } else {    
                    emit(JVM.STATIC_FIELD, vAST.I.spelling, VCtoJavaType(vAST.T));                
				}
            }
            list = dlAST.getNext();
        }        

        emit("");
    
        // (2) Generate the class initializer <clinit> for global variables (assumed to be static)
        //
        // This can also be done using a separate visitor.
    
        emit("; standard class static initializer ");
        emit(JVM.METHOD_START, "static <clinit>()V");
        emit("");
    
        // create a Frame for <clinit>
    
	    /* A new frame object is created for every function just before the
		 * function is being translated in visitFuncDecl, with false indicating a non-main function.

		 * All the information about the translation of a function should be
		 * placed in this Frame object and passed across the AST nodes as the
		 * 2nd argument of every visitor method in Emitter.java.
	 	 */

        Frame frame = new Frame(false);
    
        list = ast.FL;
        while (!list.isEmpty()) {
            ASTList<Decl> dlAST = list;
            if (dlAST.getHead() instanceof GlobalVarDecl vAST) {
                if (!vAST.E.isEmptyExpr()) {
                    vAST.E.visit(this, frame);
                } else {
                    if (vAST.T.equals(StdEnvironment.floatType)) {
                        emit(JVM.FCONST_0);
                    } else {
                        emit(JVM.ICONST_0);
					}
                    frame.push();
                }
                emitPUTSTATIC(VCtoJavaType(vAST.T), vAST.I.spelling); 
                frame.pop();
        	}
            list = dlAST.getNext();
        }
    
        emit("");
        emit("; set limits used by this method");
    
        emit(JVM.LIMIT, "locals", frame.getNewIndex());
        emit(JVM.LIMIT, "stack", frame.getMaximumStackSize());
        
        emit(JVM.RETURN);
        emit(JVM.METHOD_END, "method");
    
        emit("");
    
        // (3) Generate the constructor <init>
    
        emit("; standard constructor initializer ");
        emit(JVM.METHOD_START, "public <init>()V");
        emit(JVM.LIMIT, "stack 1");
        emit(JVM.LIMIT, "locals 1");
        emit(JVM.ALOAD_0);
        emit(JVM.INVOKESPECIAL, "java/lang/Object/<init>()V");
        emit(JVM.RETURN);
        emit(JVM.METHOD_END, "method");

        // (4) Generate Java bytecode for the VC program
    
        return ast.FL.visit(this, o);
    }
    
    // =========================== STATEMENTS ===========================
    
    @Override
    public Object visitStmtList(StmtList ast, Object o) {
        ast.getHead().visit(this, o);
        ast.getNext().visit(this, o);
        return null;
    }   
    
    @Override 
    public Object visitCompoundStmt(CompoundStmt ast, Object o) {
        Frame frame = (Frame) o; 

        String scopeStart = frame.getNewLabel();
        String scopeEnd = frame.getNewLabel();
        frame.scopeStart.push(scopeStart);
        frame.scopeEnd.push(scopeEnd);
    
        emit(scopeStart + ":");
        if (ast.parent instanceof FuncDecl aPar) {
            if (aPar.I.spelling.equals("main")) {
                emit(JVM.VAR, "0 is argv [Ljava/lang/String; from " + (String) frame.scopeStart.peek() + " to " +  (String) frame.scopeEnd.peek());
                emit(JVM.VAR, "1 is vc$ L" + classname + "; from " + (String) frame.scopeStart.peek() + " to " +  (String) frame.scopeEnd.peek());
                // Generate code for the initialiser vc$ = new classname();
                emit(JVM.NEW, classname);
                emit(JVM.DUP);
                frame.push(2);
                emit("invokenonvirtual", classname + "/<init>()V");
                frame.pop();
                emit(JVM.ASTORE_1);
                frame.pop();
            } else {
                emit(JVM.VAR, "0 is this L" + classname + "; from " + (String) frame.scopeStart.peek() + " to " +  (String) frame.scopeEnd.peek());
                ((FuncDecl) ast.parent).PL.visit(this, o);
            }
        }
        ast.DL.visit(this, o);
        ast.SL.visit(this, o);
        emit(scopeEnd + ":");

        frame.scopeStart.pop();
        frame.scopeEnd.pop();
        return null;
    }
    
    @Override
    public Object visitReturnStmt(ReturnStmt ast, Object o) {
        Frame frame = (Frame)o;
    
    /*
    int main() { return 0; } must be interpretted as 

    public static void main(String[] args) { return ; }

    Therefore, "return expr", if present in the main of a VC program
    must be translated into a RETURN rather than IRETURN instruction.
    */
    
        if (frame.isMain())  {
            emit(JVM.RETURN);
            return null;
        }
    
    /*  Your other code goes here for handling `return <Expr>'. */ 
            
    }
    
    @Override
    public Object visitEmptyStmtList(EmptyStmtList ast, Object o) {
        return null;
    }
    
    @Override
    public Object visitEmptyCompStmt(EmptyCompStmt ast, Object o) {
        return null;
    }
    
    @Override
    public Object visitEmptyStmt(EmptyStmt ast, Object o) {
        return null;
    }
    
    // =========================== EXPRESSIONS ===========================
    
    @Override
    public Object visitCallExpr(CallExpr ast, Object o) {
        Frame frame = (Frame) o;
        String fname = ast.I.spelling;
    
        if (fname.equals("getInt")) {
        	ast.AL.visit(this, o); // push args (if any) into the op stack
        	emit("invokestatic VC/lang/System/getInt()I");
        	frame.push();
        } else if (fname.equals("putInt")) {
        	ast.AL.visit(this, o); // push args (if any) into the op stack
        	emit("invokestatic VC/lang/System/putInt(I)V");
        	frame.pop();
        } else if (fname.equals("putIntLn")) {
        	ast.AL.visit(this, o); // push args (if any) into the op stack
        	emit("invokestatic VC/lang/System/putIntLn(I)V");
        	frame.pop();
        } else if (fname.equals("getFloat")) {
        	ast.AL.visit(this, o); // push args (if any) into the op stack
        	emit("invokestatic VC/lang/System/getFloat()F");
        	frame.push();
        } else if (fname.equals("putFloat")) {
        	ast.AL.visit(this, o); // push args (if any) into the op stack
        	emit("invokestatic VC/lang/System/putFloat(F)V");
        	frame.pop();
        } else if (fname.equals("putFloatLn")) {
        	ast.AL.visit(this, o); // push args (if any) into the op stack
        	emit("invokestatic VC/lang/System/putFloatLn(F)V");
        	frame.pop();
        } else if (fname.equals("putBool")) {
        	ast.AL.visit(this, o); // push args (if any) into the op stack
        	emit("invokestatic VC/lang/System/putBool(Z)V");
        	frame.pop();
        } else if (fname.equals("putBoolLn")) {
        	ast.AL.visit(this, o); // push args (if any) into the op stack
        	emit("invokestatic VC/lang/System/putBoolLn(Z)V");
        	frame.pop();
        } else if (fname.equals("putString")) {
        	ast.AL.visit(this, o);
        	emit(JVM.INVOKESTATIC, "VC/lang/System/putString(Ljava/lang/String;)V");
        	frame.pop();
        } else if (fname.equals("putStringLn")) {
        	ast.AL.visit(this, o);
        	emit(JVM.INVOKESTATIC, "VC/lang/System/putStringLn(Ljava/lang/String;)V");
        	frame.pop();
        } else if (fname.equals("putLn")) {
        	ast.AL.visit(this, o); // push args (if any) into the op stack
        	emit("invokestatic VC/lang/System/putLn()V");
        } else { // programmer-defined functions
    
        	FuncDecl fAST = (FuncDecl) ast.I.decl;
    
        	// all functions except main are assumed to be instance methods
        	if (frame.isMain()) 
                emit("aload_1"); // vc.funcname(...)
        	else
                emit("aload_0"); // this.funcname(...)
    
            frame.push();
    
        	ast.AL.visit(this, o);
        
        	String retType = VCtoJavaType(fAST.T);
        
        	// The types of the parameters of the called function are not
        	// directly available in the FuncDecl node but can be gathered
        	// by traversing its field PL.
    
        	StringBuilder argsTypes = new StringBuilder("");
        	ASTList<Decl> fpl = fAST.PL;
        	while (!fpl.isEmpty()) {
                if (fpl.getHead().T.equals(StdEnvironment.booleanType)) {
            		argsTypes.append("Z");         
                } else if (fpl.getHead().T.equals(StdEnvironment.intType)) {
            		argsTypes.append("I");         
                } else {
            		argsTypes.append("F");         
				}
                fpl = fpl.getNext();
         	}
        
        	emit("invokevirtual", classname + "/" + fname + "(" + argsTypes + ")" + retType);
        	frame.pop(argsTypes.length() + 1);
    
        	if (! retType.equals("V")) {
                frame.push();
			}
        }
        return null;
    }
    
    @Override
    public Object visitEmptyExpr(EmptyExpr ast, Object o) {
        return null;
    }
    
    @Override
    public Object visitIntExpr(IntExpr ast, Object o) {
        ast.IL.visit(this, o);
        return null;
    }
    
    @Override
    public Object visitFloatExpr(FloatExpr ast, Object o) {
        ast.FL.visit(this, o);
        return null;
    }
    
    @Override
    public Object visitBooleanExpr(BooleanExpr ast, Object o) {
        ast.BL.visit(this, o);
        return null;
    }
    
    @Override
    public Object visitStringExpr(StringExpr ast, Object o) {
        ast.SL.visit(this, o);
        return null;
    }
    
    // =========================== DECLARATIONS ===========================
    
    @Override
    public Object visitDeclList(DeclList ast, Object o) {
        ast.getHead().visit(this, o);
        ast.getNext().visit(this, o);
        return null;
    }
    
    @Override
    public Object visitEmptyDeclList(EmptyDeclList ast, Object o) {
        return null;
    }
    
    @Override
    public Object visitFuncDecl(FuncDecl ast, Object o) {
    
        Frame frame; 
    
        if (ast.I.spelling.equals("main")) {
    
        	frame = new Frame(true);
    
        	// Assume that main has one String parameter and reserve 0 for it
        	frame.getNewIndex(); 
    
        	emit(JVM.METHOD_START, "public static main([Ljava/lang/String;)V"); 
        	// Assume implicitly that
        	//      classname vc$; 
        	// appears before all local variable declarations.
        	// (1) Reserve 1 for this object reference.
    
        	frame.getNewIndex(); 
    
        } else {
    
        	frame = new Frame(false);
    
        	// all other programmer-defined functions are treated as if
        	// they were instance methods
        	frame.getNewIndex(); // reserve 0 for "this"
    
        	String retType = VCtoJavaType(ast.T);
    
        	// The types of the parameters of the called function are not
        	// directly available in the FuncDecl node but can be gathered
        	// by traversing its field PL.
    
        	StringBuilder argsTypes = new StringBuilder("");
        	ASTList<Decl> fpl = ast.PL;
        	while (!fpl.isEmpty()) {
                if (fpl.getHead().T.equals(StdEnvironment.booleanType)) {
            		argsTypes.append("Z");         
                } else if (fpl.getHead().T.equals(StdEnvironment.intType)) {
            		argsTypes.append("I");         
                } else {
            		argsTypes.append("F");         
				}
            fpl = fpl.getNext();
        }
    
        emit(JVM.METHOD_START, ast.I.spelling + "(" + argsTypes + ")" + retType);
        }
    
        ast.S.visit(this, frame);
    
        // JVM requires an explicit return in every method. 
        // In VC, a function returning void may not contain a return, and
        // a function returning int or float is not guaranteed to contain
        // a return. Therefore, we add one at the end just to be sure.
    
        if (ast.T.equals(StdEnvironment.voidType)) {
        	emit("");
        	emit("; return may not be present in a VC function returning void"); 
        	emit("; The following return inserted by the VC compiler");
        	emit(JVM.RETURN); 
        } else if (ast.I.spelling.equals("main")) {
        	// In case VC's main does not have a return itself
        	emit(JVM.RETURN);
        } else {
        	emit(JVM.NOP); 
		}
    
        emit("");
        emit("; set limits used by this method");
    
        emit(JVM.LIMIT, "locals", frame.getNewIndex());
        emit(JVM.LIMIT, "stack", frame.getMaximumStackSize());
    
        emit(".end method");
    
        return null;
    }
    
    @Override
    public Object visitGlobalVarDecl(GlobalVarDecl ast, Object o) {
        // nothing to be done
        return null;
    }
    
    @Override
    public Object visitLocalVarDecl(LocalVarDecl ast, Object o) {
    
        /* You need to add code to handle arrays */
    
        Frame frame = (Frame) o;
        ast.index = frame.getNewIndex();
        String T = VCtoJavaType(ast.T);
    
        emit(JVM.VAR + " " + ast.index + " is " + ast.I.spelling + " " + T + " from " + (String) frame.scopeStart.peek() + " to " +  (String) frame.scopeEnd.peek());
    
        if (!ast.E.isEmptyExpr()) {
        	ast.E.visit(this, o);
    
        	if (ast.T.equals(StdEnvironment.floatType)) {
                emitFSTORE(ast.I);
            } else {
                emitISTORE(ast.I);
        	}
        frame.pop();
        }
    
        return null;
    }
    
    // =========================== PARAMETERS ===========================
    
    @Override
    public Object visitParaList(ParaList ast, Object o) {

		// Fill the rest

        return null;
    }
    
    @Override
    public Object visitParaDecl(ParaDecl ast, Object o) {
    
        /* You need to add code to handle arrays */
    
        Frame frame = (Frame) o;
        ast.index = frame.getNewIndex();
        String T = VCtoJavaType(ast.T);
    
        emit(JVM.VAR + " " + ast.index + " is " + ast.I.spelling + " " + T + " from " + (String) frame.scopeStart.peek() + " to " +  (String) frame.scopeEnd.peek());
        return null;
    }
    
    @Override
    public Object visitEmptyParaList(EmptyParaList ast, Object o) {
        return null;
    }
    
    // ============================== ARGUMENTS =================================
    
    @Override
    public Object visitArgList(ArgList ast, Object o) {

		// Fill the rest

        return null;
    }
    
    @Override
    public Object visitArg(Arg ast, Object o) {
        ast.E.visit(this, o);
        return null;
    }
    
    @Override
    public Object visitEmptyArgList(EmptyArgList ast, Object o) {
        return null;
    }
    
    // =========================== TYPES ===========================
    
    @Override
    public Object visitIntType(IntType ast, Object o) {
        return null;
    }
    
    @Override
    public Object visitFloatType(FloatType ast, Object o) {
        return null;
    }
    
    @Override
    public Object visitBooleanType(BooleanType ast, Object o) {
        return null;
    }
    
    @Override
    public Object visitVoidType(VoidType ast, Object o) {
        return null;
    }
    
    @Override
    public Object visitErrorType(ErrorType ast, Object o) {
        return null;
    }
    
    // =========================== LITERALS, IDENTIFIERS AND OPERATORS ===========================
    
    @Override
    public Object visitIdent(Ident ast, Object o) {
        return null;
    }
    
    @Override
    public Object visitIntLiteral(IntLiteral ast, Object o) {
        Frame frame = (Frame) o;
        emitICONST(Integer.parseInt(ast.spelling));
        frame.push();
        return null;
    }
    
    @Override
    public Object visitFloatLiteral(FloatLiteral ast, Object o) {
        Frame frame = (Frame) o;
        emitFCONST(Float.parseFloat(ast.spelling));
        frame.push();
        return null;
    }
    
    @Override
    public Object visitBooleanLiteral(BooleanLiteral ast, Object o) {
        Frame frame = (Frame) o;
        emitBCONST(ast.spelling.equals("true"));
        frame.push();
        return null;
    }
    
    @Override
    public Object visitStringLiteral(StringLiteral ast, Object o) {
        Frame frame = (Frame) o;
        emit(JVM.LDC, "\"" + ast.spelling.replace("\"","\\\"") + "\"");
        frame.push();
        return null;
    }
    
    @Override
    public Object visitOperator(Operator ast, Object o) {
        return null;
    }
    
    // =========================== VARIABLES ===========================
    
    @Override
    public Object visitSimpleVar(SimpleVar ast, Object o) {
        return null;
    }
    
    // =========================== AUXILIARY METHODS ===========================
    
    // The following method appends an instruction directly into the JVM 
    // Code Store. It is called by all other overloaded emit methods.
    
    private void emit(String s) {
        JVM.append(new Instruction(s)); 
    }
    
    private void emit(String s1, String s2) {
        emit(s1 + " " + s2);
    }
    
    private void emit(String s1, int i) {
        emit(s1 + " " + i);
    }
    
    private void emit(String s1, float f) {
        emit(s1 + " " + f);
    }
    
    private void emit(String s1, String s2, int i) {
        emit(s1 + " " + s2 + " " + i);
    }
    
    private void emit(String s1, String s2, String s3) {
        emit(s1 + " " + s2 + " " + s3);
    }
    
	private void emitIF_ICMPCOND(String op, Frame frame) {
    	String opcode = switch (op) {
        	case "i!=" -> JVM.IF_ICMPNE;
        	case "i==" -> JVM.IF_ICMPEQ;
        	case "i<"   -> JVM.IF_ICMPLT;
        	case "i<="  -> JVM.IF_ICMPLE;
        	case "i>"   -> JVM.IF_ICMPGT;
        	case "i>="  -> JVM.IF_ICMPGE;
        	default -> throw new IllegalArgumentException("Unsupported comparison operator: " + op);
    	};

    	String trueLabel = frame.getNewLabel();
    	String nextLabel = frame.getNewLabel();

    	emit(opcode, trueLabel);
    	frame.pop(2);
    	emit("iconst_0");
    	emit("goto", nextLabel);
    	emit(trueLabel + ":");
    	emit(JVM.ICONST_1);
    	frame.push();
    	emit(nextLabel + ":");
	}

	private void emitFCMP(String op, Frame frame) {
    // Use switch expression for cleaner opcode mapping
    	String opcode = switch (op) {
	        case "f!=" -> JVM.IFNE;
	        case "f==" -> JVM.IFEQ;
	        case "f<"  -> JVM.IFLT;
	        case "f<=" -> JVM.IFLE;
	        case "f>"  -> JVM.IFGT;
	        case "f>=" -> JVM.IFGE;
	        default -> throw new IllegalArgumentException("Invalid float comparison operator: " + op);
	    };
	
	    // Generate labels
	    String trueLabel = frame.getNewLabel();
	    String nextLabel = frame.getNewLabel();
	
	    // Emit comparison sequence
	    emit(JVM.FCMPG);
	    frame.pop(2);
	    emit(opcode, trueLabel);
	    emit(JVM.ICONST_0);
	    emit("goto", nextLabel);
	    emit(trueLabel + ":");
	    emit(JVM.ICONST_1);
	    frame.push();
	    emit(nextLabel + ":");
    }

	private void emitILOAD(Ident ast) {
    	int index = ast.decl instanceof ParaDecl
        	? ((ParaDecl) ast.decl).index
        	: ((LocalVarDecl) ast.decl).index;

    	emit((index >= 0 && index <= 3)
        	? JVM.ILOAD + "_" + index
        	: JVM.ILOAD + " " + index);
	}

	private void emitFLOAD(Ident ast) {
    	int index = ast.decl instanceof ParaDecl
        	? ((ParaDecl) ast.decl).index
        	: ((LocalVarDecl) ast.decl).index;

    	if (index >= 0 && index <= 3) {
        	emit(JVM.FLOAD + "_" + index);
    	} else {
        	emit(JVM.FLOAD, index);
    	}
	}

    private void emitPUTSTATIC(String T, String I) {
        emit(JVM.PUTSTATIC, classname + "/" + I, T); 
    }

    private void emitGETSTATIC(String T, String I) {
        emit(JVM.GETSTATIC, classname + "/" + I, T); 
    }

	private void emitISTORE(Ident ast) {
    	int index = ast.decl instanceof ParaDecl para ? para.index : ((LocalVarDecl) ast.decl).index;
    	emit(index >= 0 && index <= 3 ? JVM.ISTORE + "_" + index : JVM.ISTORE + " " + index);
	}

    private void emitFSTORE(Ident ast) {
    	int index = ast.decl instanceof ParaDecl p ? p.index : ((LocalVarDecl) ast.decl).index;
    	emit(index <= 3 && index >= 0 ? JVM.FSTORE + "_" + index : JVM.FSTORE + " " + index);
	}

    private void emitICONST(int value) {
    	String instruction;
    	if (value == -1) {
        	instruction = JVM.ICONST_M1;
    	} else if (value >= 0 && value <= 5) {
        	instruction = JVM.ICONST + "_" + value;
    	} else if (value >= -128 && value <= 127) {
        	instruction = JVM.BIPUSH + " " + value;
    	} else if (value >= -32768 && value <= 32767) {
        	instruction = JVM.SIPUSH + " " + value;
    	} else {
        	instruction = JVM.LDC + " " + value;
    	}
    	emit(instruction);
	}

    private void emitFCONST(float value) {
        if(value == 0.0) {
            emit(JVM.FCONST_0); 
		} else if(value == 1.0) {
            emit(JVM.FCONST_1); 
		} else if(value == 2.0) {
            emit(JVM.FCONST_2); 
		} else  {
            emit(JVM.LDC, value); 
		}
    }

    private void emitBCONST(boolean value) {
    	emit(value ? JVM.ICONST_1 : JVM.ICONST_0);
	}
 
	private void emitALoadOrStore(String opcode, int index) {
    	String instruction = (index >= 0 && index <= 3)
        	? opcode + "_" + index
        	: opcode + " " + index;
    	emit(instruction);
	}

	private void emitALOAD(int index) {
    	emitALoadOrStore(JVM.ALOAD, index);
	}

	private void emitASTORE(int index) {
    	emitALoadOrStore(JVM.ASTORE, index);
	}
    
    // Can be used to obtain the type information for the newarray instruction
    // e.g., emit(JVM.NEWARRAY, VCtoJavaTypeForArray(array.T));

    private String VCtoJavaTypeForArray(Type t) {
    	if (t instanceof BooleanType) {
        	return "boolean";
    	} else if (t instanceof IntType) {
        	return "int";
    	} else if (t instanceof FloatType) {
        	return "float";
    	}
    	throw new IllegalArgumentException("Unsupported array type: " + t.getClass().getSimpleName());
	}

	// Converts VC primitive types to Java type descriptors
	
	private String VCtoJavaType(Type t) {
    	if (t.equals(StdEnvironment.booleanType)) {
        	return "Z";
    	}
    	if (t.equals(StdEnvironment.intType)) {
        	return "I";
    	}
    	if (t.equals(StdEnvironment.floatType)) {
        	return "F";
    	}
    	if (t.equals(StdEnvironment.voidType)) {
        	return "V";
    	}
    	throw new IllegalArgumentException("Unsupported type: " + t);
	}

}
