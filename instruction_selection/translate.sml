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
  val transInt: int -> exp
  val transNil: unit -> exp
  val transRecord: (string * exp) list -> exp
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

structure Translate : TRANSLATE = struct 
  structure Frame = MipsFrame
  structure ERR = ErrorMsg
  structure R = Tree

  datatype level = NODE of {parent: level, frame: Frame.frame, uniq: unit ref}
                 | ROOT
  val outermost = ROOT

  type access = (level * Frame.access)
  datatype exp = Ex of R.exp 
               | Nx of R.stm
               | Cx of Temp.label * Temp.label -> R.stm

  val fragList = ref ([]:Frame.frag list)
  fun getResult () = !fragList
  fun resetFragList () = fragList := []

  val impossible = Temp.namedlabel "IMPOSSIBLE"
  val impossibleExp = R.NAME (impossible)
  val impossibleStm = R.LABEL(impossible)
  
  fun newLevel {parent: level, name: Temp.label, formals: bool list} =
    NODE({parent=parent, 
          frame=Frame.newFrame{name=name, formals=(true::formals)},
          uniq= ref ()})

  fun formals ROOT = []
    | formals (NODE{parent, frame, uniq}) = 
        map (fn(a) => (NODE{parent=parent, frame=frame, uniq=uniq}, a)) (Frame.formals frame)
  
  fun allocLocal (ROOT) (a:bool) = 
        (ERR.error 0 "IMPOSSIBLE: Trying to allocate variable at level of Tiger runtime library";
         let val tempf = Frame.newFrame{name=Symbol.symbol "IMPOSSIBLE", formals=[]}
         in (NODE{parent=ROOT, frame=tempf, uniq=ref ()}, Frame.allocLocal tempf a) end)
    | allocLocal (NODE{parent, frame, uniq}:level) (a:bool) = (NODE{parent=parent, frame=frame, uniq=uniq}, Frame.allocLocal frame a)

  fun str(NODE({parent, frame, ...})) = str(parent) ^ " -> [" ^ Int.toString(Frame.bottomOffset frame) ^ "] " ^ Symbol.name(Frame.name frame)
    | str(ROOT) = "ROOT"

  fun seq (l) = R.SEQ(l)

  and unEx (Ex e) = e
    | unEx (Cx genstm) =
        let 
          val r = Temp.newtemp()
          val t = Temp.newlabel() and f = Temp.newlabel()
        in 
          R.ESEQ(seq[ R.MOVE(R.TEMP r, R.CONST 1), 
                      genstm(t,f),
                      R.LABEL f,
                      R.MOVE(R.TEMP r, R.CONST 0), 
                      R.LABEL t ],
          R.TEMP r)
        end
    | unEx (Nx s) = R.ESEQ(s, R.CONST 0)
   
  and unCx(Cx c) = c
    | unCx(Nx n) = (ERR.error 0 "Should never occur in a well-typed Tiger Program"; unCx(Ex(R.CONST 1)))
    | unCx(Ex(R.CONST 0)) = (fn(t, f) => R.JUMP(R.NAME f, [f]))
    | unCx(Ex(R.CONST 1)) = (fn(t, f) => R.JUMP(R.NAME t, [t]))
    | unCx(Ex e) = fn(t, f) => R.CJUMP(R.NE, R.CONST 0, e, t, f)
  
  and unNx(Ex e) = R.EXP e
    | unNx(Nx n) = n
    | unNx (c) = unNx(Ex(unEx c))
  
  fun procEntryExit{level=ROOT, ...} = ERR.error 0 "Cannot declare a function at ROOT"
    | procEntryExit{level=NODE{frame, ...}, body=body} = 
        let 
          val fullFunc  = Frame.procEntryExit1(
                          frame, 
                          Tree.MOVE(Tree.TEMP Frame.RV, unEx(body))
                        )
        in
          fragList := Frame.PROC{body=fullFunc, frame=frame}::(!fragList)
        end

  fun followSL((NODE{parent=targetParent, frame=targetFrame, uniq=targetRef}, a):access, 
                NODE{parent=parent, uniq=currentRef, frame=currentFrame, ...}, 
                fp:R.exp) =
                (
                  if targetRef = currentRef
                  then Frame.exp a fp
                  else followSL((NODE{parent=targetParent, frame=targetFrame, uniq=targetRef},a),
                                parent,
                                R.MEM(fp))
                )
    | followSL(_, _, _) = (ERR.error 0 "Impossible Static Link Access"; impossibleExp)

  fun simpleVar (decAccess:access, callLevel:level):exp = 
    Ex(followSL(decAccess, callLevel, R.TEMP Frame.FP))

  fun subscriptVar(var:exp, offset:exp) = 
    Ex(R.MEM(R.BINOP(R.PLUS, unEx var, R.BINOP(R.MUL, unEx offset, R.CONST(Frame.wordSize)))))
  
  fun fieldVar (var:exp, offset:exp) = 
    Ex(R.MEM(R.BINOP(R.PLUS, unEx var, R.BINOP(R.MUL, unEx offset, R.CONST(Frame.wordSize)))))

  fun transInt(n) = Ex(R.CONST n)

  fun transCall(l, args) = Ex(R.CALL(R.NAME l, map unEx args))

  fun transNil(n) = Ex(R.MEM (R.CONST 0))
  
  fun transSeq(l) = 
    let 
      fun seqIR([], []) = Nx(R.SEQ [])
        | seqIR(l, [e]) = Ex(R.ESEQ(R.SEQ(map unNx l), unEx(e)))
        | seqIR(first, e::last) = seqIR(first @ [e], last)
    in
      seqIR([], l)
    end
  
  (* TODO: need to include string function in Frame *)
  fun transString (lit) = 
      let val lab = Temp.newlabel()
        (* val lab = Frame.string lit *)
      in
        fragList := Frame.STRING(lab, lit)::(!fragList);
        Ex(R.NAME lab)
      end

  (* fields = (string * Translate.exp * A.pos) *)
  fun transRecord (fields) = 
      let val allocSize = List.length(fields) * Frame.wordSize
          val recordPtr = R.TEMP(Temp.newtemp())
          fun allocField (sym, exp, i) = R.MOVE(R.MEM(
                                                R.BINOP(
                                                  R.PLUS, 
                                                  recordPtr, 
                                                  R.CONST(i * Frame.wordSize))), 
                                                unEx exp)
          fun createSeq ((sym, exp)::[], i) = allocField(sym, exp, i)
            | createSeq ((sym, exp)::l, i) = R.SEQ [allocField(sym, exp, i), createSeq(l, i+1)]
      in
          Ex(R.ESEQ(
            R.SEQ [R.MOVE(recordPtr, Frame.externalCall("malloc", [R.CONST(allocSize)])),
              createSeq(fields, 0)], 
            recordPtr))
      end

  fun transBinop (A.PlusOp, left, right) = Ex (R.BINOP (R.PLUS, unEx left, unEx right))
    | transBinop (A.MinusOp, left, right) = Ex (R.BINOP (R.MINUS, unEx left, unEx right))
    | transBinop (A.TimesOp, left, right) = Ex (R.BINOP (R.MUL, unEx left, unEx right))
    | transBinop (A.DivideOp, left, right) = Ex (R.BINOP (R.DIV, unEx left, unEx right))

  fun transRelop (relop, left, right) = case relop of 
                  A.EqOp => Cx(fn (t,f) => R.CJUMP(R.EQ, unEx left, unEx right, t, f))
                | A.NeqOp => Cx(fn (t,f) => R.CJUMP(R.NE, unEx left, unEx right, t, f))
                | A.LtOp => Cx(fn (t,f) => R.CJUMP(R.LT, unEx left, unEx right, t, f))
                | A.LeOp => Cx(fn (t,f) => R.CJUMP(R.LE, unEx left, unEx right, t, f))
                | A.GtOp => Cx(fn (t,f) => R.CJUMP(R.GT, unEx left, unEx right, t, f))
                | A.GeOp => Cx(fn (t,f) => R.CJUMP(R.GE, unEx left, unEx right, t, f))
  
  (* TODO: need to check how to pass in unEx left and unEx right with correct string values
      because it's currently an R.NAME *)
  fun transStringRelop (relop, left, right) = case relop of
                  A.EqOp => Cx(fn (t, f) => R.CJUMP(R.EQ, Frame.externalCall("stringEqual", [unEx left, unEx right]), R.CONST(1), t, f))
                | A.NeqOp => Cx(fn (t, f) => R.CJUMP(R.NE, Frame.externalCall("stringEqual", [unEx left, unEx right]), R.CONST(0), t, f))

  fun transLet (decs, exp) = Ex(R.ESEQ(seq (map unNx decs), unEx(exp)))

  fun transIf (cond, thene, elsee) =
      let val cond' = unCx cond
          val thene' = unEx thene
          val elsee' = unEx elsee
          val dest = Temp.newtemp()
          val lt = Temp.newlabel()
          val lf = Temp.newlabel()
          val le = Temp.newlabel()
      in
        Ex (R.ESEQ (seq [cond'(lt,lf),
                    R.LABEL lt,
                    R.MOVE(R.TEMP dest, thene'),
                    R.JUMP(R.NAME le,[le]),
                    R.LABEL lf,
                    R.MOVE(R.TEMP dest, elsee'),
                    R.LABEL le],
            R.TEMP dest))
      end

  fun transBrk (lbl) =
      Nx (R.JUMP(R.NAME lbl,[lbl]))

  fun transWhile (cond, body, lend) = 
      let val cond' = unCx cond
          val body' = unNx body
          val ls = Temp.newlabel()
          val ltst = Temp.newlabel()
      in
        Nx (seq [R.JUMP(R.NAME ltst, [ltst]),
                 R.LABEL ls,
                 body',
                 R.LABEL ltst,
                 cond'(ls,lend),
                 R.LABEL lend])
      end

  fun transFor(var, lo, hi, body, lend) = 
      let val var' = unEx var
          val lo' = unEx lo
          val hi' = unEx hi
          val body' = unNx body
          val lbody = Temp.newlabel()
          val lupdate = Temp.newlabel()
      in
        Nx (seq [R.MOVE(var', lo'),
                 R.CJUMP(R.LE, var', hi', lbody, lend),
                 R.LABEL lbody,
                 body',
                 R.CJUMP(R.LT, var', hi', lupdate, lend),
                 R.LABEL lupdate,
                 R.MOVE(var', R.BINOP(R.PLUS, var', R.CONST(1))),
                 R.JUMP(R.NAME lbody, [lbody]),
                 R.LABEL lend
                 ])
      end

  fun transAssign (var, value) =
     Nx(R.MOVE(unEx(var), unEx(value)))

  fun transArrayinit (sizeExp, initValExp) = 
    let
      val arrayPtr = R.TEMP (Temp.newtemp())
      val createArrayInstr = R.MOVE(arrayPtr, Frame.externalCall("malloc",
      [unEx(sizeExp)]))
      val forLoopVar = R.TEMP (Temp.newtemp())
      val forLoopBody = R.MOVE(
                              R.MEM(
                                R.BINOP(
                                  R.PLUS, 
                                    arrayPtr,
                                    forLoopVar)),
                                unEx(initValExp))
    in
      Ex( 
        R.ESEQ(seq [createArrayInstr, 
                    unNx (transFor(Ex(forLoopVar), 
                                  Ex(R.CONST 0), 
                                  Ex(unEx(sizeExp)), 
                                  Nx(forLoopBody), 
                                  Temp.newlabel()))],
          arrayPtr))
    end
    

end
