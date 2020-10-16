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
  val SP: Temp.temp
  val ZERO: Temp.temp

  (* Register Mapping  Selection *)
  type register = string
  val string: (S.symbol * string) -> string
  val tempMap: register Map.map
  val registers: register list

  val procEntryExit1 : frame * Tree.stm -> Tree.stm
  val procEntryExit3 : frame * Assem.instr list * int  -> {prolog: string, body: Assem.instr list, epilog: string}

  (* Additions *)
  val writeFrag: TextIO.outstream * frag -> unit
  val localsAllocated: frame -> int
  val getRegName: Temp.temp -> register
  val calleesaves: Temp.temp list 
  val callersaves: Temp.temp list 
  val specialregs: Temp.temp list
  val argregs: Temp.temp list
  val numArgRegs: int
  val calldefs: Temp.temp list
end
