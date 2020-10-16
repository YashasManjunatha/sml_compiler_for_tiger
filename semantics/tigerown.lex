type svalue = Tokens.svalue
type pos = int
type ('a,'b) token = ('a,'b) Tokens.token
type lexresult = (svalue,pos) token

val lineNum = ErrorMsg.lineNum
val linePos = ErrorMsg.linePos
val openComments = ref 0;
val stringBuffer = ref "";
val stringLength = ref 0;


fun reset() = (ErrorMsg.reset(); openComments := 0; stringLength := 0; stringBuffer := "");

fun err(p1,p2) = ErrorMsg.error p1
fun eof() = 
    let 
        val pos = hd(!linePos) 
    in 
        (if !openComments <> 0 then ErrorMsg.error pos ("Unclosed Comment") else ());
        (if !stringLength <> 0 then ErrorMsg.error pos ("Unclosed String") else ());
        reset();
		Tokens.EOF(pos, pos)
   end

fun getStringLength() = 
    let
        val sl = !stringLength;
    in
        (stringLength := 0; stringBuffer := "");
        sl
    end

fun convertASCII(s) = String.str(Char.chr(valOf(Int.fromString(s))))

fun countNewLines(s) = foldl (fn(a, b) => (if a = #"\n" then b + 1 else b)) 0 (explode(s))

%%
%header (functor TigerLexFun(structure Tokens: Tiger_TOKENS));
%s COMMENT STRING;

%% 

<INITIAL> type      => (Tokens.TYPE(yypos, yypos+4));
<INITIAL> var       => (Tokens.VAR(yypos,yypos+3));
<INITIAL> function  => (Tokens.FUNCTION(yypos, yypos+8));
<INITIAL> break     => (Tokens.BREAK(yypos, yypos+5));
<INITIAL> of        => (Tokens.OF(yypos, yypos+2));
<INITIAL> end       => (Tokens.END(yypos, yypos+3));
<INITIAL> in        => (Tokens.IN(yypos, yypos+2));
<INITIAL> nil       => (Tokens.NIL(yypos, yypos+3));
<INITIAL> let       => (Tokens.LET(yypos, yypos+3));
<INITIAL> do        => (Tokens.DO(yypos, yypos+2));
<INITIAL> to        => (Tokens.TO(yypos, yypos+2));
<INITIAL> for       => (Tokens.FOR(yypos, yypos+3));
<INITIAL> while     => (Tokens.WHILE(yypos, yypos+5));
<INITIAL> else      => (Tokens.ELSE(yypos, yypos+4));
<INITIAL> then      => (Tokens.THEN(yypos, yypos+4));
<INITIAL> if        => (Tokens.IF(yypos, yypos+2));
<INITIAL> array     => (Tokens.ARRAY(yypos, yypos+5));
<INITIAL> ":="      => (Tokens.ASSIGN(yypos, yypos+2));
<INITIAL> "|"       => (Tokens.OR(yypos, yypos+1));
<INITIAL> "&"       => (Tokens.AND(yypos, yypos+1));
<INITIAL> ">="      => (Tokens.GE(yypos, yypos+2));
<INITIAL> ">"       => (Tokens.GT(yypos, yypos+1));
<INITIAL> "<="      => (Tokens.LE(yypos, yypos+2));
<INITIAL> "<"       => (Tokens.LT(yypos, yypos+1));
<INITIAL> "<>"      => (Tokens.NEQ(yypos, yypos+2));
<INITIAL> "="       => (Tokens.EQ(yypos, yypos+1));
<INITIAL> "/"       => (Tokens.DIVIDE(yypos, yypos+1));
<INITIAL> "*"       => (Tokens.TIMES(yypos, yypos+1));
<INITIAL> "-"       => (Tokens.MINUS(yypos, yypos+1));
<INITIAL> "+"       => (Tokens.PLUS(yypos, yypos+1));
<INITIAL> "."       => (Tokens.DOT(yypos, yypos+1));
<INITIAL> "}"       => (Tokens.RBRACE(yypos, yypos+1));
<INITIAL> "{"       => (Tokens.LBRACE(yypos, yypos+1));
<INITIAL> "]"       => (Tokens.RBRACK(yypos, yypos+1));
<INITIAL> "["       => (Tokens.LBRACK(yypos, yypos+1));
<INITIAL> ")"       => (Tokens.RPAREN(yypos, yypos+1));
<INITIAL> "("       => (Tokens.LPAREN(yypos, yypos+1));
<INITIAL> ";"       => (Tokens.SEMICOLON(yypos, yypos+1));
<INITIAL> ":"       => (Tokens.COLON(yypos, yypos+1));
<INITIAL> ","       => (Tokens.COMMA(yypos,yypos+1));
<INITIAL> [0-9]+    => (Tokens.INT(valOf(Int.fromString yytext), yypos, yypos + size yytext)); 
<INITIAL> [a-zA-Z][a-zA-Z0-9_]* => (Tokens.ID(yytext, yypos, yypos + size yytext));

<INITIAL, COMMENT> " "|\t   => (continue());
<INITIAL, COMMENT> \n|\012  => (lineNum := !lineNum+1; linePos := yypos :: !linePos; continue());
<INITIAL, COMMENT> \r       => (continue());


<INITIAL> \/\*      => (YYBEGIN(COMMENT); openComments := 1; continue());
<COMMENT> \/\*      => (openComments := !openComments + 1; continue());
<COMMENT> \*\/      => (openComments := !openComments - 1; if !openComments = 0 then YYBEGIN(INITIAL) else (); continue());
<COMMENT> .         => (continue());

<INITIAL> \"        => (YYBEGIN(STRING); stringLength := 1; stringBuffer := ""; continue()); 
<STRING> \"         => (YYBEGIN(INITIAL); Tokens.STRING(!stringBuffer, yypos - getStringLength(), yypos+1)); 
<STRING> \\n        => (stringLength := !stringLength + 2; stringBuffer := !stringBuffer ^ "\n"; continue()); 
<STRING> \\t        => (stringLength := !stringLength + 2; stringBuffer := !stringBuffer ^ "\t"; continue());
<STRING> \\[0-9]{3} => (stringLength := !stringLength + 4; if valOf(Int.fromString(String.extract(yytext,1,NONE))) > 255 then ErrorMsg.error yypos ("illegal ascii code " ^ yytext) else stringBuffer := !stringBuffer ^ convertASCII(String.extract(yytext,1, NONE)); continue());
<STRING> \\\"       => (stringLength := !stringLength + 2; stringBuffer := !stringBuffer ^ "\""; continue());
<STRING> \\\\       => (stringLength := !stringLength + 2; stringBuffer := !stringBuffer ^ "\\"; continue());
<STRING> \\[\s\t\n\012\r]+\\ => (stringLength := !stringLength + size yytext; lineNum := !lineNum + countNewLines(yytext); continue());
<STRING> \n|\012    => (stringLength := !stringLength + 1; lineNum := !lineNum+1; linePos := yypos :: !linePos; ErrorMsg.error yypos ("Illegal New Line in String"); continue());
<STRING> \r         => (ErrorMsg.error yypos ("Illegal New Line in String"); continue());

<STRING> \\.        => (ErrorMsg.error yypos ("Illegal Escape Sequence: " ^ yytext); continue());
<STRING> \\         => (ErrorMsg.error yypos ("Illegal Backslash in String"); continue());
<STRING> .          => (stringBuffer := !stringBuffer ^ yytext ; stringLength := !stringLength + 1; continue());

<INITIAL> .         => (ErrorMsg.error yypos ("Illegal Character: " ^ yytext); continue());
