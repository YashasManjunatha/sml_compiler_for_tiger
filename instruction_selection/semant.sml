
structure Semant  = 
struct
  structure M = BinaryMapFn(struct type ord_key = string val compare = String.compare end)
  structure Tra = Translate

  type expty = {exp: Tra.exp, ty: T.ty}
  
  fun actualTy (T.NAME(sym, ty)) = actualTy(valOf(!ty)) 
    | actualTy (ty) = ty

  fun getType (tenv, sym, pos) = case S.look(tenv, sym) of 
                                 SOME(t) => actualTy t
                               | NONE => (ERR.error pos ("Type not found " ^ (S.name sym)); T.BOTTOM)

  fun assertType(ty:T.ty, requiredType:T.ty, pos, errormsg) = if T.eq(ty, requiredType)  then true else (ERR.error pos errormsg; false)

  fun isValidTypeAnnotation(tenv, typ, initType) = 
    if isSome(typ) then
      let 
        val (annotateTypeSymbol, pos) = valOf(typ)
        val annotateType = getType(tenv, annotateTypeSymbol, pos)
      in ( if T.eq(annotateType, initType) then () else ERR.error pos ("Annotated Type " ^ T.str annotateType ^ " <> " ^ T.str initType ^ " Init Type") ) end 
   else ()

  fun transExp (venv, tenv, level, loopend, exp):expty =      
    let
      fun trexp (A.VarExp(var))                                = trvar(var)
        | trexp (A.NilExp)                                     = {exp=Tra.transNil(), ty=T.NIL}
        | trexp (A.IntExp(num))                                = {exp=Tra.transInt num, ty=T.INT}
        | trexp (A.StringExp(str, pos))                        = {exp=Tra.transString str, ty=T.STRING}

        | trexp (A.CallExp{func, args, pos})                   =  
            let
              val badFunc = {formals=[], result=T.BOTTOM, label=(S.symbol "BadFunction"), level=level}
              val {formals, result, label, level=flevel} = case S.look(venv, func) of 
                                      NONE => (ERR.error pos ("Variable " ^ (S.name func) ^ " undefined"); badFunc)
                                    | SOME(Env.VarEntry{...}) => (ERR.error pos ("Variable " ^ (S.name func) ^ " declared as variable not function"); badFunc)
                                    | SOME(Env.FunEntry{formals, result, label, level}) => {formals=formals, result=result, label=label, level=level}
              val argExptys = map trexp args
              fun matchargs([], [], _) = ()
                | matchargs(a::l, [], _) = ERR.error pos "Too few arguments"
                | matchargs([], a::l, _) = ERR.error pos "Too many arguments"
                | matchargs(formal::fl, {exp=exp, ty=argty}::al, n) = (
                  if T.eq(actualTy formal, actualTy argty)
                  then () 
                  else ERR.error pos ("Argument " ^ (Int.toString n) ^ " type " ^ T.str(actualTy argty) ^ " doesn't match paramater type " ^ T.str (actualTy formal));
                  matchargs(fl, al, n+1))
            in
              matchargs(formals, argExptys, 0);
              {exp=Tra.transCall(label, map #exp argExptys), ty=result}
            end

        | trexp (A.OpExp {left, oper, right, pos}) =
            let 
              val {exp=lexp, ty=ltype_name} = trexp left
              val ltype = actualTy ltype_name
              val {exp=rexp, ty=rtype_name} = trexp right
              val rtype = actualTy rtype_name
              fun isArithmetic (l, r) = (
                assertType(l, T.INT, pos, "Left arithmetic operator must be Int") andalso 
                assertType(r, T.INT, pos, "Right arithmetic operator must be Int");
                {exp=Tra.transBinop(oper, lexp, rexp), ty=T.INT})
              
              fun equalable (T.RECORD(_, u1), T.RECORD(_, u2)) = if u1=u2 then () else ERR.error pos ("Cannot compare different record types " ^ (T.str ltype) ^", " ^ (T.str rtype))
                | equalable (T.RECORD(_, u1), T.NIL) = ()
                | equalable (T.NIL, T.RECORD(_, u2)) = ()
                | equalable (T.ARRAY(_, u1), T.ARRAY(_, u2)) = if u1=u2 then () else ERR.error pos ("Cannot compare different array types " ^ (T.str ltype) ^", " ^ (T.str rtype))
                | equalable (a, b) = (assertType(a, b, pos, ("Left Type " ^ T.str a ^ " <> " ^ T.str b ^ " Right Type"));())
              
              fun comparable (T.INT, T.INT) = ()
                | comparable (T.STRING, T.STRING) = ()
                | comparable (_, _) = ERR.error pos ("Cannot compare types " ^ T.str ltype ^ " and " ^ T.str rtype)
            
            in
              case oper of 
                   A.PlusOp     => isArithmetic (ltype, rtype)
                 | A.MinusOp    => isArithmetic (ltype, rtype) 
                 | A.TimesOp    => isArithmetic (ltype, rtype)
                 | A.DivideOp   => isArithmetic (ltype, rtype)
                 | A.EqOp       => 
                    (equalable  (ltype, rtype); 
                    {exp=(if ltype=T.STRING then Tra.transStringRelop(oper, lexp, rexp) else Tra.transRelop(oper, lexp, rexp)), ty=T.INT})
                 | A.NeqOp      => 
                    (equalable  (ltype, rtype); 
                    {exp=(if ltype=T.STRING then Tra.transStringRelop(oper, lexp, rexp) else Tra.transRelop(oper, lexp, rexp)), ty=T.INT})
                 | A.LtOp       => (comparable (ltype, rtype); {exp=Tra.transRelop(oper, lexp, rexp), ty=T.INT})
                 | A.LeOp       => (comparable (ltype, rtype); {exp=Tra.transRelop(oper, lexp, rexp), ty=T.INT})
                 | A.GtOp       => (comparable (ltype, rtype); {exp=Tra.transRelop(oper, lexp, rexp), ty=T.INT})
                 | A.GeOp       => (comparable (ltype, rtype); {exp=Tra.transRelop(oper, lexp, rexp), ty=T.INT})
            end

        | trexp (A.RecordExp {fields, typ, pos})  =         
            let 
              val actualTyp = getType(tenv, typ, pos)
            in
              case actualTyp of
                   T.RECORD(symtylist, unique) =>
                     let
                        fun transFieldExp ((sym, exp, pos)::[]) = [(S.name sym, trexp exp, pos)]
                          | transFieldExp ((sym, exp, pos)::l) = (S.name sym, trexp exp, pos)::transFieldExp(l)
                        fun insertField ((sym, {exp, ty}, pos), m) =
                          (case M.find(m, sym) of 
                               SOME(_) => ERR.error pos ("Record Expression has duplicated name entries: " ^ sym) 
                             | NONE    => ();
                          M.insert(m, sym, ty))
                        val transFields = transFieldExp fields
                        val symExp = map (fn(sym, exp, pos) => (sym, #exp exp)) transFields
                        val fieldsmap = foldl insertField M.empty transFields
                        fun checkTypeMatch(sym, ty) = 
                          case M.find(fieldsmap, (S.name sym)) of 
                               SOME(fieldTy) => if fieldTy=actualTy ty then () else ERR.error pos ("Record type " ^ (T.str (actualTy ty)) ^ " does not match field type " ^ (T.str fieldTy))
                             | NONE => ERR.error pos ("Record field name " ^ (S.name sym) ^ " not provided in RecordExp")
                      in
                        map checkTypeMatch symtylist;
                        {exp=Tra.transRecord symExp, ty=actualTyp}
                      end
                 | ty => (ERR.error pos ("Type name " ^ (S.name typ) ^ " is type " ^ (T.str ty)); {exp=Tra.transInt 0, ty=T.BOTTOM})
            end

        
        | trexp (A.SeqExp(l))                                  =  
            let    
              val expTyList = map (fn(e, p) => trexp e) l
              val expList = map #exp expTyList
              val retty = case expTyList of 
                               [] => T.UNIT
                             | l  => actualTy(#ty (List.last(l)))
            in {exp=Tra.transSeq(expList), ty=retty} end

        | trexp (A.AssignExp {var, exp, pos})                  =  
            let 
              val {exp=varLocExp, ty=currentTy} = trvar var
              val currentTy = actualTy currentTy
              val {exp=newExp, ty=newTy} = trexp exp
              val newTy = actualTy newTy
            in
              if T.eq(currentTy, newTy) 
              then ()
              else ERR.error pos ("Assigned value type " ^ (T.str newTy) ^ " <> " ^ (T.str currentTy) ^ " declared type");
              {exp=Tra.transAssign(varLocExp, newExp), ty=T.UNIT} 
            end
        
        | trexp (A.IfExp {test, then', else', pos})            =  
            let 
              val {exp=testexp, ty=testty} = trexp test
              val {exp=thenexp, ty=thentype} = trexp then'
              fun thentest () = {exp=Tra.transIf(testexp, thenexp, Tra.transSeq([])), ty=T.UNIT}
              fun thenelsetest () =
                let 
                  val {exp=elseexp, ty=elsetype} = trexp (valOf(else'))
                  val rettype = if T.leq(thentype, elsetype) 
                                then elsetype
                                else if T.leq(elsetype, thentype) 
                                     then thentype
                                     else (ERR.error pos ("Then type " ^ T.str thentype ^ " <> " ^ T.str elsetype ^ " else type"); T.BOTTOM)
                in
                  {exp=Tra.transIf(testexp, thenexp, elseexp),  ty=rettype}
                end
            in 
              assertType(actualTy testty, T.INT, pos, "Test must be of integer type, not of type " ^ T.str (actualTy testty));
              if isSome(else') then thenelsetest() else thentest() 
            end

        | trexp (A.WhileExp {test, body, pos})                 =  
            let
              val endLabel = Temp.newlabel() 
              val {exp=testexp, ty=testty} = trexp test
              val {exp=bodyexp, ty=bodyty} = transExp(venv, tenv, level, SOME(endLabel),  body)
            in
              assertType(actualTy testty, T.INT,  pos, "While expression test must be type INT");
              assertType(actualTy bodyty,  T.UNIT,  pos, "While expression body must be type UNIT");
              {exp=Tra.transWhile(testexp, bodyexp, endLabel), ty=T.UNIT}
            end

        | trexp (A.ForExp {var, escape, lo, hi, body, pos})    =  
            let 
              val endLabel = Temp.newlabel() 
              val varAccess = Tra.allocLocal level true
              val venv' = S.enter(venv, var, Env.VarEntry{ty=T.INT, access=varAccess})
              val () = ERR.error 0 ("Function Frame " ^ Tra.str level ^ " allocated loop var ")
              val {exp=loexp, ty=loty} = trexp lo
              val {exp=hiexp, ty=hity} = trexp hi
              val {exp=bodyexp, ty=bodyty} = transExp(venv', tenv, level, SOME(endLabel), body) 
              (* rearrange For into While *)
            in
              assertType(actualTy loty, T.INT, pos, "For expression lo value must be of type INT");
              assertType(actualTy hity, T.INT, pos, "For expression hi value must be of type INT"); 
              {exp=Tra.transFor(Tra.simpleVar(varAccess, level), 
                                      loexp, 
                                      hiexp, 
                                      bodyexp, 
                                      endLabel), ty=T.UNIT}
            end

        | trexp (A.BreakExp(pos))                              =  
            (case loopend of 
                 SOME(l) => {exp=Tra.transBrk(l), ty=T.UNIT}
               | NONE => (ERR.error pos "Break not nested in loop";
                          {exp=Tra.transInt 0, ty=T.BOTTOM}))
        
        | trexp (A.LetExp{decs, body, pos})                    =  
            let
              val {venv=venv', tenv=tenv', expList=expList'} = 
                foldl (fn (dec, {venv=v, tenv=t, expList=el}) => 
                  let 
                    val {venv=v', tenv=t', expList=el'} = transDec(v, t, level, loopend, dec) 
                  in
                    {venv=v', tenv=t', expList=el @ el'}
                  end)
                {venv=venv, tenv=tenv, expList=[]}
                decs
              val {exp=bodyExp, ty=bodyTy} = transExp(venv', tenv', level, loopend, body)
            in  {exp=Tra.transLet(expList', bodyExp), ty=bodyTy} end 

        | trexp (A.ArrayExp{typ, size, init, pos})             =  
            let 
              val {exp=initExp, ty=initType} = trexp init
              val initType = actualTy initType
              val {exp=sizeExp, ty=sizeType}  = trexp size
              val sizeType = actualTy sizeType
              val actualTyp = getType(tenv, typ, pos)
            in
              case actualTyp of  
                  T.ARRAY(arrayty, unique) => (
                    assertType(sizeType, T.INT, pos, "Initialization Size must be of type INT, not " ^ T.str sizeType);
                    assertType(initType, actualTy(arrayty), pos, "Initialization Type " ^ (T.str initType) ^ " must match array type " ^ T.str (actualTy arrayty));
                    {exp=Tra.transArrayinit(sizeExp, initExp), ty=actualTyp})
                | randoType => (ERR.error pos ("Type " ^ (S.name typ) ^ " must be array type not " ^ (T.str randoType)); {exp=Tra.transInt 0, ty=T.UNIT})
            end

      and trvar (A.SimpleVar(id,pos)) = 
                (case S.look(venv,id)
                  of SOME(Env.VarEntry{ty, access}) =>
                       {exp=Tra.simpleVar(access, level), ty=actualTy ty}
                   | SOME(Env.FunEntry({formals, result, ...})) => {exp=Tra.transInt 0, ty=result}
                   | NONE => (ERR.error pos ("undefined variable " ^ S.name id);
                              {exp=Tra.transInt 0, ty=T.BOTTOM})) 
        | trvar (A.FieldVar(var, symbol, pos)) = 
            let 
              val {exp=superexp, ty=s} = trvar(var)
              val superty = actualTy s
            in
              case superty of 
                   T.RECORD(symtylist, unique) =>
                     let
                       fun inlist (item:S.symbol, [], _) = (NONE, ~1)
                         | inlist (item:S.symbol, (fieldsym, fieldty)::l, n) = if fieldsym = item then (SOME(fieldty), n) else inlist(item, l, n+1)
                       
                       val (fieldType, fieldNum) = inlist(symbol, symtylist, 0)
                     in
                       if isSome(fieldType)
                       then {exp=Tra.fieldVar(superexp, Tra.transInt
                       fieldNum) , ty=valOf(fieldType)}
                       else (ERR.error pos ("Record Type " ^ (T.str superty) ^ " does not have field " ^ (S.name symbol)); {exp=Tra.transInt 0, ty=T.UNIT})
                     end
                 | _ => (ERR.error pos ( (T.str superty) ^ " is not record type"); {exp=Tra.transInt 0, ty= T.UNIT})
            end

        | trvar (A.SubscriptVar(var, exp, pos)) = 
            let 
              val {exp=indexExp, ty=indexType} = trexp exp
              val {exp=superExp, ty=superType} = trvar var
            in
              assertType(indexType, T.INT, pos, ("Array index must be of type integer not " ^ (T.str indexType)));
              case superType of 
                   T.ARRAY(arrayty, unique) =>
                   {exp=Tra.subscriptVar(superExp, indexExp), ty=arrayty}
                 | _ => (ERR.error pos ("Attempting to subscript non-array type: " ^ (T.str superType)); {exp=Tra.transInt 0, ty=T.UNIT})
            end
    in
      trexp(exp)
    end

  and transDec (venv, tenv, level, loopend, dec) = (* {tenv, venv, expList} where explist
                                           is a serires of things to create
                                           declared variables before processing
                                           let body. Empty for type and function
                                           dec as those don't create vars in
                                           memory*)
    let
      fun trdec (A.VarDec{name, escape, typ, init, pos})  =
            let 
              val {exp, ty} = transExp(venv, tenv, level, loopend, init)               
              val access = Tra.allocLocal level (!escape)
              val varEntry = Env.VarEntry{ty=ty, access=access}
              (* Frame Analysis Debug *)
              val () = ERR.error 0 ("Function Frame " ^ Tra.str level ^ " alloc " ^ S.name name ^ " esc=" ^ Bool.toString(!escape))
            in (
              if ((ty = T.NIL) andalso (not(isSome(typ)))) 
              then ERR.error pos ("Must use long form when initilizing expression is nil") 
              else ();
              isValidTypeAnnotation(tenv, typ, ty);
              {tenv=tenv, 
               venv=S.enter(venv, name, varEntry),
               expList=[Tra.transAssign(Tra.simpleVar(access,
               level), exp)]
               })
            end

        | trdec (A.TypeDec(l)) = 
            let 
              fun tenvAddHeader({name, ty, pos}, {tenv=t, venv=v}) = {tenv=S.enter(t, name, T.NAME(name, ref NONE)), venv=v} 
              val {tenv=tenv', venv=venv'} = foldl tenvAddHeader {tenv=tenv, venv=venv} l
              fun setRef t {name, ty, pos} = 
                let val (sym, tyoptref) = case S.look(t, name) of 
                                               SOME(T.NAME(sym, tyoptref)) => (sym, tyoptref)
                                             | _ => (name, ref NONE) (* Big Trouble if it gets to here *)
                in tyoptref := SOME(transTy(t, ty)) end
              fun checkLoop t {name, ty, pos} =
                let
                  val selfty = valOf(S.look(t, name))
                  fun helper (T.NAME(s, tyoptref), loopstr)  = (case !tyoptref of 
                                                                  SOME(linkty) => if linkty = selfty 
                                                                                  then ERR.error pos ("Mutually Recursive Type Loop: " ^ loopstr ^  (S.name(s)) ^ " -> " ^ (S.name(name)))  
                                                                                  else  helper(linkty, loopstr  ^ (S.name s) ^ " -> ")
                                                                | NONE => ERR.error pos ("Type name " ^ S.name s ^ " refers to none!"))
                    | helper (t, loopstr) = ()
                in
                  case S.look(t, name) of
                       SOME(t) => helper(t, "")
                     | NONE    => ERR.error pos ((S.name name) ^ " not found in type env")
                end
               
            in
              map (setRef tenv') l;
              map (checkLoop tenv') l;
              {tenv=tenv', 
               venv=venv',
               expList=[]} 
            end

        | trdec (A.FunctionDec(fundecs)) = 
            let
              fun getFuncReturnType(result) = (case result of 
                                                   NONE => T.UNIT
                                                 | SOME(rt, retpos) => getType(tenv, rt, retpos))

              fun enterFunc ({name, params, result, body, pos}:A.fundec, venv) =
                let 
                  val returnType = getFuncReturnType(result)
                  fun transParam ({name, escape, typ, pos}:A.field) = 
                    case S.look(tenv, typ) of
                         SOME t => {name=name, ty=actualTy t}
                       | NONE   => (ERR.error pos ("Could not find type " ^ (S.name typ) ^ " in type environment"); {name=name, ty=T.UNIT})
                  val params' = map transParam params 
                  val funLabel = Temp.newlabel()
                  val funentry = Env.FunEntry{formals=map #ty params', 
                                              result=returnType,
                                              label=funLabel,
                                              level=Tra.newLevel{parent=level, 
                                                                       name=funLabel,
                                                                       formals = map(fn ({escape, ...}:A.field) => !escape) params}
                                              }
                in
                  S.enter(venv, name, funentry)
                end

              val venv' = foldl enterFunc venv fundecs
              fun checkBody  ({name, params, result, body, pos}:A.fundec) =
                let
                  val (sublevel, label) = case S.look(venv', name) of
                                      SOME(Env.FunEntry{level, label, ...}) => (level, label)
                                    | _ => (ERR.error pos ("Could not find function entry for " ^ S.name name); 
                                            (Tra.newLevel{parent=Tra.outermost, name=Temp.newlabel(), formals=[]}, Temp.newlabel()))
                  (* Debugging Frame Analysis *)
                  val () = ERR.error 0 ("Function Frame " ^ Tra.str sublevel ^ " = " ^ S.name name)
                  fun enterparam ({name, escape, typ, pos}:A.field, venv) = S.enter(venv, name, 
                  Env.VarEntry{ty=(case S.look(tenv, typ) of 
                                       SOME(t) => t 
                                     | NONE => T.UNIT),
                               access = Tra.allocLocal sublevel false}) 
                  (* IS THIS RIGHT? 
                   * All arguments are passed by the stack because all parameters escape.
                   * But a given frame doesn't have different argument space for each nested function.
                   * We don't want to increase the stack space so I just did it as tho the arguments could be accesed by 
                   * registers that are accessible during type checking, but won't actually be used in runtime.
                   * We must do this so we don't unnecessarily increase the stack space
                   * This is only used in venv'' which dies after type checkign anyway.
                   *)

                  val venv'' = foldl enterparam venv' params
                  val returnType = getFuncReturnType(result)
                  val {exp=bodyexp, ty=bodyty} = transExp(venv'', tenv, sublevel, NONE, body);
                in 
                  if returnType <> bodyty 
                  then ERR.error pos ("Function evaluates to " ^ (T.str bodyty) ^ " <> " ^ (T.str returnType) ^ " expected return type")
                  else ();
                  Tra.procEntryExit{level=sublevel, body=bodyexp}
                end
            in
              map checkBody fundecs;
              {venv=venv', 
               tenv=tenv,
               expList=[]}
            end
    in
      trdec(dec)
    end
  
  and transTy (tenv, ty:A.ty): T.ty =  (*        tenv * A.ty  -> T.ty *)
    case ty of 
        A.NameTy(symbol, pos) => (case S.name(symbol) of
                                      "nil" => T.NIL
                                    | "int" => T.INT
                                    | "string" => T.STRING
                                    | _ => case S.look(tenv, symbol) of
                                                SOME(t) => t
                                              | NONE => (ERR.error pos ("Type not found " ^ S.name(symbol)); T.BOTTOM)
                                    )
      | A.RecordTy(fields) => T.RECORD(foldl 
                                       (fn ({name: A.symbol, escape: bool ref, typ: A.symbol, pos: A.pos}, b) => 
                                        let
                                          val lookup = S.look(tenv, typ)
                                          val recordType = if lookup <> NONE then () else ERR.error pos ("Could not find type " ^ S.name(typ)); 
                                        in
                                          b @ [(name, valOf(lookup))]
                                        end)
                                       [] fields, ref ())
      | A.ArrayTy(symbol, pos) => (let
                                      val lookup  = S.look(tenv, symbol)
                                      val recordType = if lookup <> NONE then () else ERR.error pos ("Could not find type " ^ S.name(symbol)); 
                                    in
                                      T.ARRAY(valOf(lookup), ref ())
                                    end)

  fun transProg (ast) = 
    let
      val mainLevel = Tra.newLevel{parent=Tra.outermost, name=Temp.newlabel(), formals=[]}
      val {exp=mainExp, ty=mainTy} = transExp(Env.base_venv, Env.base_tenv, mainLevel, NONE, ast)
    in
      Tra.procEntryExit {level=mainLevel, body=mainExp};
      Tra.getResult()
    end
end

(*structure Main = 
struct 
  fun main (filename) = 
    let 
      val fraglist = Semant.transProg(Parse.parse(filename))
      val () = Translate.resetFragList()
      fun printFrag frag = MipsFrame.writeFrag (TextIO.stdOut, frag)
    in
      TextIO.print ("FP = " ^ Int.toString (MipsFrame.FP) ^ "\n");
      TextIO.print ("RV = " ^ Int.toString (MipsFrame.RV) ^ "\n")
      (*map printFrag fraglist*)
    end
end*)
