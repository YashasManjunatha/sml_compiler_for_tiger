# Lexical Analysis

> Duke University\
> CS 553: Compiler Construction\
> Professor Andrew Hilton\
> Spring 2020

### Team
Yashas Manjunatha (ym101)\
Trishul Nagenalli (tn74)\
Jason Wang (jw502)


## Comments

Since Tiger supports non-symmetric nested comments, we could not identify comments using regex alone. We had to keep an integer pointer tracking the number of comments we had opened. When we first see ``/*`` in the program we enter the ``COMMENT`` state and set the ``openComments := 1``. In our ``COMMENT`` state, we increment our tracker every time we see ``/*`` and decerement every time we see ``*/``. When our ``openComments`` variable reaches 0, we re-enter the ``INITIAL`` state and match valid Tiger Code. All characters inside comments are caught with "." except whitespace characters. New line characters are treated the same way they are in code - the line number is incrememnted and the line position array is updated. Other white space characters (\f, \r, " ", \t) are treated as any other character and ignored.


## Strings

We are supporting a limited number of escape sequences in strings as well as multiline strings. We keep a separate state in our parser for strings as well as two variables that we side-effect as we parse the string. The first variable is ``stringBuffer``, which keeps track of the character sequence input to the program with all escape sequences correctly translated. The second variable is ``stringLength`` which stores the length of the input sequence we saw - increasing by one when see a standard character like "a" and by two when we see an escape sequence like "\n" for example. When we see a quote character already inside of a string, we exit the string state and return a String token consisting of the string in ``stringBuffer`` and a position range of ``yypos - stringLength`` to ``yypos + 1``


## Error Handling

We use the provided ErrorMsg structure to throw errors. The following are the instances in which an error is thrown:
* Unclosed Comment at EOF
* Unclosed String at EOF
* Illegal ASCII Code in a String (>255)
* Illegal New Line in a String without Use of Multiline String Syntax
* Illegal Escape Sequence in a String
* Illegal Backslash in a String
* Illegal Character in the Tiger Program

## End of File Handling

When the end of the input stream is reached, the ML-Lex lexer calls the function eof. In this function we check if there are any open comments (by checking if ``openComments != 0``) or if there are any open strings (by checking if the ``stringLength != 0``) and appropriately return an error message. At the end of the function, an EOF token is generated.

## Other Interesting Stuff

In order to ensure that all variable values (including the values used for ErrorMsg) are reset everytime we attempt to parse a file, we created a function called reset in our lexer that resets all the values and calls ``ErrorMsg.reset();``. This reset function is then called in driver.sml in the parse function, so that everytime the parse function is called, all the variable values are reset.
