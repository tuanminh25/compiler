/*
 * Scanner.java                        
 *
 * Mon 22 Feb 2026 16:54:28 AEDT
 *
 * The starter code here is provided as a high-level guide for implementation.
 *
 * You may completely disregard the starter code and develop your own solution, 
 * provided that it maintains the same public interface.
 *
 */

package VC.Scanner;

import VC.ErrorReporter;

public final class Scanner {

    private SourceFile sourceFile;
    private ErrorReporter errorReporter;
    private boolean debug;

    private StringBuilder currentSpelling;
    private char currentChar;

    // linestart - line finish - char start - char finish
    private int _linestart = 1; 
    private int _linefinish = 1; 
    private int _charstart = 1; 
    private int _charfinish = 1; 

    private SourcePosition sourcePos;


    // =========================================================

    public Scanner(SourceFile source, ErrorReporter reporter) {
        sourceFile = source;
        errorReporter = reporter;
        debug = false;

        // Initiaise currentChar for the starter code. 
        // Change it if necessary for your full implementation
        currentChar = sourceFile.getNextChar();

        // Initialise your counters for counting line and column numbers here
        sourcePos = new SourcePosition(1, 1, 1, 1);
    }

    public void enableDebugging() {
        debug = true;
    }

    // accept gets the next character from the source program.
    private void accept() {
        // Build the spelling as well: 
        currentSpelling.append(currentChar);
        // currentSpelling.append(Token.spell(Token.EOF));

        // Experiment principle: everytime we consume, we move the cursor endpoint 1 step forward
        ++_charfinish;
        ++_charstart;

        // Increment the char
     	currentChar = sourceFile.getNextChar();

  	// You may save the lexeme of the current token incrementally here
  	// You may also increment your line and column counters here
    }

    private void accept(boolean newLine) {
        accept();
        if (newLine) {
            _charfinish = 1;
            _charstart = 1;
            ++_linefinish;
            ++_linestart;
        }
    }

    // inspectChar returns the n-th character after currentChar in the input stream. 
    // If there are fewer than nthChar characters between currentChar 
    // and the end of file marker, SourceFile.eof is returned.
    // 
    // Both currentChar and the current position in the input stream
    // are *not* changed. Therefore, a subsequent call to accept()
    // will always return the next char after currentChar.

    // That is, inspectChar does not change 

    private char inspectChar(int nthChar) {
        return sourceFile.inspectChar(nthChar);
    }

    private int nextSeperators() {
        switch (currentChar) {
            // Handle separators
            case '(':
                accept();
                return Token.LPAREN;
            case ')':
                accept();
                return Token.RPAREN;
            case '{':
                accept();
                return Token.LCURLY;
            case '}':
                accept();
                return Token.RCURLY;
            case '[':
                accept();
                return Token.LBRACKET;
            case ']':
                accept();
                return Token.RBRACKET;
            case ';':
                accept();
                return Token.SEMICOLON;
            case ',':
                accept();
                return Token.COMMA;
            default:
                return -1;    
        }
    }

    private int nextOperators() {
        switch (currentChar) {
            // Those operators must go in single
            case '+':
                accept();
                return Token.PLUS;

            case '-':
                accept();
                return Token.MINUS;

            case '*':
                accept();
                return Token.MULT;

            case '/':
                accept();
                return Token.DIV;


            // Those operators optionally go in pair
            case '!':
                accept();
                if (currentChar == '=') {
                    accept();
                    return Token.NOTEQ;
                }
                return Token.NOT;

            case '=':
                accept();
                if (currentChar == '=') {
                    accept();
                    return Token.EQEQ;
                }
                return Token.EQ;


            case '<':
                accept();
                if (currentChar == '=') {
                    accept();
                    return Token.LTEQ;
                }
                return Token.LT;

            case '>':
                accept();
                if (currentChar == '=') {
                    accept();
                    return Token.GTEQ;
                }
                return Token.GT;

            // Those operators must go in pair
            case '|':
                accept();
                if (currentChar == '|') {
                    accept();
                    return Token.OROR;
                } else {
                    return Token.ERROR;
                }

            case '&':
                accept();
                if (currentChar == '&') {
                    accept();
                    return Token.ANDAND;
                } else {
                    return Token.ERROR;
                }  
            default:
                return -1;    
        }
    }

    private int nextIdentifiers() {
        if (Character.isLetter(currentChar) || currentChar == '_') {
            // Consume the current char
            accept();

            while ((Character.isLetterOrDigit(currentChar) || currentChar == '_') && 
                currentChar != Token.EOF) {
                accept();
            }

            // Quick check for bool literal
            if (currentSpelling.toString().equals("true") || 
                currentSpelling.toString().equals("false")) {
                return Token.BOOLEANLITERAL;
            }
            
            return Token.ID;
        }
        return -1;
    }

    private int nextFloatLiterals() {
        if ((currentChar == '.' && Character.isDigit(inspectChar(1)))) {
            // At this point it is safe to say there are more number behind

            // Consume the current dot
            accept();

            // float digit handling
            while (Character.isDigit(currentChar) && currentChar != Token.EOF) {
                accept();
            }

            // handling e case
            if ( (currentChar == 'e' || currentChar == 'E') && 
                ((inspectChar(1) == '+') || (inspectChar(1) == '-')) &&         
                Character.isDigit(inspectChar(2))) {

                // Consuming the 'e'
                accept();

                // Consuming  the '+/-'
                accept();

                // Now the rest is still digits so we continue taking in
                while (Character.isDigit(currentChar) && currentChar != Token.EOF) {
                    accept();
                }
            } else if ( (currentChar == 'e' || currentChar == 'E') && 
                Character.isDigit(inspectChar(1))) {
                // Consuming the 'e'
                accept();
                // Now the rest is still digits so we continue taking in
                while (Character.isDigit(currentChar) && currentChar != Token.EOF) {
                    accept();
                }
            }
            return Token.FLOATLITERAL;
        } else if (
            (currentChar == '.' && Character.isDigit(inspectChar(2)) && (inspectChar(1) == 'e' )) ||
            (currentChar == '.' && Character.isDigit(inspectChar(2)) && (inspectChar(1) == 'E' ))
        ) {
            // Consume the current dot
            accept();

            // Consume the e 
            accept();

            // Now the rest is still digits so we continue taking in
            while (Character.isDigit(currentChar) && currentChar != Token.EOF) {
                accept();
            }
            return Token.FLOATLITERAL;

        }
        return -1;
    }

    private int nextFloatIntLiterals() {       
        // potential float handling
        int f1 = nextFloatLiterals();
        if (f1 != -1) {
            return f1;
        }

        // int or float handling
        else if (Character.isDigit(currentChar)) {
            // Consume the current char
            accept();
            while (Character.isDigit(currentChar) && currentChar != Token.EOF) {
                accept();
            }

            if (currentChar == '.') {
                // float handling
                int f2 = nextFloatLiterals();
                if (f2 != -1) {
                    return f2;
                }
            }
            return Token.INTLITERAL;
        }
        return -1;
    }

    private int nextStringLiterals() {
        if (currentChar == '\"') {
            accept();
            while (currentChar != '\"' && currentChar != Token.EOF) {
                if (currentChar == '\n') {
                    // Eat the new line
                    accept();
                    return Token.STRINGLITERAL;
                }
                // TODO: correct spacing for other escape seq
                else {
                    accept();
                }
            }
            // Consume the left over '\"'
            accept();
            return Token.STRINGLITERAL;
        }
        return -1;
    }

    private int nextToken() {
        // Tokens: separators, operators, literals, identifiers, and keywords
        // Check for seperators
        int sep = nextSeperators();
        if (sep != -1) return sep;

        int ops = nextOperators();
        if (ops != -1) return ops;

        int id = nextIdentifiers();
        if (id != -1 ) return id;

        int fi = nextFloatIntLiterals();
        if (fi != -1 ) return fi;
        
        int s = nextStringLiterals();
        if (s != -1 ) return s;


        // TODO: clean 
        switch (currentChar) {
            // EOF
            case SourceFile.eof:
                currentSpelling.append(Token.spell(Token.EOF));
                return Token.EOF;
            
            // Default: not match prev pattern -> error token
            default:
                break;
        }

        // Consume the error and return it
        accept();
        return Token.ERROR;
    }

    // This only stop when the current char is no longer having pattern of space and comment
    // When it finds white space and comment, it also "consumes" them 
    private void skipSpaceAndComments() {
        while (currentChar != sourceFile.eof) {
            // White space handling
            // white space -> just consume it and move it forward    
            if (currentChar == ' ') {
                ++_charstart;
                ++_charfinish;
                currentChar = sourceFile.getNextChar();
            }

            // tab 
            else if (currentChar == '\t') {
                _charstart = ((_charstart - 1) / 8 + 1) * 8 + 1;
                _charfinish = _charstart;     
                currentChar = sourceFile.getNextChar();
            } 

            // new line 
            else if (currentChar == '\n') {
                // System.out.println("Hi");
                ++_linestart;
                ++_linefinish;
                _charstart = 1;
                _charfinish = 1;                
                currentChar = sourceFile.getNextChar();
            }

            // carriage return 
            else if (currentChar == '\r') {
                // TODO: extra tests later on when identifiers or something can stand before
                // we are assuming carriage increases the char number, remove this line if it is not
                ++_charstart;
                ++_charfinish;

                currentChar = sourceFile.getNextChar();
            }

            // Comment
            else if (currentChar == '/' ) {
                if (inspectChar(1) == '/' ) {
                    // How to skip the whole line? skip until there is no '\n' or eof
                    while (currentChar != '\n' && currentChar != sourceFile.eof) {
                        currentChar = sourceFile.getNextChar();
                    }
                    
                    // Consume the new line so that it wont be re-consumed
                    if (currentChar == '\n') {
                        currentChar = sourceFile.getNextChar();
                    }

                    // Set up cursor new line
                    ++_linestart;
                    ++_linefinish;
                    _charstart = 1;
                    _charfinish = 1;
                }

                else if (inspectChar(1) == '*' ) {
                    // Consume the '*'
                    currentChar = sourceFile.getNextChar();
                    ++_charstart;
                    ++_charfinish;

                    while (currentChar != sourceFile.eof) {
                        // End the closure
                        if (currentChar == '*' && inspectChar(1) == '/') {
                            // Consume the '/'
                            currentChar = sourceFile.getNextChar();
                            ++_charstart;
                            ++_charfinish;

                            // Set it to the char after '/'
                            currentChar = sourceFile.getNextChar();
                            ++_charstart;
                            ++_charfinish;
                            break;
                        } 
                        // New line figured 
                        else if (currentChar == '\n') {
                            currentChar = sourceFile.getNextChar();
                            ++_linestart;
                            ++_linefinish;
                            _charstart = 1;
                            _charfinish = 1;
                        }
                        // TODO: missing case: tab, carriage ie things like  "  /*       */ yo  "
                        // Else it is just either char by char white space
                        else {
                            currentChar = sourceFile.getNextChar();
                            ++_charstart;
                            ++_charfinish;
                        }
                    }

                } 
                else {
                    // This means that this can be division or 
                    // Something else, we dont care and we skip it
                    // This function only consumes actual valid comment
                    // throw new RuntimeException("Breakpoint");
                    // throw new RuntimeException("Breakpoint");
                    // System.out.println("Infinite\n");
                    return;
                }
            }
            // No comment pattern found - just return as there is notthing left to skip
            else {
                return;
            }
        }
    }

    public Token getToken() {
        Token token;
        int kind;

        skipSpaceAndComments();

        // if it is eof, we directly return it
        // TODO: refractor so that this one can go inside the switch above
        if (currentChar == sourceFile.eof) {
            // System.out.println("End of file reached!");
            sourcePos = new SourcePosition(_linestart, _linefinish, 1, 1);
            token = new Token(Token.EOF, "$", sourcePos);
            if (debug) {
                System.out.println(token);
            }
            return token;
        } 

        // After skip space and comments, current char should be the char belong to this current token
        currentSpelling = new StringBuilder();
        int originalCharStart = _charstart;
        int originalLineStart = _linestart;

        // You need to record the position of the current token somehow
        kind = nextToken();

        sourcePos = new SourcePosition(originalLineStart, _linestart, originalCharStart, _charstart - 1);

        token = new Token(kind, currentSpelling.toString(), sourcePos);

   	    // * do not remove these three lines below (for debugging purposes)
        if (debug) {
            System.out.println(token);
        }
        return token;
    }
}
