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
  
  (* Register *)
  val FP: Temp.temp   
  val RV: Temp.temp
  val procEntryExit1 : frame * Tree.stm -> Tree.stm

  (* Instruction Selection *)
  type register
  val string: (S.symbol * string) -> string
  val tempMap: register Temp.Table.table
  val procEntryExit2 : frame * Assem.instr list -> Assem.instr list

  (* Additions *)
  val writeFrag: TextIO.outstream * frag -> unit
  val bottomOffset: frame -> int
end

structure MipsFrame = 
  struct
    datatype access = InFrame of int | InReg of Temp.temp
    type register = string
    datatype frame = FRAME of { name: Temp.label, 
                   formals: access list, 
                   localsAllocated: int ref,
                   bottomOffset: int ref }
    val wordSize = 4
    val numArgRegs = 4

    (* Register naming *)
    val ZERO = Temp.newtemp() (* $0 Program uses *)
    val AT = Temp.newtemp()   (* $1 Program can't use, reserved for assembler *)
    val RV = Temp.newtemp()   (* $2 Program uses *)
    val RV2 = Temp.newtemp()  (* $3 Program doesn't use by design? *)
    val K1 = Temp.newtemp()   (* $26 Program can't use (reserved for kernel) *)
    val K2 = Temp.newtemp()   (* $27 Program can't use (reserved for kernel) *)
    val GP = Temp.newtemp()   (* $28 Program might use? Pointer to global mem*)
    val FP = Temp.newtemp()   (* $29 Program doesn't use *)
    val SP = Temp.newtemp()   (* $30 Program uses *)
    val RA = Temp.newtemp()   (* $31 Program uses *)

    val calleesaves = List.tabulate(8, fn(i) => Temp.newtemp())
    val callersaves = List.tabulate(10, fn(i) => Temp.newtemp())
    val specialregs = [ZERO, AT, RV, RV2, K1, K2, GP, FP, SP, RA]
    val argregs  = List.tabulate(numArgRegs, fn(i) => Temp.newtemp())
    val calldefs = argregs @ callersaves @ [RV, RA, FP, SP]
    val tempMap = foldl
      (fn( (temp, str), tab) => Temp.Table.enter(tab, temp, str))
      Temp.Table.empty (
      [
        (ZERO, "$r0"),
        (AT, "$at"),
        (RV, "$v0"),
        (RV2, "$v1"),
        (K1, "$k1"),
        (K2, "$k2"),
        (GP, "$gp"),
        (FP, "$fp"),
        (SP, "$sp"),
        (RA, "$ra")
       ] @ 
       (List.mapi( fn(i, item) => (item, "$a" ^ Int.toString i)) argregs)
       )
    fun getRegName t = (case Temp.Table.look(tempMap, t) of 
                                       SOME(s) => s
                                     | NONE => "$" ^ Temp.makestring t)


    datatype frag = PROC of {body: Tree.stm, frame: frame} 
                  | STRING of Temp.label * string


    fun writeFrag (out, frag) = case frag of 
                                  PROC{body, frame=FRAME{name, ...}} => 
                                  (TextIO.output(out, "\nNew Frame: "^
                                  Symbol.name(name) ^ "\n");
                                  Printtree.printtree(out, body))
                                | STRING(a, b) => TextIO.output (out, Symbol.name a ^ b ^
                                "\n")
    
    fun newFrame{name: Temp.label, formals: bool list} = 
      let
        fun mapToFrame([], complete, _) = complete 
          | mapToFrame(a::l, complete, n) = mapToFrame(l, complete @
          [InFrame(wordSize * n)], n+1) (* Can do this because we assume all paramaters escape *)
      in FRAME{name=name, 
          formals=mapToFrame (formals, [], 0),
          localsAllocated=ref 0,
          bottomOffset=ref 0 }
      end

    fun name (FRAME{name=n, ...}:frame): Temp.label = n

    fun formals (FRAME{formals=f, ... }:frame): access list = f

    fun bottomOffset(FRAME{bottomOffset, ...}) = !bottomOffset
    
    fun allocLocal (FRAME{bottomOffset, ...}:frame) (isInFrame) = 
      if isInFrame 
      then (bottomOffset := !bottomOffset - wordSize; InFrame(!bottomOffset))
      else (InReg(Temp.newtemp()))

    fun exp (a:access) (fp:Tree.exp) = 
      case a of 
           InFrame(x) => Tree.MEM(Tree.BINOP(Tree.PLUS, fp, Tree.CONST x))
         | InReg(x) => Tree.TEMP x

    fun string (lab, s) = S.name lab ^ "(\"" ^ s ^ "\")"
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
   
    fun procEntryExit1(frame:frame, body:Tree.stm):Tree.stm = Tree.SEQ([Tree.LABEL (name frame), body])

    fun procEntryExit2(frame, body) =
      body @ [Assem.OPER{
                assem="",
                src = specialregs@calleesaves,
                dst = [], 
                jump= SOME[]}]

    fun procEntryExit3(FRAME{name,formals, localsAllocated, bottomOffset}, body) = {
        prolog = "PROCEDURE " ^ Symbol.name name ^ "\n", 
        body = body,
        epilog = "END " ^ Symbol.name name ^ "\n"}

    fun procEntryExit(f:frame, t:Tree.stm):unit = ()
          
  end
