# Parsing and Abstract Syntax Tree (AST)

> Duke University\
> CS 553: Compiler Construction\
> Professor Andrew Hilton\
> Spring 2020

### Team
Yashas Manjunatha (ym101)\
Trishul Nagenalli (tn74)\
Jason Wang (jw502)


## Special Things

### Testing/Printing the AST

We use the following command to print the resulting AST after parsing a test file. 

```
PrintAbsyn.print(TextIO.openOut("out.txt"), Parse.parse("tests/queens.tig"));
```

This command leverages the print function in the `PrintAbsyn` structure in the `prabsyn.sml` file. The AST is outputted into `out.txt`.



### Lvalue Reduction vs Array Creation

We want to make note of some things we would be confused about if we later looked at our tiger grammar.

The first major conflict we ran into as handling lvalues. We had two expressions that our grammar could not properly act in this conflict.

`ID . LBRACK exp RBRACK OF exp` <- Array Creation
`ID . LBRACK exp RBRACK`        <- Array Subscripting

When subscripting an array, we need to reduce the ID to an lvalue but we must keep the ID if we are going to do Array creation. The problem is we do not know if we should shift (for array creation) or reduce (for array subscripting) when at the dot without seeing if there is an of later. We navigated around this by creating a lvalue tail object. The lvalue tail can be any of `['', 'DOT ID', 'LBRACK exp RBRACK']` This effectively gives us a buffer to see if an `OF` symbol is present after the right bracket before we make the decision to reduce.

Another problem presented to us however with this tail method is our inability to know what simple variable our field or subscript variables derive from. For example, we do not see the symbol `A` in the lvariable `A.B` using the tail method because the tail only sees `.B`. We resolved this by having each tail return a function that will produce the appropriate variable type given its parent. The very first ID has no parent - which is why we treat it as a simple variable. `A.B["C"].D` is constructed through a series of recursive calls on these variable constructor functions.


### Function and Type Grouping for Mutual Recursion
One of our main difficulties with parsing multiple function and type declarations in let-in blocks was properly grouping these functions and types into a single `A.TypeDec` with multiple type records, or a single `A.FunctionDec` with multiple function records.

In order to solve this problem, we designed a special terminal called `RECURSIVE_UNION` that has a precedence that is as low as possible. We gave this precedence to our rule which reduces a single function/type declaration into a list of declarations, which ensures that it executes as late as possible. This allows us to ensure that every function/type record in each block is reduced together into one big group *only after* each declaration has been reduced to records.

Our grouping rules work as follows: each function/type declaration is reduced to a function/type record, and then the parser moves on to the next declaration. After each declaration in the block has been reduced, the last declaration is turned into a list, and then the parser recursively adds each declaration beforehand onto the list, resulting in a list of declarations. Finally, this list of function/type declarations is turned into an `A.FunctionDec` or `A.TypeDec`.

As a result, the final function/type block is only be reduced to a list of function/type declarations once the end of a group of functions is reached, and only thereafter is that list turned into an `A.FunctionDec` or `A.TypeDec`.
