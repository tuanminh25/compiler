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
        
    public void debug() {
        System.out.println("debug");
    }

    public void debug(String s) {
        System.out.println("just print: " + s);
    }

    public void debug(int i) {
        System.out.println("int: " + i);
    }

    public void debugFrame(Frame frame, int i) {
        System.out.println("==== debugFrame  ====");

        if (frame.getCurStackSize() > i) {
            System.out.println("stack larger than expected: " + frame.getCurStackSize() + " " + i);
        } else if (frame.getCurStackSize() < i) {
            System.out.println("stack smaller than expected: " + frame.getCurStackSize() + " " + i);
        } else {
            System.out.println("stack equal to expected: " + frame.getCurStackSize() + " " + i);
        }

        System.out.println("==== debugFrame  ====");

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
                    if (vAST.T instanceof ArrayType arrayType) {
                        arrayType.E.visit(this, frame);  
                        frame.pop();

                        emit(JVM.NEWARRAY, VCtoJavaTypeForArray(arrayType.T));
                        frame.push();

                        vAST.E.visit(this, frame);
                        emitPUTSTATIC(arrayType.toString(), vAST.I.spelling);
                        frame.pop();

                    } else {
                        vAST.E.visit(this, frame);
                        
                        
                        if (vAST.T.isFloatType() && vAST.E.type.isIntType()) {
                            emit(JVM.I2F);
                        }

                        emitPUTSTATIC(VCtoJavaType(vAST.T), vAST.I.spelling); 
                        frame.pop();
                    }
                } else {
                    if (vAST.T instanceof ArrayType arrayType) {
                        // Create array 
                        // Size handling 
                        arrayType.E.visit(this, frame);  // assuming that visitArray will handle logic
                        emit(JVM.NEWARRAY, VCtoJavaTypeForArray(arrayType.T));
                        frame.pop();

                        // Ref handling
                        frame.push();
                        emitPUTSTATIC(arrayType.toString(), vAST.I.spelling);
                        frame.pop();
                    } else {
                        // Create scalar and push to stack 
                        if (vAST.T.equals(StdEnvironment.floatType)) {
                            emit(JVM.FCONST_0);
                        } else {
                            emit(JVM.ICONST_0);
                        }
                        frame.push();

                        // Consume the stack - put static write the last line to .j
                        emitPUTSTATIC(VCtoJavaType(vAST.T), vAST.I.spelling); 
                        frame.pop();
                    }
                }
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

    // visit condition E       → stack +1 (boolean value)
    // ifeq elseLabel          → stack -1 (branch consumes it)
    // visit thenStmt S1       → net 0 (statements are self-contained)
    // goto nextLabel
    // elseLabel:
    // visit elseStmt S2       → net 0
    // nextLabel:
    @Override
    public Object visitIfStmt(IfStmt ast, Object o) {
        Frame frame = (Frame) o;


        String elseLabel = frame.getNewLabel();
        String nextLabel = frame.getNewLabel();

        ast.E.visit(this, o); // stack = +1
        emit(JVM.IFEQ, elseLabel); // if false, jump to else 
        frame.pop(); // stack -1 -> stack = 0 here




        ast.S1.visit(this, o);          
        emit(JVM.GOTO, nextLabel);      


        emit(elseLabel + ":");
        ast.S2.visit(this, o);          
        emit(nextLabel + ":");


        return null;
    }

    // loopLabel:
    // ; evaluate condition
    // ifeq exitLabel    ← if false, exit
    // ; body
    // goto loopLabel    ← loop back
    // exitLabel:
    @Override
    public Object visitWhileStmt(WhileStmt ast, Object o) {
        Frame frame = (Frame) o;

        String loopLabel = frame.getNewLabel();
        String exitLabel = frame.getNewLabel();

        frame.conStack.push(loopLabel);   // continue → jump back to condition
        frame.brkStack.push(exitLabel);   // break → jump to exit
        
        emit(loopLabel + ":");
        ast.E.visit(this, o);             // condition → stack +1
        emit(JVM.IFEQ, exitLabel);        // if false, exit → stack -1
        frame.pop();
        
        ast.S.visit(this, o);          

        emit(JVM.GOTO, loopLabel);        // loop back
        emit(exitLabel + ":");
    
        frame.conStack.pop();
        frame.brkStack.pop();

        return null;
    }

    // ; E1 (init)
    // loopLabel:
    // ; E2 (condition) → if false, exit
    // ifeq exitLabel
    // ; body S
    // continueLabel:        ← continue jumps here (before E3)
    // ; E3 (update)
    // goto loopLabel
    // exitLabel:
    @Override
    public Object visitForStmt(ForStmt ast, Object o) {
        Frame frame = (Frame) o;

        String loopLabel     = frame.getNewLabel();
        String exitLabel     = frame.getNewLabel();
        String continueLabel = frame.getNewLabel();

        frame.conStack.push(continueLabel);
        frame.brkStack.push(exitLabel);

        // E1: init (may be EmptyExpr)
        if (!ast.E1.isEmptyExpr()) {
            ast.E1.visit(this, o);
            frame.pop();
        }

        emit(loopLabel + ":");

        // E2: condition (may be EmptyExpr → infinite loop)
        if (!ast.E2.isEmptyExpr()) {
            ast.E2.visit(this, o);
            emit(JVM.IFEQ, exitLabel);
            frame.pop();
        }

        ast.S.visit(this, o);           // body

        emit(continueLabel + ":");

        // E3: update (may be EmptyExpr)
        if (!ast.E3.isEmptyExpr()) {
            ast.E3.visit(this, o);
            frame.pop();
        }

        emit(JVM.GOTO, loopLabel);
        emit(exitLabel + ":");

        frame.conStack.pop();
        frame.brkStack.pop();

        return null;
    }

    @Override
    public Object visitBreakStmt(BreakStmt ast, Object o) {
        Frame frame = (Frame) o;
        emit(JVM.GOTO, frame.brkStack.peek());
        return null;
    }
    @Override
    public Object visitContinueStmt(ContinueStmt ast, Object o) {
        Frame frame = (Frame) o;
        emit(JVM.GOTO, frame.conStack.peek());
        return null;
    }

    // Net stack = 0
    @Override
    public Object visitExprStmt(ExprStmt ast, Object o) {
        Frame frame = (Frame) o;
        ast.E.visit(this, o);

        // Pop out for case of void like x + 1;
        if (!ast.E.type.equals(StdEnvironment.voidType) && !(ast.E instanceof EmptyExpr)) {
            frame.pop();
        }

        return null;
    }   
    
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
        // debugFrame(frame, 0);
        return null;
    }
    
    // net stack = 0
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

        // If empty then can just return it    
        if (ast.E.isEmptyExpr()) {
            emit(JVM.RETURN);
            return null;   
        }

        ast.E.visit(this, o);

        // Emit based on according type
        if (ast.E.type.isFloatType()) {
            emit(JVM.FRETURN);
        } else {
            emit(JVM.IRETURN);   // int and boolean both use ireturn
        }
        // in this spec, we are not returning a whole array yet

        // Pop out the frame 
        frame.pop();
        return null;
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
    public Object visitUnaryExpr(UnaryExpr ast, Object o) {
        Frame frame = (Frame) o;

        // Visit the child expr first
        ast.E.visit(this, o); // stack + 1
        
        if (ast.O.spelling.equals("-") || ast.O.spelling.equals("i-") || ast.O.spelling.equals("f-")) {
            if (ast.O.spelling.equals("f-") || ast.E.type.equals(StdEnvironment.floatType)) {
                emit(JVM.FNEG);
            } else {
                emit(JVM.INEG);
            }
        }
                
        else if (ast.O.spelling.equals("!") || ast.O.spelling.equals("i!")) {
            emit(JVM.ICONST_1);
            frame.push();
            emit(JVM.IXOR);
            frame.pop();
        }
        frame.pop();
        frame.push();
        return null;
    }

    private Object visitBinaryExprShortCircuit(BinaryExpr ast, Object o) {
        Frame frame = (Frame) o;
        String falseLabel = frame.getNewLabel();
        String nextLabel  = frame.getNewLabel();

        ast.E1.visit(this, o);

        if (ast.O.spelling.equals("&&")) {
            emit(JVM.IFEQ, falseLabel);
            frame.pop();   
            ast.E2.visit(this, o);
            emit(JVM.GOTO, nextLabel);
            emit(falseLabel + ":");
            emit(JVM.ICONST_0); 
            emit(nextLabel + ":");
        } else {
            emit(JVM.IFNE, falseLabel);
            frame.pop();
            ast.E2.visit(this, o); 
            emit(JVM.GOTO, nextLabel);
            emit(falseLabel + ":");
            emit(JVM.ICONST_1);
            emit(nextLabel + ":");
        }
        return null;
    }

    @Override
    public Object visitBinaryExpr(BinaryExpr ast, Object o) {
        Frame frame = (Frame) o;
        // Dealing with special case 
        if (ast.O.spelling.equals("||") || ast.O.spelling.equals("&&")) {
            return visitBinaryExprShortCircuit(ast, o);
        } 
        

        boolean isFloat = true; // default not be float 
        if (ast.E1 != null && ast.E2 != null && ast.E1.type != null && ast.E2.type != null )  {
            isFloat = ast.E1.type.equals(StdEnvironment.floatType) || ast.E2.type.equals(StdEnvironment.floatType);
        } 

        // Visit the first child expr first
        ast.E1.visit(this, o);
        if (isFloat) {
            if (!ast.E1.isEmptyExpr()) {
                if (ast.E1.type == null || ast.E1.type.isIntType()) {
                    emit(JVM.I2F);
                }
            }
        }

        ast.E2.visit(this, o);
        if (isFloat) {
            if (!ast.E2.isEmptyExpr()) {
                if (ast.E2.type == null || ast.E2.type.isIntType()) {
                    emit(JVM.I2F);
                }
            }
        }


        if (ast.O.spelling.equals("i+") || ast.O.spelling.equals("f+") ||
                (ast.O.spelling.equals("+") && !isFloat)) { emit(JVM.IADD); }
        else if (ast.O.spelling.equals("+")) { emit(JVM.FADD); }

        else if (ast.O.spelling.equals("i-") || ast.O.spelling.equals("f-") ||
                (ast.O.spelling.equals("-") && !isFloat)) { emit(JVM.ISUB); }
        else if (ast.O.spelling.equals("-")) { emit(JVM.FSUB); }

        else if (ast.O.spelling.equals("i*") || ast.O.spelling.equals("f*") ||
                (ast.O.spelling.equals("*") && !isFloat)) { emit(JVM.IMUL); }
        else if (ast.O.spelling.equals("*")) { emit(JVM.FMUL); }

        else if (ast.O.spelling.equals("i/") || ast.O.spelling.equals("f/") ||
                (ast.O.spelling.equals("/") && !isFloat)) { emit(JVM.IDIV); }
        else if (ast.O.spelling.equals("/")) { emit(JVM.FDIV); }

        else if (
            ast.O.spelling.equals("i==") || ast.O.spelling.equals("f==") ||
            ast.O.spelling.equals("i!=") || ast.O.spelling.equals("f!=") ||
            ast.O.spelling.equals("i<")  || ast.O.spelling.equals("f<")  ||
            ast.O.spelling.equals("i<=") || ast.O.spelling.equals("f<=") ||
            ast.O.spelling.equals("i>")  || ast.O.spelling.equals("f>")  ||
            ast.O.spelling.equals("i>=") || ast.O.spelling.equals("f>=") ||
            ast.O.spelling.equals("==")  || ast.O.spelling.equals("!=")  ||
            ast.O.spelling.equals("<")   || ast.O.spelling.equals("<=")  ||
            ast.O.spelling.equals(">")   || ast.O.spelling.equals(">=")
        ) {
            if (ast.O.spelling.startsWith("f") || isFloat) {
                emitFCMP(ast.O.spelling, frame);
            } else {
                emitIF_ICMPCOND(ast.O.spelling, frame);
            }
            return null;
        }
                
        // pop out child 1 
        // pop out child 2
        // pushed in result 
        frame.pop(); 
        frame.pop();
        frame.push(); 
        
        return null;
    }

    @Override
    public Object visitEmptyArrayExprList(EmptyArrayExprList ast, Object o) {
        return null;
    }

    @Override
    public Object visitArrayInitExpr(ArrayInitExpr ast, Object o) {
        emitArrayInit(ast.IL, (Frame) o, 0);   // start at index 0
        return null;
    }

    private void emitArrayInit(ASTList<Expr> list, Frame frame, int index) {
        if (list instanceof EmptyArrayExprList) return;
        ArrayExprList node = (ArrayExprList) list;

        emit(JVM.DUP);             frame.push();
        emitICONST(index);         frame.push();   
        node.getHead().visit(this, frame);

        if (node.getHead().type.isFloatType())        emit(JVM.FASTORE);
        else if (node.getHead().type.isBooleanType()) emit(JVM.BASTORE);
        else                                           emit(JVM.IASTORE);
        frame.pop(3);

        emitArrayInit(node.getNext(), frame, index + 1); 
    }

    @Override
    public Object visitArrayExprList(ArrayExprList ast, Object o) {
        // Because internal structure does not hold actual value of index
        // So we resort to own private custom and no longer use this 
        return null;
    }


    // stack = + 1
    // load array ref -> ref 
    // load array index -> ref | index 
    // call aload to ship the package and put in only the result of retrival 
    @Override
    public Object visitArrayExpr(ArrayExpr ast, Object o) {
        Frame frame = (Frame) o;
        ast.V.visit(this, o);   // visitSimpleVar handles global vs local/para internally -> stack + 1 = 1
        ast.E.visit(this, o);   // pushes index -> stack + 1 = 2
        if (ast.type.isFloatType()) {
            emit(JVM.FALOAD);
        } else if (ast.type.isBooleanType()) {
            emit(JVM.BALOAD);
        } else {
            emit(JVM.IALOAD);
        }
        frame.pop(2);  // stack -2 = 0
        frame.push(); // stack + 1 = 1
        return null;
    }

    @Override
    public Object visitVarExpr(VarExpr ast, Object o) {
        ast.V.visit(this, o);
        return null; 
    }

    // Net stack = + 1
    @Override
    public Object visitAssignExpr(AssignExpr ast, Object o) {
        Frame frame = (Frame) o;
        if (ast.E1 instanceof VarExpr veAST) {

            SimpleVar sv = (SimpleVar) veAST.V; // stack frame + 1
            ast.E2.visit(this, o); // stack + 1
            
            Decl decl = (Decl) sv.I.decl;

            if (decl instanceof GlobalVarDecl gAST) {
                if (gAST.T instanceof ArrayType at) {
                    emitPUTSTATIC(at.toString(), sv.I.spelling);
                } else if (decl.T.isFloatType()) {

                    if (!ast.E2.isEmptyExpr()) {
                        if (ast.E2.type == null || ast.E2.type.isIntType()) {
                            emit(JVM.I2F);
                        }
                    }
                    
                    emitPUTSTATIC(VCtoJavaType(gAST.T), sv.I.spelling);

                } else {
                    emitPUTSTATIC(VCtoJavaType(gAST.T), sv.I.spelling);
                }
            } else {
                if (decl.T instanceof ArrayType) {
                    emitASTORE(decl.index);
                } else if (decl.T.isFloatType()) {

                    if (!ast.E2.isEmptyExpr()) {
                        if (ast.E2.type == null || ast.E2.type.isIntType()) {
                            emit(JVM.I2F);
                        }
                    }

                    emitFSTORE(sv.I);
                } else {
                    // debug(ast.E2.type.toString());
                    emitISTORE(sv.I);
                }
            }

        } else {
            // visit the rhs and load all instructions there and let them do their work
            // until it is eval 
            // just call astore or something equivalent
            // like putstatic for global decl and then astore for local

            ArrayExpr aeAST = (ArrayExpr) ast.E1;
            SimpleVar sv = (SimpleVar) aeAST.V;
            
            sv.visit(this, o);   // stack + 1 = 1

            aeAST.E.visit(this, o);  // load index : stack + 1 = 2

            ast.E2.visit(this, o); // load rhs : stack + 1 = 3

            // emit(JVM.DUP_X2); // call this copy for this representation: [value, arrayref, index, value]
            // // so that the value can be reused in the case of a[3] = b[5] = c[d];
            // frame.push();

            if (aeAST.type.isFloatType()) {
                
                if (!ast.E2.isEmptyExpr()) {
                    if (ast.E2.type == null || ast.E2.type.isIntType()) {
                        emit(JVM.I2F);
                    }
                }

                emit(JVM.FASTORE);
            } else if (aeAST.type.isBooleanType()) {
                emit(JVM.BASTORE);
            } else {
                emit(JVM.IASTORE);
            }
            frame.pop(2); 
        }
        return null;
    }

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
            int numArgs = 0;
        	while (!fpl.isEmpty()) {
                numArgs++;
                if (fpl.getHead().T.equals(StdEnvironment.booleanType)) {
            		argsTypes.append("Z");         
                } else if (fpl.getHead().T.equals(StdEnvironment.intType)) {
            		argsTypes.append("I");         
                } else if (fpl.getHead().T.equals(StdEnvironment.floatType)){
            		argsTypes.append("F");         
				} else {
                    // Array type
                    argsTypes.append(fpl.getHead().T.toString());
                }
                fpl = fpl.getNext();
         	}
        
        	emit("invokevirtual", classname + "/" + fname + "(" + argsTypes + ")" + retType);
            frame.pop(numArgs + 1);
        	if (! retType.equals("V")) {
                frame.push();
			}
        }
        // debugFrame(frame, 1);
        return null;
    }
    
    @Override
    public Object visitEmptyExpr(EmptyExpr ast, Object o) {
        Frame frame = (Frame) o;
        return null;
    }
    
    @Override
    public Object visitIntExpr(IntExpr ast, Object o) {
        Frame frame = (Frame) o;
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
                    } else if (fpl.getHead().T.equals(StdEnvironment.floatType)){
                        argsTypes.append("F");         
                    } else {
                        // Array type
                        argsTypes.append(fpl.getHead().T.toString());
                    }
                fpl = fpl.getNext();
            }
    
            emit(JVM.METHOD_START, ast.I.spelling + "(" + argsTypes + ")" + retType);
            // ast.PL.visit(this, frame);
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
        Frame frame = (Frame) o;
        ast.index = frame.getNewIndex();

        String T;
        if (ast.T instanceof ArrayType arrayType) {
            T = arrayType.toString();   // "[I", "[F", "[Z"
        } else {
            T = VCtoJavaType(ast.T);
        }

        emit(JVM.VAR + " " + ast.index + " is " + ast.I.spelling + " " + T + " from " + (String) frame.scopeStart.peek() + " to " + (String) frame.scopeEnd.peek());

        if (!ast.E.isEmptyExpr()) {
            if (ast.T instanceof ArrayType arrayType) {
                // int a[3] = {1,2,3} — init with array literal
                arrayType.E.visit(this, o);                        // push size
                frame.pop();
                emit(JVM.NEWARRAY, VCtoJavaTypeForArray(arrayType.T));
                frame.push();
                ast.E.visit(this, o);                              // visitArrayInitExpr → fills elements
                emitASTORE(ast.index);
                frame.pop();
            } else if (ast.T.equals(StdEnvironment.floatType)) {
                ast.E.visit(this, o);
                if (ast.E.type == null || ast.E.type.isIntType() ) {
                    emit(JVM.I2F);
                }
                emitFSTORE(ast.I);
                frame.pop();
            } else {
                ast.E.visit(this, o);
                emitISTORE(ast.I);
                frame.pop();
            }
        } else {
            if (ast.T instanceof ArrayType arrayType) {
                // int a[3] — no init, just allocate
                arrayType.E.visit(this, o);                        // push size
                frame.pop();
                emit(JVM.NEWARRAY, VCtoJavaTypeForArray(arrayType.T));
                frame.push();
                emitASTORE(ast.index);
                frame.pop();
            }
            // scalar with no init: nothing needed, JVM zero-initialises slots
        }

        return null;
    }
        
    // =========================== PARAMETERS ===========================
    
    @Override
    public Object visitParaList(ParaList ast, Object o) {
        ast.getHead().visit(this, o);
        ast.getNext().visit(this, o);
        return null;
    }
    
    @Override
    public Object visitParaDecl(ParaDecl ast, Object o) {
        Frame frame = (Frame) o;
        ast.index = frame.getNewIndex();

        String T;
        if (ast.T instanceof ArrayType arrayType) {
            T = arrayType.toString();   // → "[I", "[F", "[Z"
        } else {
            T = VCtoJavaType(ast.T);    // → "I", "F", "Z"
        }

        emit(JVM.VAR + " " + ast.index + " is " + ast.I.spelling + " " + T + " from " + (String) frame.scopeStart.peek() + " to " + (String) frame.scopeEnd.peek());
        return null;
    }
    
    @Override
    public Object visitEmptyParaList(EmptyParaList ast, Object o) {
        return null;
    }
    
    // ============================== ARGUMENTS =================================
    
    @Override
    public Object visitArgList(ArgList ast, Object o) {
        ast.getHead().visit(this, o);
        ast.getNext().visit(this, o);
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
    public Object visitStringType(StringType ast, Object o) {
        return null;
    }

    @Override
    public Object visitArrayType(ArrayType ast, Object o) {
        return null;
    }

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
        // debug(Integer.parseInt(ast.spelling));
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
    

    // Stack frame + 1
    @Override
    public Object visitSimpleVar(SimpleVar ast, Object o) {
        Frame frame = (Frame) o;
        String iSpelling = ast.I.spelling;

        if (ast.I.decl instanceof GlobalVarDecl gAST) {
            if (gAST.T instanceof ArrayType arrayType) {
                emitGETSTATIC(arrayType.toString(), iSpelling);
            } else {
                emitGETSTATIC(VCtoJavaType(gAST.T), iSpelling);
            }
        } else if (ast.I.decl instanceof LocalVarDecl lAST) {
            if (lAST.T instanceof ArrayType) {
                emitALOAD(lAST.index);
            } else if (lAST.T.equals(StdEnvironment.floatType)) {
                emitFLOAD(lAST.I);
            } else {
                emitILOAD(lAST.I);   // int and boolean
            }
        } else {
            ParaDecl pAST = (ParaDecl) ast.I.decl;
            if (pAST.T instanceof ArrayType) {
                emitALOAD(pAST.index);
            } else if (pAST.T.equals(StdEnvironment.floatType)) {
                emitFLOAD(pAST.I);
            } else {
                emitILOAD(pAST.I);
            }
        }
        frame.push();
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
            case "i!=", "!=" -> JVM.IF_ICMPNE;
            case "i==", "==" -> JVM.IF_ICMPEQ;
            case "i<",  "<"  -> JVM.IF_ICMPLT;
            case "i<=", "<=" -> JVM.IF_ICMPLE;
            case "i>",  ">"  -> JVM.IF_ICMPGT;
            case "i>=", ">=" -> JVM.IF_ICMPGE;
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
	        case "f!=", "!=" -> JVM.IFNE;
	        case "f==", "==" -> JVM.IFEQ;
	        case "f<",  "<"  -> JVM.IFLT;
	        case "f<=", "<=" -> JVM.IFLE;
	        case "f>",  ">"  -> JVM.IFGT;
	        case "f>=", ">=" -> JVM.IFGE;
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
