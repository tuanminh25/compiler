/*
 * Recogniser.java            
 *
 * Wed 25 Feb 2026 09:13:08 AEDT
 */

/* This recogniser accepts a subset of VC defined by the following CFG: 

	program       -> func-decl
	
	// declaration
	
	func-decl     -> void identifier "(" ")" compound-stmt
	
	identifier    -> ID
	
	// statements 
	compound-stmt -> "{" stmt* "}" 
	stmt          -> continue-stmt
	    	      |  expr-stmt
	continue-stmt -> continue ";"
	expr-stmt     -> expr? ";"
	
	// expressions 
	expr                -> assignment-expr
	assignment-expr     -> additive-expr
	additive-expr       -> multiplicative-expr
	                    |  additive-expr "+" multiplicative-expr
	multiplicative-expr -> unary-expr
		            |  multiplicative-expr "*" unary-expr
	unary-expr          -> "-" unary-expr
			    |  primary-expr
	
	primary-expr        -> identifier
	 		    |  INTLITERAL
			    | "(" expr ")"
 
It serves as a good starting point for implementing your own VC recogniser. 
You can modify the existing parsing methods (if necessary) and add any missing ones 
to build a complete recogniser for VC.

Alternatively, you are free to disregard the starter code entirely and develop 
your own solution, as long as it adheres to the same public interface.

*/

package VC.Recogniser;

import VC.Scanner.Scanner;
import VC.Scanner.SourcePosition;
import VC.Scanner.Token;
import VC.ErrorReporter;
import java.util.Set;
import java.util.HashSet;
import java.util.Arrays;

public class Recogniser {

    private Scanner scanner;
    private ErrorReporter errorReporter;
    private Token currentToken;
    private Set<Integer> typeTokens = new HashSet<>(Arrays.asList(
        Token.VOID, Token.BOOLEAN, Token.INT, Token.FLOAT
    ));


    public Recogniser(Scanner lexer, ErrorReporter reporter) {
        scanner = lexer;
        errorReporter = reporter;
        currentToken = scanner.getToken();
    }

    // match checks to see if the current token matches tokenExpected.
    // If so, fetches the next token.
    // If not, reports a syntactic error.
    void match(int tokenExpected) throws SyntaxError {
        if (currentToken.kind == tokenExpected) {
            currentToken = scanner.getToken();
        } else {
            syntacticError("\"%\" expected here", Token.spell(tokenExpected));
        }
    }

    // accepts the current token and fetches the next
    void accept() {
        currentToken = scanner.getToken();
    }

    // Handles syntactic errors and reports them via the error reporter.
    void syntacticError(String messageTemplate, String tokenQuoted) throws SyntaxError {
        SourcePosition pos = currentToken.position;
        errorReporter.reportError(messageTemplate, tokenQuoted, pos);
        throw new SyntaxError();
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
        syntacticError("\"%\" <- aaaaa", currentToken.spelling);
    }

    void scream(String name) throws SyntaxError {
        System.out.println("I am still implementing: " + name);
        syntacticError("\"%\" <- I am still implementing", currentToken.spelling);
    }


    // ========================== PROGRAMS ========================
    // program             ->  ( func-decl | var-decl )*
    public void parseProgram() {
        while (currentToken.kind != Token.EOF) {
            // All program knows is that it can just be in 3 state:
            // It can be a function right now 
            // or a var
            // or notthing 
            try {
                // both var and func starts with type and id
                parseTypes();
                parseIdent();
                
                // now if it is paranthesis then it would be a function decl
                if (currentToken.kind == Token.LPAREN) {
                    // debug();
                    parseFuncDecl();
                } else { 
                    // now let's assume that it is var decl, 
                    // and if it does not var decl -> syntax err
                    // System.out.println("Here at parse program");
                    // debug();
                    parseVarDeclWithoutTypeAndIden();
                }
            } catch (SyntaxError s) { 
                // Spec said that return right the way so at this point we return back
                // syntacticError("\"%\" <- message to be decided as syntax err", currentToken.spelling);
                return;
            }
        }
    }

    // ======================= primitive types ==============================
    void parseTypes() throws SyntaxError { 
        //  -> void | boolean | int | float
        if (currentToken.kind == Token.VOID) {
            accept();
        } else if ( currentToken.kind == Token.BOOLEAN ) {
            accept();
        } else if ( currentToken.kind == Token.INT ) {
            accept();
        } else if ( currentToken.kind == Token.FLOAT ) {
            accept();
        } else {
            // otherwise error 
            syntacticError("\"%\": undefined type!", currentToken.spelling);
        }
    }

    // ========================== parameters ========================
    
    // arg                 -> expr
    void parseArg() throws SyntaxError{
        parseExpr();
    }

    // arg-list            -> "(" proper-arg-list? ")"
    void parseProperArgList() throws SyntaxError {
        parseArg();
        while (currentToken.kind == Token.COMMA) {
            match(Token.COMMA);
            parseArg();
        }
    }
    
    // arg-list            -> "(" proper-arg-list? ")"
    void parseArgList() throws SyntaxError {
        match(Token.LPAREN);
        if (currentToken.kind != Token.RPAREN) {
            parseProperArgList();
        }
        match(Token.RPAREN);
    }


    // para-decl           -> type declarator
    void parseParaDecl() throws SyntaxError {
        parseTypes();
        parseDeclarator();
    }

    // proper-para-list    -> para-decl ( "," para-decl )*
    void parseProperParaList() throws SyntaxError {
        // Parse the fiurst para decl
        parseParaDecl(); 

        // It will stop at a ',' if there is more to come
        while (currentToken.kind == Token.COMMA) {
            match(Token.COMMA);
            parseParaDecl();
        }        
    }

    // para-list           -> "(" proper-para-list? ")"
    void parseParaList() throws SyntaxError {
        match(Token.LPAREN);
        if (currentToken.kind != Token.RPAREN) {
            parseProperParaList();
        }
        match(Token.RPAREN);
    }

    // ========================== DECLARATIONS ========================
    // declarator          -> identifier 
    //                 |  identifier "[" INTLITERAL? "]"
    void parseDeclaratorWithoutIden() throws SyntaxError {
        // it can be array form ! 
        if (currentToken.kind == Token.LBRACKET) {
            match( Token.LBRACKET);
            // it can be empty! 
            if (currentToken.kind == Token.INTLITERAL) {
                match( Token.INTLITERAL);
            }
            match(Token.RBRACKET);
        }
    }
    
    void parseDeclarator() throws SyntaxError {
        match(Token.ID);
        parseDeclaratorWithoutIden();
    };

    // initialiser         -> expr 
    //                     |  "{" expr ( "," expr )* "}"
    void parseInitialiser() throws SyntaxError {
        if (currentToken.kind == Token.LCURLY) {
            match(Token.LCURLY);
            parseExpr();
            while (currentToken.kind == Token.COMMA) {
                match(Token.COMMA);
                parseExpr();
            }
            match(Token.RCURLY);
        } else {
            parseExpr();
        }
    }

    // init-declarator     -> declarator ( "=" initialiser )? 
    void parseInitDeclarator() throws SyntaxError {
        parseDeclaratorWithoutIden();

        if (currentToken.kind == Token.EQ) {
            match(Token.EQ);
            parseInitialiser();
        }        
    }

    // init-declarator-list-> init-declarator ( "," init-declarator )*
    void parseInitDeclaratorList() throws SyntaxError {
        // init-declarator
        parseInitDeclarator();

        //  ( "," init-declarator )*
        while (currentToken.kind == Token.COMMA) {
            match(Token.COMMA);
            parseInitDeclarator();
        }
        scream();
    }    

    // var-decl            -> type init-declarator-list ";"
    void parseVarDecl() throws SyntaxError {
        parseTypes();
        parseIdent();
        parseVarDeclWithoutTypeAndIden();
        match(Token.SEMICOLON);
    }

    void parseVarDeclWithoutTypeAndIden() throws SyntaxError {
        parseInitDeclaratorList();
    }

    // func-decl           -> type identifier para-list compound-stmt
    void parseFuncDecl() throws SyntaxError {
        // Dont have to worry about type and first id
        // It has been handled inside program func
    
        // para-list 
        parseParaList();

        // compound-stmt
        parseCompoundStmt();
    }





    // ======================= STATEMENTS ==============================

    // compound-stmt       -> "{" var-decl* stmt* "}" 
    void parseCompoundStmt() throws SyntaxError {
        match(Token.LCURLY);

        // optional var-decl
        parseVarDeclList();

        // optional stmt
        parseStmtList();

        match(Token.RCURLY);
    }

    void parseVarDeclList() throws SyntaxError {
        while (typeTokens.contains(currentToken.kind)) {
            parseVarDecl();
        }
    }

    // Defines a list of statements enclosed within curly braces
    void parseStmtList() throws SyntaxError {
        while (currentToken.kind != Token.RCURLY) 
            parseStmt();
    }

    void parseStmt() throws SyntaxError {
        switch (currentToken.kind) {
            case Token.LCURLY -> parseCompoundStmt();
            case Token.IF -> parseIfStmt();
            case Token.FOR -> parseForStmt();
            case Token.WHILE -> parseWhileStmt();
            case Token.BREAK -> parseBreakStmt();
            case Token.CONTINUE -> parseContinueStmt();
            case Token.RETURN -> parseReturnStmt();

            // Can just call because inside parseExpr has check condition already!
            default -> parseExprStmt();
        }
    }

    // Handles if statements
    // if-stmt             -> if "(" expr ")" stmt ( else stmt )?
    void parseIfStmt() throws SyntaxError {
        match(Token.IF);
        match(Token.LPAREN);
        parseExpr();
        match(Token.RPAREN);
        parseStmt();
        if (currentToken.kind == Token.ELSE) {
            match(Token.ELSE);
            parseStmt();
        }
    }

    // Handles for statements
    // for-stmt            -> for "(" expr? ";" expr? ";" expr? ")" stmt
    void parseForStmt() throws SyntaxError {
        match(Token.FOR);
        match(Token.LPAREN);

        if (currentToken.kind != Token.SEMICOLON) {
            parseExpr();
        }
        match(Token.SEMICOLON);


        if (currentToken.kind != Token.SEMICOLON) {
            parseExpr();
        }
        match(Token.SEMICOLON);


        if (currentToken.kind != Token.RPAREN) {
            parseExpr();
        }
        match(Token.RPAREN);

        parseStmt();
    }

    // Handles while statements
    void parseWhileStmt() throws SyntaxError {
        match(Token.WHILE);
        match(Token.LPAREN);
        parseExpr();
        match(Token.RPAREN);
        parseStmt();
    }

    // Handles break statements
    void parseBreakStmt() throws SyntaxError {
        match(Token.BREAK);
        match(Token.SEMICOLON);
    }

    // Handles break statements
    void parseReturnStmt() throws SyntaxError {
        match(Token.RETURN);
        if (currentToken.kind != Token.SEMICOLON) {
            parseExpr();
        }
        match(Token.SEMICOLON);
    }

    // Handles continue statements
    void parseContinueStmt() throws SyntaxError {
        match(Token.CONTINUE);
        match(Token.SEMICOLON);
    }

    // Handles expression statements, optionally parsing an expression followed by a semicolon
    void parseExprStmt() throws SyntaxError {
        if (currentToken.kind == Token.ID
                || currentToken.kind == Token.INTLITERAL
                || currentToken.kind == Token.MINUS
                || currentToken.kind == Token.LPAREN) {
            parseExpr();
            match(Token.SEMICOLON);
        } else {
            match(Token.SEMICOLON);
        }
    }

    // ======================= IDENTIFIERS ======================
    // Calls parseIdent rather than match(Token.ID). In future assignments, 
    // an Identifier node will be constructed in this method.
    void parseIdent() throws SyntaxError {
        if (currentToken.kind == Token.ID) {
            accept();
        } else {
            syntacticError("identifier expected here", "");
        }
    }

    // ======================= OPERATORS ======================
    // Calls acceptOperator rather than accept(). In future assignments, 
    // an Operator Node will be constructed in this method.
    void acceptOperator() throws SyntaxError {
        currentToken = scanner.getToken();
    }

    // ======================= EXPRESSIONS ======================
    // expr                -> assignment-expr
    void parseExpr() throws SyntaxError {
        parseAssignExpr();
    }

    // assignment-expr     -> ( cond-or-expr "=" )* cond-or-expr
    void parseAssignExpr() throws SyntaxError {
        parseCondOrExpr();
        while (currentToken.kind == Token.EQ) {
            acceptOperator();
            parseCondOrExpr();
        }
    }

    /**
     * cond-or-expr        -> cond-and-expr 
                    |  cond-or-expr "||" cond-and-expr
     */
    void parseCondOrExpr() throws SyntaxError {
        parseCondAndExpr();
        while (currentToken.kind == Token.OROR) {
            acceptOperator();
            parseCondAndExpr();
        }
    }


    /**
     * cond-and-expr       -> equality-expr 
                    |  cond-and-expr "&&" equality-expr
     */
    void parseCondAndExpr() throws SyntaxError {
        parseEqualityExpr();
        while (currentToken.kind == Token.ANDAND) {
            acceptOperator();
            parseEqualityExpr();
        }
    }


    /**
     * 
     * equality-expr       -> rel-expr
                            |  equality-expr "==" rel-expr
                            |  equality-expr "!=" rel-expr
     */
    void parseEqualityExpr() throws SyntaxError {
        parseRelExpr();
        while (currentToken.kind == Token.NOTEQ || 
            currentToken.kind == Token.EQEQ  
        ) {
            acceptOperator();
            parseRelExpr();
        }
    }

    /**
     * rel-expr            -> additive-expr
                            |  rel-expr "<" additive-expr
                            |  rel-expr "<=" additive-expr
                            |  rel-expr ">" additive-expr
                            |  rel-expr ">=" additive-expr
     */
    void parseRelExpr() throws SyntaxError {
        parseAdditiveExpr();
        while (currentToken.kind == Token.LT || 
            currentToken.kind == Token.LTEQ || 
            currentToken.kind == Token.GT ||
            currentToken.kind == Token.GTEQ
        ) {
            acceptOperator();
            parseAdditiveExpr();
        }
    }

    /* 
    additive-expr       -> multiplicative-expr
                    |  additive-expr "+" multiplicative-expr
                    |  additive-expr "-" multiplicative-expr
    */
    void parseAdditiveExpr() throws SyntaxError {
        parseMultiplicativeExpr();
        while (currentToken.kind == Token.PLUS || currentToken.kind == Token.MINUS) {
            acceptOperator();
            parseMultiplicativeExpr();
        }
    }

    /* 
    multiplicative-expr -> unary-expr
                    |  multiplicative-expr "*" unary-expr
                    |  multiplicative-expr "/" unary-expr
    */
    void parseMultiplicativeExpr() throws SyntaxError {
        parseUnaryExpr();
        while (currentToken.kind == Token.MULT || currentToken.kind == Token.DIV) {
            acceptOperator();
            parseUnaryExpr();
        }
    }

    /**
     * unary-expr          -> "+" unary-expr
                    |  "-" unary-expr
                    |  "!" unary-expr
                    |  primary-expr 
     */
    void parseUnaryExpr() throws SyntaxError {
    	switch (currentToken.kind) {
            case Token.PLUS -> {
            	acceptOperator();
            	parseUnaryExpr();
            }
            case Token.MINUS -> {
            	acceptOperator();
            	parseUnaryExpr();
            }
            case Token.NOT -> {
            	acceptOperator();
            	parseUnaryExpr();
            }
            default -> parsePrimaryExpr();
    	}
    }


    /**
     * primary-expr        -> identifier arg-list?
                        | identifier "[" expr "]"
                        | "(" expr ")"
                        | INTLITERAL
                        | FLOATLITERAL
                        | BOOLLITERAL
                        | STRINGLITERAL
    */
    void parsePrimaryExpr() throws SyntaxError {
    	switch (currentToken.kind) {
            case Token.ID ->  {
                // identifier
                parseIdent();

                // -> identifier "[" expr "]"
                if (currentToken.kind == Token.LBRACKET) {
                    match(Token.LBRACKET);
                    parseExpr();
                    match(Token.RBRACKET);
                } 

                //  -> identifier arg-list?
                else if (currentToken.kind == Token.LPAREN) {
                    match(Token.LPAREN);
                    parseExpr();
                    match(Token.RPAREN);
                }
            }
            
            // "(" expr ")"
            case Token.LPAREN -> {
            	accept();
            	parseExpr();
            	match(Token.RPAREN);
            }
            case Token.INTLITERAL -> parseIntLiteral();
            case Token.FLOATLITERAL -> parseFloatLiteral();
            case Token.BOOLEANLITERAL -> parseBooleanLiteral();
            case Token.STRINGLITERAL -> parseStringLiteral();

            default -> syntacticError("illegal primary expression", currentToken.spelling);
    	}
    }

    // ========================== LITERALS ========================

    // Calls these methods rather than accept(). In future assignments, 
    // literal AST nodes will be constructed inside these methods.

    void parseIntLiteral() throws SyntaxError {
        if (currentToken.kind == Token.INTLITERAL) {
            accept();
        } else {
            syntacticError("integer literal expected here", "");
        }
    }

    void parseFloatLiteral() throws SyntaxError {
        if (currentToken.kind == Token.FLOATLITERAL) {
            accept();
        } else {
            syntacticError("float literal expected here", "");
        }
    }

    void parseBooleanLiteral() throws SyntaxError {
        if (currentToken.kind == Token.BOOLEANLITERAL) {
            accept();
        } else {
            syntacticError("boolean literal expected here", "");
        }
    }

    void parseStringLiteral()  throws SyntaxError {
        if (currentToken.kind == Token.STRINGLITERAL) {
            accept();
        } else {
            syntacticError("string literal expected here", "");
        }
    }
}

