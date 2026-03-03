# Compiler

The project is broken up into five smaller parts:  

1. scanner: read characters and produces tokens
2. recogniser: read tokens and parse the program only for syntactic correctness
3. parser: extend the parser to build an abstract syntax tree (AST) static
4. semantics: check semantics at compile-time code
5. generator -- generate Java bytecode
