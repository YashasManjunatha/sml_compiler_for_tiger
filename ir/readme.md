# Typechecker

> Duke University\
> CS 553: Compiler Construction\
> Professor Andrew Hilton\
> Spring 2020

### Team
Yashas Manjunatha (ym101)\
Trishul Nagenalli (tn74)\
Jason Wang (jw502)

This project was very challenging but provided excellent insight into the design of good type systems.

Note: Lexer line numbers do not show the correct values. We developed most of the lexer with the tiger.lex.smlapel file but discovered that it could not handle break statements and switched over to ours at the last second. While the line numbers are not correct, we are confident all of the type checking is. Please overwrite tiger.lex.sml with the content of tiger.lex.smlapel to get line numbers.

### Special Things

#### Checking Breaks Inside Loops
We use a global integer pointer while performing our type-check that keeps track of how deep inside of loops we are. If we see that we are at 0 loops, we throw an error if we see break. Otherwise, we allow it.

#### Mutually Recursive Types and Functions
We followed Appel's recommendation for mutually recursive types and functions by inserting headers into the type or variable environement and then evaluating the right hand side of type expressions, or bodies of function expressions.



