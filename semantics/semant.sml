structure A = Absyn
structure T = Types
structure S = Symbol
structure ERR = ErrorMsg
structure M = BinaryMapFn(struct type ord_key = string val compare = String.compare end)

structure Semant  = 
struct
  type expty = {exp: Translate.exp, ty: Types.ty}
  
  fun actualTy (Types.NAME(sym, ty)) = actualTy(valOf(!ty)) 
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
  
  val loopDepth = ref 0
  fun incrementLoopDepth () = loopDepth := !loopDepth + 1
  fun decrementLoopDepth () = loopDepth := !loopDepth - 1
  fun getLoopDepth ()       = !loopDepth

  fun transExp (venv, tenv, exp) =       (* venv * tenv * A.exp -> expty *)
    let
      fun trexp (A.VarExp(var))                                =  trvar(var)
        | trexp (A.NilExp)                                     =  {exp=(), ty=Types.NIL}
        | trexp (A.IntExp(num))                                =  {exp=(), ty=Types.INT}
        | trexp (A.StringExp(str, pos))                        =  {exp=(), ty=Types.STRING}

        | trexp (A.CallExp{func, args, pos})                   =  
            let
              fun matchargs([], [], _) = ()
                | matchargs(a::l, [], _) = ERR.error pos "Too few arguments"
                | matchargs([], a::l, _) = ERR.error pos "Too many arguments"
                | matchargs(formal::fl, arg::al, n) = (
                  if T.eq(actualTy formal, actualTy (#ty (trexp arg)))
                  then () 
                  else ERR.error pos ("Argument " ^ (Int.toString n) ^ " type " ^ T.str(actualTy (#ty (trexp arg))) ^ " doesn't match paramater type " ^ T.str (actualTy formal));
                  matchargs(fl, al, n+1))
              val retty:Types.ty  = case (S.look(venv, func)) of
                                      NONE => (ERR.error pos ("Variable " ^ (S.name func) ^ " undefined"); T.BOTTOM)
                                    | SOME(Env.VarEntry{ty:T.ty}) => (ERR.error pos ("Variable " ^ (S.name func) ^ " declared as variable not function") ;T.BOTTOM)
                                    | SOME(Env.FunEntry{formals, result}) => (matchargs (formals, args, 0); result)
            in
              {exp=(), ty=retty}
            end

        | trexp (A.OpExp {left, oper, right, pos}) =
            let 
              val {exp=lexp, ty=ltype_name} = trexp left
              val ltype = actualTy ltype_name
              val {exp=rexp, ty=rtype_name} = trexp right
              val rtype = actualTy rtype_name
              fun isArithmetic (l, r) = (
                assertType(l, T.INT, pos, "Left arithmetic operator must be Int") andalso 
                assertType(r, T.INT, pos, "Right arithmetic operator must be Int");())
              
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
                 | A.EqOp       => equalable  (ltype, rtype)
                 | A.NeqOp      => equalable  (ltype, rtype) 
                 | A.LtOp       => comparable (ltype, rtype)
                 | A.LeOp       => comparable (ltype, rtype)
                 | A.GtOp       => comparable (ltype, rtype) 
                 | A.GeOp       => comparable (ltype, rtype)
              ; {exp=(), ty=T.INT}
            end

        | trexp (A.RecordExp {fields, typ, pos})  =         
            let 
              val actualTyp = getType(tenv, typ, pos)
            in
              case actualTyp of
                   T.RECORD(symtylist, unique) =>
                     let
                        fun insertField ((sym, exp, pos), m) =
                          (case M.find(m, S.name sym) of 
                               SOME(_) => ERR.error pos ("Record Expression has duplicated name entries: "^ (S.name sym)) 
                             | NONE    => ();
                          M.insert(m, (S.name sym), #ty (trexp exp)))
                        val fieldsmap = foldl insertField M.empty fields 
                        fun checkTypeMatch(sym, ty) = 
                          case M.find(fieldsmap, (S.name sym)) of 
                               SOME(fieldTy) => if fieldTy=actualTy ty then () else ERR.error pos ("Record type " ^ (T.str (actualTy ty)) ^ " does not match field type " ^ (T.str fieldTy))
                             | NONE => ERR.error pos ("Record field name " ^ (S.name sym) ^ " not provided in RecordExp")
                      in
                        map checkTypeMatch symtylist;
                        {exp=(), ty=actualTyp}
                      end
                 | ty => (ERR.error pos ("Type name " ^ (S.name typ) ^ " is type " ^ (T.str ty)); {exp=(), ty=T.BOTTOM})
            end

        
        | trexp (A.SeqExp(l))                                  =  
            let   
              fun processSeq([]) = {exp = {}, ty=Types.UNIT}
                | processSeq([(item, pos)]) = trexp(item) 
                | processSeq((item, pos) :: l) = (trexp(item); processSeq(l))
            in processSeq(l) end

        | trexp (A.AssignExp {var, exp, pos})                  =  
            let 
              val currentType = actualTy (#ty (trvar var))
              val newType = actualTy (#ty (trexp exp))
            in
              if T.eq(currentType, newType) 
              then ()
              else ERR.error pos ("Assigned value type " ^ (T.str newType) ^ " <> " ^ (T.str currentType) ^ " declared type");
              {exp=(), ty=Types.UNIT} 
            end
        
        | trexp (A.IfExp {test, then', else', pos})            =  
            let 
              fun thentest () = (assertType(#ty (trexp test), T.INT,  pos, "If expression test must be type INT"); {exp=(), ty=T.UNIT})
              fun thenelsetest () =
                let 
                  val {exp=testexp, ty=testty} = trexp test
                  val thentype = (#ty (trexp then'))
                  val elsetype = (#ty (trexp (valOf(else'))))
                  val rettype = if T.leq(thentype, elsetype) 
                                then elsetype
                                else if T.leq(elsetype, thentype) 
                                     then thentype
                                     else (ERR.error pos ("Then type " ^ T.str thentype ^ " <> " ^ T.str elsetype ^ " else type"); T.BOTTOM)
                in
                  assertType(actualTy testty, T.INT, pos, "Test must be of integer type, not of type " ^ T.str (actualTy testty));
                  {exp=(), ty=rettype}
                end
            in if isSome(else') then thenelsetest() else thentest() end

        | trexp (A.WhileExp {test, body, pos})                 =  
            (incrementLoopDepth();
             assertType(actualTy (#ty (trexp test)), T.INT,  pos, "While expression test must be type INT");
             assertType(actualTy (#ty (trexp body)), T.UNIT,  pos, "While expression body must be type UNIT");
             decrementLoopDepth();
             {exp=(), ty=Types.UNIT})

        | trexp (A.ForExp {var, escape, lo, hi, body, pos})    =  
            let 
              val venv' = S.enter(venv, var, Env.VarEntry{ty=T.INT})
              val {exp=loexp, ty=loty} = trexp lo
              val {exp=hiexp, ty=hity} = trexp hi
            in
              incrementLoopDepth();
              assertType(actualTy loty, T.INT, pos, "For expression lo value must be of type INT");
              assertType(actualTy hity, T.INT, pos, "For expression hi value must be of type INT"); 
              transExp(venv', tenv, body);
              decrementLoopDepth();
              {exp=(), ty=T.UNIT}
            end

        | trexp (A.BreakExp(pos))                              =  
            if getLoopDepth() > 0 
            then {exp=(), ty=Types.UNIT} (* UNDONE *)
            else (ERR.error pos "Break not nested in loop"; {exp=(), ty=Types.BOTTOM})

        | trexp (A.LetExp{decs, body, pos})                    =  
            let
              val {venv=venv', tenv=tenv'} = 
                foldl (fn (dec, {venv=v, tenv=t}) => transDec(v, t, dec) ) 
                {venv=venv, tenv=tenv}
                decs
            in transExp(venv', tenv', body) end

        | trexp (A.ArrayExp{typ, size, init, pos})             =  
            let 
              val initType = actualTy (#ty (trexp init))
              val sizeType = actualTy (#ty (trexp size))
              val actualTyp = getType(tenv, typ, pos)
            in
              case actualTyp of  
                  T.ARRAY(arrayty, unique) => (
                    assertType(sizeType, T.INT, pos, "Initialization Size must be of type INT, not " ^ T.str sizeType);
                    assertType(initType, actualTy(arrayty), pos, "Initialization Type " ^ (T.str initType) ^ " must match array type " ^ T.str (actualTy arrayty));
                    {exp=(), ty=actualTyp})
                | randoType => (ERR.error pos ("Type " ^ (S.name typ) ^ " must be array type not " ^ (T.str randoType)); {exp=(), ty=T.UNIT})
            end

      and trvar (A.SimpleVar(id,pos)) = 
                (case Symbol.look(venv,id)
                  of SOME(Env.VarEntry{ty}) => {exp=(), ty=actualTy ty}
                   | SOME(Env.FunEntry({formals, result})) => {exp=(), ty=result}
                   | NONE => (ERR.error pos ("undefined variable " ^ S.name id);
                              {exp=(), ty=Types.BOTTOM})) 
        | trvar (A.FieldVar(var, symbol, pos)) = 
            let 
              val {exp=_, ty=s} = trvar(var)
              val superty = actualTy s
            in
              case superty of 
                   T.RECORD(symtylist, unique) =>
                     let
                       fun inlist (item:S.symbol, []) = NONE
                         | inlist (item:S.symbol, (fieldsym, fieldty)::l) = if fieldsym = item then SOME(fieldty) else inlist(item, l)
                       
                       val fieldType = inlist(symbol, symtylist)
                     in
                       if isSome(fieldType)
                       then {exp=(), ty=valOf(fieldType)}
                       else (ERR.error pos ("Record Type " ^ (T.str superty) ^ " does not have field " ^ (S.name symbol)); {exp=(), ty=T.UNIT})
                     end
                 | _ => (ERR.error pos ( (T.str superty) ^ " is not record type"); {exp=(), ty= T.UNIT})
            end

        | trvar (A.SubscriptVar(var, exp, pos)) = 
            let 
              val indexType = #ty (trexp exp)
              val {exp=_, ty=superty} = trvar(var)
            in
              assertType(indexType, T.INT, pos, ("Array index must be of type integer not " ^ (T.str indexType)));
              case superty of 
                   T.ARRAY(arrayty, unique) => {exp=(), ty=arrayty}
                 | _ => (ERR.error pos ("Attempting to subscript non-array type: " ^ (T.str superty)); {exp=(), ty=T.UNIT})
            end
    in
      trexp(exp)
    end

  and transDec (venv, tenv, A.VarDec{name, escape, typ, init, pos})  =
        let val {exp, ty} = transExp(venv,tenv,init) in (
          if ((ty = T.NIL) andalso (not(isSome(typ)))) 
          then ERR.error pos ("Must use long form when initilizing expression is nil") 
          else ();
          isValidTypeAnnotation(tenv, typ, ty);
          {tenv=tenv, venv=S.enter(venv,name,Env.VarEntry{ty=ty})})
        end

    | transDec (venv, tenv, A.TypeDec(l)) = 
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
          {tenv=tenv', venv=venv'} 
        end

    | transDec (venv, tenv, A.FunctionDec(fundecs)) = 
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
                val funentry = Env.FunEntry{formals= map #ty params', result=returnType}
              in
                S.enter(venv, name, funentry)
              end

            val venv' = foldl enterFunc venv fundecs
            fun checkBody  ({name, params, result, body, pos}:A.fundec) =
              let
                fun enterparam ({name, escape, typ, pos}:A.field, venv) = S.enter(venv, name, Env.VarEntry{ty=case S.look(tenv, typ) of SOME(t) => t | NONE => T.UNIT})
                val venv'' = foldl enterparam venv' params
                val returnType = getFuncReturnType(result)
                val {exp=bodyexp, ty=bodyty} = transExp(venv'', tenv, body);
              in 
                if returnType <> bodyty 
                then ERR.error pos ("Function evaluates to " ^ (T.str bodyty) ^ " <> " ^ (T.str returnType) ^ " expected return type")
                else ()
              end
          in
            map checkBody fundecs;
            {venv=venv', tenv=tenv}
          end
  
  and transTy (tenv, ty:A.ty): T.ty =  (*        tenv * A.ty  -> Types.ty *)
    case ty of 
        A.NameTy(symbol, pos) => (case S.name(symbol) of
                                      "nil" => T.NIL
                                    | "int" => T.INT
                                    | "string" => T.STRING
                                    | _ => case S.look(tenv, symbol) of
                                                SOME(t) => t
                                              | NONE => (ERR.error pos ("Type not found " ^ S.name(symbol)); T.NIL)
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

  fun transProg (ast) = transExp(Env.base_venv, Env.base_tenv, ast) 
end

structure Main = 
struct 
  val simpleAdd = A.OpExp( {left=A.IntExp(3), oper=A.PlusOp, right=A.IntExp(2), pos=0})
  val badAdd = A.OpExp( {left=A.IntExp(3), oper=A.PlusOp, right=A.StringExp("Two", 1),  pos=0})
  val badMinus = A.OpExp( {left=A.IntExp(3), oper=A.PlusOp, right=A.StringExp("Two", 1),  pos=0})
  val goodMinus = A.OpExp( {left=A.IntExp(3), oper=A.PlusOp, right=A.IntExp(2),  pos=0})
  val badTimes = A.OpExp( {left=A.IntExp(3), oper=A.TimesOp, right=A.StringExp("Two", 1),  pos=0})
  val badDivide = A.OpExp( {left=A.IntExp(3), oper=A.DivideOp, right=A.StringExp("Two", 1),  pos=0})

  val goodEq = A.OpExp( {left=A.IntExp(1), oper=A.EqOp, right=A.IntExp(0), pos=0})
  val badEq  = A.OpExp( {left=A.IntExp(1), oper=A.EqOp, right=A.StringExp("hello", 2), pos=0})

  val seqGood = A.SeqExp([(goodEq, 0), (simpleAdd, 1)])
  val seqBad =  A.SeqExp([(badEq, 0), (simpleAdd, 1)])

  val ifthenelseGood = A.IfExp( {test=A.IntExp(1), then'=A.IntExp(2), else'=SOME(A.IntExp(3)), pos=0} )
  val ifthenGood = A.IfExp( {test=A.IntExp(1), then'=A.IntExp(2), else'=NONE, pos=0} )
  val ifBad = A.IfExp( {test=A.IntExp(1), then'=A.IntExp(2), else'=SOME(A.StringExp("Three", 1)), pos=0} )

  val varDecGood = A.LetExp{
    decs=[
      A.VarDec{name=S.symbol("A"), 
      escape=ref false,
      typ=NONE, 
      init=A.IntExp(3),
      pos=10}
    ], 
    body=A.VarExp(A.SimpleVar(Symbol.symbol("A"), 1)), 
    pos=1
  }

  val varDecBad = A.LetExp{
    decs=[
      A.VarDec{
        name=S.symbol("A"), 
        escape=ref false,
        typ=NONE, 
        init=A.IntExp(3),
        pos=10}
    ], 
    body=A.VarExp(A.SimpleVar(S.symbol("B"), 1)), 
    pos=1
  }

  fun test (ast) = Semant.transProg(ast)
  
  fun main (filename) = Semant.transProg(Parse.parse(filename))
end
