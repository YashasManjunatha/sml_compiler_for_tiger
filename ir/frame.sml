(* Todos: Optional parts specified in Chapter 6 that have to do with
 * non-escaping parameters and having more than k parameters 
 * The reason this works at all with fewer than k parameters and assuming all
 * parameters escape/are passed by stack is because how arguments are passed are
 * determined by the implementation of Tree's CALL. Caller is responsible after
 * all for allocating space on stack for arguments 
 * *)
signature FRAME =
sig 
  type frame
  type access
  val newFrame : {name: Temp.label, formals: bool list} -> frame
  val name : frame -> Temp.label
  val formals : frame -> access list
  val allocLocal : frame -> bool -> access
  
  (* From Translate Chapter *)
  datatype frag = PROC of {body: Tree.stm, frame: frame}
                | STRING of Temp.label * string
  val wordSize: int
  val exp : access -> Tree.exp -> Tree.exp
  val externalCall: string * Tree.exp list -> Tree.exp
  val FP: Temp.temp (* Register *)
  val RV: Temp.temp
  val procEntryExit : frame * Tree.stm -> Tree.stm

  (* Additions *)
  val writeFrag: TextIO.outstream * frag -> unit
end

structure MipsFrame : FRAME = 
struct
  datatype access = InFrame of int | InReg of Temp.temp
  type frame = { name: Temp.label, 
                 formals: access list, 
                 localsAllocated: int ref,
                 bottomOffset: int ref }
  val wordSize = 4
  val FP = Temp.newtemp()
  val RV = Temp.newtemp()
  datatype frag = PROC of {body: Tree.stm, frame: frame} 
                | STRING of Temp.label * string

  fun writeFrag (out, frag) = case frag of 
                                PROC{body, frame} => 
                                (TextIO.output(out, "\nNew Frame: "^
                                Symbol.name(#name frame) ^ "\n");
                                Printtree.printtree(out, body))
                              | STRING(a, b) => TextIO.output (out, Symbol.name
                              a ^ " " ^ b ^
                              "\n")
  
  fun newFrame{name: Temp.label, formals: bool list} = 
    let
      fun mapToFrame([], complete, _) = complete 
        | mapToFrame(a::l, complete, n) = mapToFrame(l, complete @
        [InFrame(wordSize * n)], n+1) (* Can do this because we assume all paramaters escape *)
    in {name=name, 
        formals=mapToFrame (formals, [], 0),
        localsAllocated=ref 0,
        bottomOffset=ref 0 }
    end

  fun name ({name=n, ...}:frame): Temp.label = n

  fun formals ({formals=f, ... }:frame): access list = f
  
  fun allocLocal ({bottomOffset, ...}:frame) (isInFrame) = 
    if isInFrame 
    then (bottomOffset := !bottomOffset - wordSize; InFrame(!bottomOffset))
    else (InReg(Temp.newtemp()))

  fun exp (a:access) (fp:Tree.exp) = 
    case a of 
         InFrame(x) => Tree.MEM(Tree.BINOP(Tree.PLUS, fp, Tree.CONST x))
       | InReg(x) => Tree.TEMP x

  (* returns Temp.label *)
  (* fun string (lit) = 
    let 
      val length = String.size lit
      val lab = Temp.newlabel()
      val chars = String.explode lit
      fun insertChar (f, i) = R.MOVE(R.BINOP(R.PLUS, R.MEM(R.NAME(lab)), R.CONST(i*wordSize)), R.CONST(Char.ord f))
      fun insertChars ([], i) = insertChar ("",i)
        | insertChars (f::[], i) = insertChar (f,i)
        | insertChars (f::l, i) = R.SEQ [insertChar (f,i), insertChars(l, i+1)]
    in
      R.ESEQ(
        R.SEQ [
          R.MOVE(R.MEM(R.NAME lab), externalCall("malloc", [R.CONST((length+1)*wordSize)])),
          R.SEQ [
            R.MOVE(
              R.MEM(R.NAME(lab)), 
              R.CONST length),
            insertChars (chars, 1)]
        ],
        lab
      )
    end *)

  (* may need to be adjusted to account for  static links *)
  fun externalCall (s, args) = Tree.CALL(Tree.NAME(Temp.namedlabel s), args)

  fun procEntryExit(f:frame, t:Tree.stm):Tree.stm = t

end
