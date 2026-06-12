/*
 * Parser.java 
 *
 * Tue 03 Mar 2026 14:04:48 AEDT
 *
 * PLEASE COMPARE Recogniser.java PROVIDED IN ASSIGNMENT 2 AND Parser.java
 * PROVIDED BELOW TO UNDERSTAND HOW THE FORMER IS MODIFIED TO OBTAIN THE LATTER.
 *
 * This parser for a subset of the VC language is intended to 
 *  demonstrate how to create the AST nodes, including (among others): 
 *  (1) a list (of statements)
 *  (2) a function
 *  (3) a statement (which is an expression statement), 
 *  (4) a unary expression
 *  (5) a binary expression
 *  (6) terminals (identifiers, integer literals and operators)
 *
 * In addition, it also demonstrates how to use the two methods start 
 * and finish to determine the position information for the start and 
 * end of a construct (known as a phrase) corresponding an AST node.
 *
 * NOTE THAT THE POSITION INFORMATION WILL NOT BE MARKED. HOWEVER, IT CAN BE
 * USEFUL TO DEBUG YOUR IMPLEMENTATION.
 *
 * Note that what is provided below is an implementation for a subset of VC
 * given below rather than VC itself. It provides a good starting point for you
 * to implement a parser for VC yourself, by modifying the parsing methods
 * provided (whenever necessary).
 *
 *
 * Alternatively, you are free to disregard the starter code entirely and 
 * develop your own solution, as long as it adheres to the same public 
 * interface.


program       -> func-decl
func-decl     -> type identifier "(" ")" compound-stmt
type          -> void
identifier    -> ID
// statements
compound-stmt -> "{" stmt* "}" 
stmt          -> expr-stmt
expr-stmt     -> expr? ";"
// expressions 
expr                -> additive-expr
additive-expr       -> multiplicative-expr
                    |  additive-expr "+" multiplicative-expr
                    |  additive-expr "-" multiplicative-expr
multiplicative-expr -> unary-expr
	            |  multiplicative-expr "*" unary-expr
	            |  multiplicative-expr "/" unary-expr
unary-expr          -> "-" unary-expr
		    |  primary-expr

primary-expr        -> identifier
 		    |  INTLITERAL
		    | "(" expr ")"
 */

package VC.Parser;

import VC.Scanner.Scanner;
import VC.Scanner.SourcePosition;
import VC.Scanner.Token;
import VC.ErrorReporter;
import VC.ASTs.*;

public class Parser {
	private boolean GLOBAL_VARIABLE = true;
	private boolean LOCAL_VARIABLE = false;

    private Scanner scanner;
    private ErrorReporter errorReporter;
    private Token currentToken;
    private SourcePosition previousTokenPosition;
    private SourcePosition dummyPos = new SourcePosition();

    public Parser (Scanner lexer, ErrorReporter reporter) {		
    	scanner = lexer;
    	errorReporter = reporter;

    	previousTokenPosition = new SourcePosition();

    	currentToken = scanner.getToken();
    }

    // match checks to see f the current token matches tokenExpected.
    // If so, fetches the next token.
    // If not, reports a syntactic error.

    void match(int tokenExpected) throws SyntaxError {
    	if (currentToken.kind == tokenExpected) {
      	    previousTokenPosition = currentToken.position;
      	    currentToken = scanner.getToken();
    	} else {
           throw syntacticError("\"%\" expected here", Token.spell(tokenExpected));
    	}
    }

    void accept() {
    	previousTokenPosition = currentToken.position;
    	currentToken = scanner.getToken();
    }

    private SyntaxError syntacticError(String messageTemplate, String tokenQuoted) throws SyntaxError {
    	SourcePosition pos = currentToken.position;
	    errorReporter.reportError(messageTemplate, tokenQuoted, pos);
	    return new SyntaxError();
    }

	// start records the position of the start of a phrase.
	// This is defined to be the position of the first
	// character of the first token of the phrase.

    void start(SourcePosition position) {
    	position.lineStart = currentToken.position.lineStart;
    	position.charStart = currentToken.position.charStart;
    }

	// finish records the position of the end of a phrase.
	// This is defined to be the position of the last
	// character of the last token of the phrase.

    void finish(SourcePosition position) {
    	position.lineFinish = previousTokenPosition.lineFinish;
    	position.charFinish = previousTokenPosition.charFinish;
    }

    void copyStart(SourcePosition from, SourcePosition to) {
    	to.lineStart = from.lineStart;
    	to.charStart = from.charStart;
    }


    // ========================== Debug helpers ========================
    void debug() {
        System.out.println("=== DEBUG ===");
        System.out.println(currentToken.toString());
        System.out.println("=== ===== ===");
    };

    void debugScream() throws SyntaxError {
        System.out.println("=== DEBUG ===");
        System.out.println(currentToken.toString());
        System.out.println("=== ===== ===");
        scream();
    };

    void scream() throws SyntaxError {
        syntacticError("\"%\" <- !Scream!", currentToken.spelling);
    }

    void scream(String name) throws SyntaxError {
        System.out.println("I am still implementing: " + name);
        syntacticError("\"%\" <- I am still implementing", currentToken.spelling);
    }

    // ========================== PROGRAMS ========================

	/**
	 * This parseProgram is intended to parse line by line
	 */
    public Program parseProgram() throws SyntaxError {
        SourcePosition programPos = new SourcePosition();
        start(programPos);
		ASTList<Decl> funcAndVarDeclList = new EmptyDeclList(dummyPos); 
		ASTList<Decl> tail = funcAndVarDeclList;

		// While loop is just for adding decl 
        while (currentToken.kind != Token.EOF) {
			Type tAST = parseType();
			Ident iAST = parseIdent();
			ASTList<Decl> dAST = new EmptyDeclList(programPos);
			if (currentToken.kind == Token.LPAREN) {
				dAST = parseFuncDeclList(tAST,  iAST) ;
			} else {
				if (currentToken.kind != Token.SEMICOLON) {
					dAST = parseVarDeclWithoutTypeIden(tAST, iAST, GLOBAL_VARIABLE, programPos);
				} else {
					Decl lvAST = new GlobalVarDecl(tAST, iAST, new EmptyExpr(programPos), programPos);
					dAST = new DeclList(lvAST, null, programPos);
					dAST.setNext(new EmptyDeclList(programPos));
					match(Token.SEMICOLON);
				}
				finish(programPos);
			}

			if (funcAndVarDeclList instanceof EmptyDeclList) {
				funcAndVarDeclList = dAST;
				tail = dAST;
			} else {
				while (tail != null && 
					!(tail instanceof EmptyDeclList) &&
					!(tail.getNext() instanceof EmptyDeclList) && 
					tail.getNext() != null
				) {
					tail = tail.getNext();
				}
				tail.setNext(dAST);
			}
		}
		return new Program(funcAndVarDeclList, programPos);
    }

	// ========================== DECLARATIONS ========================

    ASTList<Decl> parseFuncDeclList(Type tAST, Ident idAST) throws SyntaxError {
		SourcePosition pos = new SourcePosition();
		start(pos);

		// para-list 
		ASTList<Decl> plAST = parseParaList();

        // compound-stmt
        Stmt sAST = parseCompoundStmt();

		FuncDecl fdAST = new FuncDecl( tAST,  idAST,  plAST, sAST, pos );
 		DeclList dAST = new DeclList(fdAST, null, pos);
		dAST.setNext(new EmptyDeclList(pos));
		return dAST;
    }


    ASTList<Decl> parseLocalVarDeclList() throws SyntaxError {
		ASTList<Decl> varDeclList = new EmptyDeclList(dummyPos); 
		ASTList<Decl> tail = varDeclList;
		SourcePosition pos = new SourcePosition();
		start(pos);


		// At this point tail should be the end of the first linkedlist
		while (currentToken.kind == Token.VOID || 
			currentToken.kind == Token.BOOLEAN ||
			currentToken.kind == Token.INT ||
			currentToken.kind == Token.FLOAT) {

			Type tAST = parseType();
			Ident iAST = parseIdent();
			
			ASTList<Decl> dAST = new EmptyDeclList(pos);

			if (currentToken.kind != Token.SEMICOLON) {
				dAST = parseVarDeclWithoutTypeIden(tAST, iAST, GLOBAL_VARIABLE, pos);
			} else {
				Decl lvAST = new LocalVarDecl(tAST, iAST, new EmptyExpr(pos), pos);
				dAST = new DeclList(lvAST, null, pos);
				dAST.setNext(new EmptyDeclList(pos));
				match(Token.SEMICOLON);
			}
			finish(pos);
			
			if (varDeclList instanceof EmptyDeclList) {
				varDeclList = dAST;
				tail = dAST;
			} else {
				while (tail != null && 
					!(tail instanceof EmptyDeclList) &&
					!(tail.getNext() instanceof EmptyDeclList) && 
					tail.getNext() != null
				) {
					tail = tail.getNext();
				}
				tail.setNext(dAST);
			}
		}
		return varDeclList;
	}

	
	Expr parseInitialiser() throws SyntaxError {
		SourcePosition pos = new SourcePosition();
    	start(pos);
        Expr eAST = null;
		if (currentToken.kind == Token.EQ) {
            match(Token.EQ);
			// It is a list
			if (currentToken.kind == Token.LCURLY) {
				eAST = parseInitialiserList();

			} else {
				// Just an expression
				eAST = parseExpr();
				finish(pos);			
			}
        } else {
        	throw syntacticError("expect '=' at initializer", currentToken.spelling);
		}
		return eAST;
	}

	/**
	 * This function should not be called directly - just a helper for parseInitialiser
	 * will transform from ArrayExprList.java to Expr       
	 */
	Expr parseInitialiserList() throws SyntaxError {
		ArrayExprList aAST = null;
		SourcePosition pos = new SourcePosition();
    	start(pos);

		ArrayExprList aeHeadAST = null;
        if (currentToken.kind == Token.LCURLY) {
            match(Token.LCURLY);
            Expr eAST = parseExpr();
			aeHeadAST = new ArrayExprList(eAST, null, pos);
			ArrayExprList aeCurrAST = aeHeadAST;
            
			while (currentToken.kind == Token.COMMA) {
                match(Token.COMMA);
				// Create new
                eAST = parseExpr();
				ArrayExprList aeNewAST = new ArrayExprList(eAST, null, pos);

				// link tail 
				aeCurrAST.setNext(aeNewAST);

				// iterate
				aeCurrAST = aeNewAST;
            }
            match(Token.RCURLY);
	    	finish(pos);
			aeCurrAST.setNext(new EmptyArrayExprList(pos));
        } else {
        	throw syntacticError("expect '{' at initializer list", currentToken.spelling);
        }
		return chooseInitExpr(aeHeadAST, pos);
    }


	Expr chooseInitExpr(ASTList<Expr> iniAST, SourcePosition pos) throws SyntaxError {
		// Place holder local here first, will make global later
		Expr eAST = null;
		// Check if initialiser == empty
		if (iniAST == null) {
			// Do notthing		
			eAST = new EmptyExpr(pos);	
		} 
		// Check if initialiser has only 1
		else if (iniAST.getNext() == null) {
			eAST = new ArrayInitExpr (iniAST, pos);
		} 
		// else initialiser has a lot 
		else {
			eAST = new ArrayInitExpr (iniAST, pos);
		}
		return eAST;
	}

	Type consumeIdBrackets(Type tAST, SourcePosition pos) throws SyntaxError {
		if (currentToken.kind == Token.LBRACKET) {
			Expr litExprAST = new EmptyExpr(pos);
			
			match(Token.LBRACKET);
			if (currentToken.kind == Token.INTLITERAL) {
				litExprAST = parseExpr();
            }
            match(Token.RBRACKET);

			return new ArrayType(tAST, litExprAST, pos);
        } else {
			return tAST;
		}
	}

	/**
	 * This function is for convinience for this case
	 * compound-stmt       -> "{" var-decl* stmt* "}" 
	 */
    ASTList<Decl> parseVarDecl(boolean isGlobal) throws SyntaxError {
    	SourcePosition pos = new SourcePosition();
    	start(pos);
	    Type tAST = parseType();
		Ident iAST = parseIdent();
		// Type varTypeAST =  consumeIdBrackets(tAST, pos); 
		return parseVarDeclWithoutTypeIden(tAST, iAST, isGlobal, pos);
	}

	/**
	 * This function assumes that prior types and ident 
	 * have been taken care of
	 * 
	 * It has ability to handle case int i, j, k = 10; as well 
	 */
    DeclList parseVarDeclWithoutTypeIden(
		Type tAST, 
		Ident iAST, 
		boolean isGlobal, 
		SourcePosition pos ) throws SyntaxError 
	{
		Type varTypeAST = consumeIdBrackets(tAST, pos);
		Expr eAST = new EmptyExpr(pos);
        if (currentToken.kind == Token.EQ) {
			eAST = parseInitialiser();
        }
		
		Decl lvAST = new LocalVarDecl(varTypeAST, iAST, eAST, pos);
		if (isGlobal) {
			lvAST = new GlobalVarDecl(varTypeAST, iAST, eAST, pos);
		}
		DeclList dlHeadAST = new DeclList(lvAST, null, pos);

		DeclList dlCurrAST = dlHeadAST;
        while (currentToken.kind == Token.COMMA) {
            match(Token.COMMA);
			iAST = parseIdent();
			
			varTypeAST= consumeIdBrackets(tAST, pos);
			
			if (currentToken.kind == Token.EQ) {
				eAST = parseInitialiser();
			}
			
			// Create linked list
			// Create new node
			lvAST = new LocalVarDecl(varTypeAST, iAST, eAST, pos);
			if (isGlobal) {
				lvAST = new GlobalVarDecl(varTypeAST, iAST, eAST, pos);
			}

			DeclList dlNewAST = new DeclList(lvAST, null, pos);

			// Plug curr -> next to new 
			dlCurrAST.setNext(dlNewAST);
			
			// Curr = new 
			dlCurrAST = dlNewAST;
        }
        match(Token.SEMICOLON);
		// finish(pos);
		dlCurrAST.setNext(new EmptyDeclList(pos));
		return dlHeadAST;
    }
	

	//  ======================== TYPES ==========================

    Type parseType() throws SyntaxError {
    	Type typeAST = null;
    	SourcePosition typePos = new SourcePosition();
    	start(typePos);
		if (currentToken.kind == Token.VOID) {
			match(Token.VOID);
			finish(typePos);
			typeAST =  new VoidType(typePos);
		} else if (currentToken.kind == Token.BOOLEAN) {
			match(Token.BOOLEAN);
			finish(typePos);
			typeAST =  new BooleanType(typePos);
		} else if (currentToken.kind == Token.INT) {
			match(Token.INT);
			finish(typePos);
			typeAST = new IntType(typePos);
		} else if (currentToken.kind == Token.FLOAT) {
			match(Token.FLOAT);
			finish(typePos);
			typeAST = new FloatType(typePos);
		} else {
			throw syntacticError("illegal type", currentToken.spelling);
		}
    	return typeAST;
      }

	// ======================= STATEMENTS ==============================

    Stmt parseCompoundStmt() throws SyntaxError {
    	Stmt cAST = null; 
    	SourcePosition stmtPos = new SourcePosition();
    	start(stmtPos);
    	match(Token.LCURLY);

		ASTList<Decl> lvdAST = parseLocalVarDeclList();
    	ASTList<Stmt> slAST = parseStmtList();

    	match(Token.RCURLY);
    	finish(stmtPos);

    	/* In the subset of the VC grammar implemented in this starter code, no variable declarations are
     	 * allowed. Therefore, a block (i.e., compound statement) is empty iff it has no statements.
     	 */
    	if ((slAST instanceof EmptyStmtList) && (lvdAST instanceof EmptyDeclList)) {
			cAST = new EmptyCompStmt(stmtPos);
		} 
    	else {
      	    cAST = new CompoundStmt(lvdAST, slAST, stmtPos);
		}
    	return cAST;
    }

    ASTList<Stmt> parseStmtList() throws SyntaxError {
    	ASTList<Stmt> slHeadAST = null; 

    	SourcePosition stmtPos = new SourcePosition();
    	start(stmtPos);

		// The first stmt in stmt list
    	if (currentToken.kind != Token.RCURLY) {
      	    Stmt sAST = parseStmt();
			slHeadAST = new StmtList(sAST, null, stmtPos);
        } else {
      		slHeadAST = new EmptyStmtList(dummyPos);
			// finish(stmtPos);
       	}		

    	ASTList<Stmt> slCurrentAST =  slHeadAST;
		while (currentToken.kind != Token.RCURLY) {
			// Create new node
      	    Stmt sAST = parseStmt();
			ASTList<Stmt> slNewAST = new StmtList(sAST, null, stmtPos);

			// plug current node->next =new node
			slCurrentAST.setNext(slNewAST);

			// set current node = new node (iterate) 
			slCurrentAST = slNewAST;
		}

		if (!(slCurrentAST instanceof EmptyStmtList)) {
			slCurrentAST.setNext(new EmptyStmtList(dummyPos));
		}

		finish(stmtPos);
    	return slHeadAST;
    }

    Stmt parseStmt() throws SyntaxError {
		return switch (currentToken.kind) {
            case Token.LCURLY ->  parseCompoundStmt(); 
            case Token.IF -> parseIfStmt();
            case Token.FOR -> parseForStmt();
            case Token.WHILE -> parseWhileStmt();
            case Token.BREAK -> parseBreakStmt();
            case Token.CONTINUE -> parseContinueStmt();
            case Token.RETURN -> parseReturnStmt();

            // Can just call because inside parseExpr has check condition already!
            default -> parseExprStmt();
        };
    }

	Stmt parseIfStmt() throws SyntaxError {
        SourcePosition stmtPos = new SourcePosition();
    	start(stmtPos);

		match(Token.IF);
        match(Token.LPAREN);
		Expr eAST = parseExpr();
        match(Token.RPAREN);
        Stmt sAST = parseStmt();

		Stmt iAST = new IfStmt(eAST, sAST, stmtPos);
        if (currentToken.kind == Token.ELSE) {
            match(Token.ELSE);
            Stmt elseAST = parseStmt();
			iAST = new IfStmt(eAST, sAST, elseAST, stmtPos);
        }
		finish(stmtPos);
		return iAST;
    }

	Stmt parseForStmt() throws SyntaxError {
    	SourcePosition stmtPos = new SourcePosition();
    	start(stmtPos);

        match(Token.FOR);
        match(Token.LPAREN);

		Expr e1AST = null;
        if (currentToken.kind != Token.SEMICOLON) {
            e1AST = parseExpr();
        } else {
			e1AST = new EmptyExpr(stmtPos); 
		}
        match(Token.SEMICOLON);


		Expr e2AST = null;
        if (currentToken.kind != Token.SEMICOLON) {
            e2AST = parseExpr();
        } else {
			e2AST = new EmptyExpr(stmtPos); 
		}
        match(Token.SEMICOLON);

		Expr e3AST = null;
        if (currentToken.kind != Token.SEMICOLON && currentToken.kind != Token.RPAREN) {
            e3AST = parseExpr();
        } else {
			e3AST = new EmptyExpr(stmtPos); 
		}
        match(Token.RPAREN);

		Stmt sAST = parseStmt();
		finish(stmtPos);
		return new ForStmt(e1AST, e2AST, e3AST, sAST, stmtPos);
    }

	
	Stmt parseWhileStmt() throws SyntaxError {
    	SourcePosition stmtPos = new SourcePosition();
    	start(stmtPos);
		match(Token.WHILE);
		match(Token.LPAREN);
		Expr eAST = parseExpr();
		match(Token.RPAREN);
		Stmt sAST = parseStmt();
		finish(stmtPos);
		return new WhileStmt(eAST, sAST, stmtPos);
    }

	Stmt parseBreakStmt() throws SyntaxError {
    	SourcePosition stmtPos = new SourcePosition();
    	start(stmtPos);
		match(Token.BREAK);
        match(Token.SEMICOLON);
		finish(stmtPos);
		return new BreakStmt(stmtPos);
    }

	Stmt parseContinueStmt() throws SyntaxError {
    	SourcePosition stmtPos = new SourcePosition();
    	start(stmtPos);
		match(Token.CONTINUE);
        match(Token.SEMICOLON);
		finish(stmtPos);
		return new ContinueStmt(stmtPos);
    }
 
    Stmt parseReturnStmt() throws SyntaxError {
        Stmt sAST = null;
    	SourcePosition stmtPos = new SourcePosition();
    	start(stmtPos);
		match(Token.RETURN);
        if (currentToken.kind != Token.SEMICOLON) {
			Expr eAST = parseExpr();
			sAST = new ReturnStmt(eAST, stmtPos);
        } else {
			sAST = new ReturnStmt(new EmptyExpr(dummyPos), stmtPos);
		}
        match(Token.SEMICOLON);
		finish(stmtPos);
		return sAST;
    }

    Stmt parseExprStmt() throws SyntaxError {
    	Stmt sAST = null;
    	SourcePosition stmtPos = new SourcePosition();
    	start(stmtPos);
		if (currentToken.kind == Token.SEMICOLON) {
			match(Token.SEMICOLON);
            finish(stmtPos);
            sAST = new ExprStmt(new EmptyExpr(dummyPos), stmtPos);
		} else {
        	Expr eAST = parseExpr();
        	match(Token.SEMICOLON);
        	finish(stmtPos);
        	sAST = new ExprStmt(eAST, stmtPos);
		}
    	return sAST;
    }


	// ======================= PARAMETERS =======================

	// para-list           -> "(" proper-para-list? ")"
    ASTList<Decl> parseParaList() throws SyntaxError {
		SourcePosition pos = new SourcePosition();
    	start(pos);
		match(Token.LPAREN);
		ASTList<Decl> plAST = new EmptyParaList(dummyPos);

        if (currentToken.kind != Token.RPAREN) {
            plAST = parseProperParaList();

        }
		match(Token.RPAREN);
		finish(pos);
		return plAST;
    }


	// This function is called only when the list is not empty!
	// proper-para-list    -> para-decl ( "," para-decl )*
    ASTList<Decl> parseProperParaList() throws SyntaxError {
		SourcePosition pos = new SourcePosition();
    	start(pos);
        Decl pAST = parseParaDecl(); 
		ASTList<Decl> plHeadAST = new ParaList (pAST, null, pos);
		ASTList<Decl> tail = plHeadAST;
	
        while (currentToken.kind == Token.COMMA) {
            match(Token.COMMA);
            pAST = parseParaDecl();
		 	ParaList plNewAST = new ParaList(pAST, null, pos);
			
			// Move tail one by one! 

			// Set tail -> next = new 
			tail.setNext(plNewAST);

			// tail = next
			tail = plNewAST;
        }
		finish(pos);
		// End the list with empty! 
		tail.setNext(new EmptyParaList(pos));
		return plHeadAST;        
    }

	// para-decl           -> type declarator
	// declarator          -> identifier 
                    // |  identifier "[" INTLITERAL? "]"
	Decl parseParaDecl() throws SyntaxError {
		SourcePosition pos = new SourcePosition();
    	start(pos);
		Type tAST = parseType();
        Ident iAST = parseIdent();
		Type varTypeAST = consumeIdBrackets(tAST, pos);
		finish(pos);
		return new ParaDecl ( varTypeAST,  iAST, pos);
    };


	// ======================= EXPRESSIONS ======================
    Expr parseExpr() throws SyntaxError {
    	return parseAssignExpr();
    }

	Expr parseAssignExpr() throws SyntaxError {
    	Expr exprAST = null;
    	SourcePosition addStartPos = new SourcePosition();
    	start(addStartPos);
    	exprAST = parseCondOrExpr();

    	if (currentToken.kind == Token.EQ) {
			// Consume the  = sign 
      	    Operator opAST = acceptOperator();
			Expr e2AST = parseAssignExpr();
      	    SourcePosition addPos = new SourcePosition();
      	    copyStart(addStartPos, addPos);
      	    finish(addPos);
      	    exprAST = new AssignExpr(exprAST, e2AST, addPos);
		}
    	return exprAST;
    }

	Expr parseCondOrExpr() throws SyntaxError {
    	Expr exprAST = null;
    	SourcePosition addStartPos = new SourcePosition();
    	start(addStartPos);
    	exprAST = parseCondAndExpr();

    	while (currentToken.kind == Token.OROR) {
      	    Operator opAST = acceptOperator();
            Expr e2AST = parseCondAndExpr();

      	    SourcePosition addPos = new SourcePosition();
      	    copyStart(addStartPos, addPos);
      	    finish(addPos);
      	    exprAST = new BinaryExpr(exprAST, opAST, e2AST, addPos);
		}
    	return exprAST;
    }

    Expr parseCondAndExpr() throws SyntaxError {
    	Expr exprAST = null;
    	SourcePosition addStartPos = new SourcePosition();
    	start(addStartPos);
    	exprAST = parseEqualityExpr();

    	while (currentToken.kind == Token.ANDAND) {
      	    Operator opAST = acceptOperator();
            Expr e2AST = parseEqualityExpr();

      	    SourcePosition addPos = new SourcePosition();
      	    copyStart(addStartPos, addPos);
      	    finish(addPos);
      	    exprAST = new BinaryExpr(exprAST, opAST, e2AST, addPos);
		}
    	return exprAST;
    }

    Expr parseEqualityExpr() throws SyntaxError {
    	Expr exprAST = null;
    	SourcePosition addStartPos = new SourcePosition();
    	start(addStartPos);
    	exprAST = parseRelExpr();

    	while (currentToken.kind == Token.EQEQ
           || currentToken.kind == Token.NOTEQ) {
      	    Operator opAST = acceptOperator();
            Expr e2AST = parseRelExpr();

      	    SourcePosition addPos = new SourcePosition();
      	    copyStart(addStartPos, addPos);
      	    finish(addPos);
      	    exprAST = new BinaryExpr(exprAST, opAST, e2AST, addPos);
    	}
    	return exprAST;
    }

    Expr parseRelExpr() throws SyntaxError {
    	Expr exprAST = null;
    	SourcePosition addStartPos = new SourcePosition();
    	start(addStartPos);
    	exprAST = parseAdditiveExpr();

    	while (currentToken.kind == Token.LT
           || currentToken.kind == Token.GT
		   || currentToken.kind == Token.GTEQ
		   || currentToken.kind == Token.LTEQ) {
      	    Operator opAST = acceptOperator();
            Expr e2AST = parseAdditiveExpr();

      	    SourcePosition addPos = new SourcePosition();
      	    copyStart(addStartPos, addPos);
      	    finish(addPos);
      	    exprAST = new BinaryExpr(exprAST, opAST, e2AST, addPos);
    	}
    	return exprAST;
    }

    Expr parseAdditiveExpr() throws SyntaxError {
    	Expr exprAST = null;
    	SourcePosition addStartPos = new SourcePosition();
    	start(addStartPos);
    	exprAST = parseMultiplicativeExpr();
    	while (currentToken.kind == Token.PLUS
           || currentToken.kind == Token.MINUS) {
      	    Operator opAST = acceptOperator();
            Expr e2AST = parseMultiplicativeExpr();

      	    SourcePosition addPos = new SourcePosition();
      	    copyStart(addStartPos, addPos);
      	    finish(addPos);
      	    exprAST = new BinaryExpr(exprAST, opAST, e2AST, addPos);
    	}
    	return exprAST;
    }

    Expr parseMultiplicativeExpr() throws SyntaxError {
    	Expr exprAST = null;
    	SourcePosition multStartPos = new SourcePosition();
    	start(multStartPos);
    	exprAST = parseUnaryExpr();
    	while (currentToken.kind == Token.MULT
           || currentToken.kind == Token.DIV) {

      	    Operator opAST = acceptOperator();
      	    Expr e2AST = parseUnaryExpr();
            SourcePosition multPos = new SourcePosition();
            copyStart(multStartPos, multPos);
            finish(multPos);
            exprAST = new BinaryExpr(exprAST, opAST, e2AST, multPos);
        }
    	return exprAST;
    }


    /**
     * unary-expr   -> "+" unary-expr
                    |  "-" unary-expr
                    |  "!" unary-expr
                    |  primary-expr 
     */
	Expr parseUnaryExpr() throws SyntaxError {
		SourcePosition primPos = new SourcePosition();
		start(primPos);

		if (currentToken.kind == Token.PLUS
				|| currentToken.kind == Token.MINUS
				|| currentToken.kind == Token.NOT) {
			Operator oAST = acceptOperator();
			Expr uAST = parseUnaryExpr();
			finish(primPos);
			return new UnaryExpr(oAST, uAST, primPos);
		} else {
			return parsePrimaryExpr();
		}
	}


	void a(ASTList<Decl>  alHeadAST) {
		StringBuilder sb = new StringBuilder("[");
    	ASTList<Decl> cur = alHeadAST;
    	while (cur != null && !cur.isEmpty()) {
        	// sb.append(cur.getHead());
			sb.append(cur.getHead().getClass().getSimpleName()); 
        	cur = cur.getNext();
			if (cur == null) break;
        	if (!cur.isEmpty()) sb.append(", ");
    	}
    	sb.append("]");
		System.out.println(sb);
	}

	void parseProperArgListDebug(ASTList<Arg>  alHeadAST) {
		StringBuilder sb = new StringBuilder("[");
    	ASTList<Arg> cur = alHeadAST;
    	while (cur != null && !cur.isEmpty()) {
        	// sb.append(cur.getHead());
			sb.append(cur.getHead().E.getClass().getSimpleName()); 
        	cur = cur.getNext();
			if (cur == null) break;
        	if (!cur.isEmpty()) sb.append(", ");
    	}
    	sb.append("]");
		System.out.println(sb);
	}

    // proper-arg-list     -> arg ( "," arg )*
    ASTList<Arg> parseProperArgList() throws SyntaxError {
        SourcePosition primPos = new SourcePosition();
    	start(primPos);

		// Creat arg
		Arg aHeadAST = parseArg();

		// Create arglist node
		ASTList<Arg> alHeadAST = new ArgList(aHeadAST, null, primPos);

		// Set move pointer
        ASTList<Arg> alCurrentAST = alHeadAST;

		while (currentToken.kind == Token.COMMA) {
			accept(); // Consume the comma

			// Create the new
			Arg aNewAST = parseArg();

			finish(primPos);

			ASTList<Arg> alNewAST = new ArgList(aNewAST, null, primPos);

			// Plug current->next = new
			alCurrentAST.setNext(alNewAST);

			// update current = new
			alCurrentAST = alNewAST;
		};

		if (!(alCurrentAST instanceof EmptyArgList)) {
			alCurrentAST.setNext(new EmptyArgList(primPos));
		}
		return alHeadAST; 
    }

	Arg parseArg() throws SyntaxError {
		SourcePosition primPos = new SourcePosition();
    	start(primPos);
		Expr eAST = parseExpr();
		finish(primPos);
		return new Arg(eAST,  primPos);
	}

    // arg-list            -> "(" proper-arg-list? ")"
    ASTList<Arg> parseArgList() throws SyntaxError {
    	SourcePosition primPos = new SourcePosition();
    	start(primPos);
		ASTList<Arg> alAST = null;
		match(Token.LPAREN); // LPAREN
        if (currentToken.kind != Token.RPAREN) {
            alAST = parseProperArgList();
        } else {
			alAST = new EmptyArgList(primPos);
		}
		match(Token.RPAREN); // RPAREN
		finish(primPos);
		return alAST;
    }

    Expr parsePrimaryExpr() throws SyntaxError {
    	SourcePosition primPos = new SourcePosition();
    	start(primPos);

    	return switch (currentToken.kind) {
        	case Token.ID -> {
            	Ident iAST = parseIdent();

				// -> identifier "[" expr "]"
                if (currentToken.kind == Token.LBRACKET) {
                    match(Token.LBRACKET);
					Var simVAST = new SimpleVar(iAST, primPos);
                    Expr eAST = parseExpr();
                    match(Token.RBRACKET);
					finish(primPos);
					yield new ArrayExpr (simVAST, eAST, primPos);
                } 

                //  -> identifier arg-list?
                else if (currentToken.kind == Token.LPAREN) {
                    ASTList<Arg> alAST = parseArgList(); // inside this consume LPAREN
					finish(primPos);
					yield new CallExpr(iAST, alAST, primPos); 

                }

            	finish(primPos);
            	Var simVAST = new SimpleVar(iAST, primPos); // case only identifier
            	yield new VarExpr(simVAST, primPos);
        	}

        	case Token.LPAREN -> {
            	accept();
            	Expr exprAST = parseExpr();
            	match(Token.RPAREN);
				yield exprAST;
        	}

        	case Token.INTLITERAL -> {
            	IntLiteral ilAST = parseIntLiteral();
            	finish(primPos);
            	yield new IntExpr(ilAST, primPos);
        	}

			case Token.FLOATLITERAL -> {
            	FloatLiteral flAST = parseFloatLiteral();
            	finish(primPos);
            	yield new FloatExpr(flAST, primPos);
        	}

        	case Token.BOOLEANLITERAL -> {
            	BooleanLiteral blAST = parseBooleanLiteral();
            	finish(primPos);
            	yield new BooleanExpr(blAST, primPos);
        	}

        	case Token.STRINGLITERAL -> {
            	StringLiteral slAST = parseStringLiteral();
            	finish(primPos);
            	yield new StringExpr(slAST, primPos);
        	}

        	default -> throw syntacticError("illegal primary expression", currentToken.spelling);
    	};
	}



	// ========================== ID, OPERATOR and LITERALS ========================
	Ident parseIdent() throws SyntaxError {
    	if (currentToken.kind != Token.ID) {
        	throw syntacticError("identifier expected here", "");
    	}

    	String spelling = currentToken.spelling;
		accept();
    	return new Ident(spelling, previousTokenPosition);
	}


	// acceptOperator parses an operator, and constructs a leaf AST for it
  	Operator acceptOperator() throws SyntaxError {
    	String spelling = currentToken.spelling;
     	accept();
		return new Operator(spelling, previousTokenPosition);
  	}

 // ========================== LITERALS ========================

    private IntLiteral parseIntLiteral() throws SyntaxError {
        if (currentToken.kind == Token.INTLITERAL) {
            String spelling = currentToken.spelling;
            accept();
            return new IntLiteral(spelling, previousTokenPosition);
        } else {
            throw syntacticError("integer literal expected here", "");
        }
    }


    private FloatLiteral parseFloatLiteral() throws SyntaxError {
        if (currentToken.kind == Token.FLOATLITERAL) {
            String spelling = currentToken.spelling;
            accept();
            return new FloatLiteral(spelling, previousTokenPosition);
        } else {
            throw syntacticError("float literal expected here", "");
        }   
    }   
    
    private BooleanLiteral parseBooleanLiteral() throws SyntaxError {
        if (currentToken.kind == Token.BOOLEANLITERAL) {
            String spelling = currentToken.spelling;
            accept();
            return new BooleanLiteral(spelling, previousTokenPosition);
        } else {
            throw syntacticError("boolean literal expected here", "");
        }
    }

	private StringLiteral parseStringLiteral()  throws SyntaxError {
		if (currentToken.kind == Token.STRINGLITERAL) {
            String spelling = currentToken.spelling;
            accept();
			return new StringLiteral(spelling, previousTokenPosition);
        } else {
            throw syntacticError("string literal expected here", "");
        }
    }

}

