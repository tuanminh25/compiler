# Compiler

This project implements a compiler for the VC programming language, built incrementally across five stages. Each stage is developed by hand, without relying on generator tools such as JFlex or CUP, to provide a deeper understanding of how each compiler phase works internally.

The project is broken up into five smaller parts:

1. **scanner**: reads characters from a VC program and produces a stream of tokens (lexical analysis)

2. **recogniser**: reads the token stream and parses the program to check for syntactic correctness only

3. **parser**: extends the recogniser to build an abstract syntax tree (AST) representing the program's structure

4. **semantics**: performs static semantic checks at compile-time over the AST

5. **generator**: generates Jasmin assembly code from the analyzed AST, producing executable JVM bytecode

## Scanner

This project implements a **scanner (lexical analyzer)** for the VC programming language, built entirely by hand rather than relying on generator tools such as JFlex or CUP.

The scanner reads raw source code character-by-character and converts it into a structured stream of **tokens**, forming the foundational first stage of a compiler pipeline. This token stream serves as the input for subsequent stages such as parsing and semantic analysis.

By implementing the lexer manually, the project demonstrates a low-level understanding of finite automata, character classification, and tokenization logic that underpins how compilers and interpreters process source code.

## Recogniser

This stage implements a **predictive recursive-descent parser** for the VC language. At this point, the parser checks only the **syntactic correctness** of the input program — building the Abstract Syntax Tree (AST) is left for the next stage (the parser proper).

Because this stage only recognises whether the input belongs to the language without producing any further output structure, it is referred to in language theory and computational complexity as a **recogniser**.

As in C, C++, Java, and many languages before VC, the `if` statement is subject to the **dangling-else problem**. The recogniser resolves this ambiguity by always matching each `else` with the closest preceding unmatched `then`.

The recogniser calls the hand-built scanner from the previous stage to obtain its token stream. (A reference scanner implementation is also provided as a fallback in case the custom scanner is incomplete.)

At this stage, the compiler — consisting of the scanner and recogniser — behaves as follows:

- If the input program is **syntactically legal**, the compiler prints, as its final output line:
  ```
  Compilation was successful.
  ```
- If the input program is **syntactically illegal**, the compiler prints, as its final output line:
  ```
  Compilation was unsuccessful.
  ```
  Before this final message, the recogniser prints meaningful error messages describing the syntax errors it detects.

## Parser

This stage extends the recogniser built previously into a full **parser** capable of constructing an **Abstract Syntax Tree (AST)** for a given VC program, in addition to checking syntactic correctness.

The parser follows the same VC grammar used in the recogniser stage. If the input program is syntactically legal, the parser builds the AST exactly as specified by the AST construction rules for the VC language. If the program is syntactically illegal, the parser may print an error message and stop, without needing to complete the AST.

The resulting AST forms the structural representation of the program that subsequent stages — semantic analysis and code generation — will operate on.

## Semantics

This stage implements **semantic (contextual) analysis** for VC programs, verifying that a syntactically valid program also conforms to the language's context-sensitive constraints as defined in the VC Language Definition.

Semantic analysis addresses two categories of constraints:

- **Scope rules**: govern declarations and applied occurrences of identifiers.
- **Type rules**: govern how types are inferred for language constructs and whether each construct's type is valid in its context.

Accordingly, this stage combines two subphases into a single pass:

- **Identification**: applies the scope rules to link each applied occurrence of an identifier to its corresponding declaration.
- **Type checking**: applies the type rules to infer the type of each construct and verify it against the type expected in its context.

This is implemented as a `Checker` visitor class, conforming to the `VC.ASTs.Visitor` interface, which traverses the AST built in the previous stage in depth-first order, performing identification and type checking simultaneously. Ill-typed constructs are reported with appropriate error messages.

At this stage, the compiler — consisting of the scanner, parser, and semantic analyser — announces success by printing:

```
Compilation was successful.
```

or, if any lexical, syntactic, or semantic error is found:

```
Compilation was unsuccessful.
```

## Generator

This final stage implements the **code generator** for VC, completing the compiler pipeline.

This stage involves an `Emitter` visitor class, conforming to the `VC.ASTs.Visitor` interface, which traverses the decorated AST (the AST produced and annotated by the semantic analysis stage) and incrementally emits **Jasmin assembly instructions**. Both the traversal order and the instructions emitted for each language construct follow the standard code generation templates for VC.

At this stage, the complete compiler — consisting of the scanner, parser, semantic analyser, and code generator — behaves as follows:

- If no lexical, syntactic, or semantic error is found, the compiler prints:
  ```
  Compilation was successful.
  ```
  and writes the generated Jasmin assembly code to a file.
- Otherwise, the compiler prints:
  ```
  Compilation was unsuccessful.
  ```