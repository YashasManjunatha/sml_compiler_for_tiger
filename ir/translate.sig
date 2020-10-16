signature TRANSLATE = 
sig
  type level
  type exp
  type access (*notthesameas Frame.access*)
  
  val outermost : level
  val newLevel : {parent: level, name: Temp.label,
  formals: bool list} -> level 

  structure Frame : FRAME
  val formals: level -> access list
  val allocLocal: level -> bool -> access 
  val procEntryExit : {level: level, body: exp} -> unit
  val getResult : unit -> Frame.frag list

  (* IR Functions *)
  val simpleVar: access * level -> exp
  val subscriptVar: exp * exp -> exp
  val fieldVar: exp * exp -> exp
  val intIR: int -> exp
  val nilIR: unit -> exp
  val recordIR: (string * exp) list -> exp
  val transSeq: exp list  -> exp
  val transBinop: Absyn.oper * exp * exp -> exp
  val transRelop: Absyn.oper * exp * exp -> exp
  val transCall: Symbol.symbol * exp list -> exp
  val transLet: exp list * exp -> exp
  val transIf: exp * exp * exp -> exp
  val transBrk: Temp.label -> exp
  val transWhile: exp * exp * Temp.label -> exp
  val transFor: exp * exp * exp * exp * Temp.label -> exp
  val transAssign: exp * exp -> exp
  val transArrayinit: exp * exp -> exp
  val transStringRelop: Absyn.oper * exp * exp -> exp
  val transString: string -> exp

  (* Additions *)
  val str: level -> string
  val resetFragList: unit -> unit
end
