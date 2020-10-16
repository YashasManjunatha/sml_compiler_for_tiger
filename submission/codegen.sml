signature CODEGEN = sig
  structure Frame : FRAME
  val codegen : Frame.frame -> Tree.stm -> Assem.instr list 
end


structure Mips:CODEGEN = struct
  structure A = Assem
  structure T = Tree
  structure Frame = MipsFrame
  exception JALRRaised
  fun codegen (frame:Frame.frame) (stm:Tree.stm) = 
    let val ilist = ref (nil: A.instr list)
      fun emit x = ilist := x :: !ilist
      fun result(gen) = let val t = Temp.newtemp() in gen t; t end
      fun int2str i = 
        if i < 0 
        then "-" ^ Int.toString(Int.abs(i))
        else Int.toString(i)

      fun munchArgs(i, []) = []
        | munchArgs(i, a::args) =
          let 
            val memloc = if (i < Frame.numArgRegs) 
                         then List.nth (Frame.argregs, i) 
                         (* 
                          * This is certainly wrong but we aren't 
                          * going to deal with functions with more
                          * arguments than arg registers 
                          * *)
                         else (
                          munchExp(T.MEM(T.BINOP( 
                            T.PLUS,
                            T.TEMP Frame.SP,
                            T.CONST(i * Frame.wordSize))))
                         )
          in
            munchStm(T.MOVE(T.TEMP memloc, T.TEMP (munchExp(a))));
            memloc::munchArgs(i+1, args)
          end

      and munchStm (T.SEQ(el)) = (map munchStm el; ())
        | munchStm (T.LABEL lab) = emit(A.LABEL{
            assem=S.name lab ^ ":\n", 
            lab=lab})
        
        | munchStm(T.JUMP(T.MEM(T.NAME L), labs)) = emit(A.OPER{ 
            assem="j " ^ (S.name L) ^"\n",
            dst=[],
            src=[],
            jump=SOME(labs)})

        | munchStm(T.JUMP (T.NAME L, labs)) = emit(A.OPER{
            assem="j " ^ (S.name L) ^"\n",
            dst=[],
            src=[],
            jump=SOME(labs)})

        | munchStm(T.JUMP (e1, labs)) = emit(A.OPER{
            assem="j `d0\n",
            dst=[munchExp e1],
            src=[],
            jump=SOME(labs)})

        | munchStm(T.CJUMP (T.EQ, e1, e2, lt, lf)) = emit(A.OPER{
            assem="beq `s0, `s1, " ^ S.name lt ^ "\n",
            dst=[],
            src=(map munchExp [e1, e2]),
            jump=SOME([lt, lf])})

        | munchStm(T.CJUMP (T.NE, e1, e2, lt, lf)) = emit(A.OPER{
            assem="bne `s0, `s1, " ^ S.name lt ^ "\n",
            dst=[],
            src=(map munchExp [e1, e2]),
            jump=SOME([lt, lf])})

        | munchStm(T.CJUMP (relop, e1, e2, lt, lf)) = 
          let val (ins, label_t, label_f) = case relop of
                   T.LT => ("bltz", lt, lf)
                 | T.LE => ("blez", lt, lf)
                 | T.GT => ("bgtz", lt, lf)
                 | T.GE => ("bgez", lt, lf)
                 | _ => ("beq", lt, lf) (* What are the ULT ops *)
          in
            emit(A.OPER{
              assem="sub `d0, `s0, `s1\n" ^ ins ^ " `d0, " ^ S.name label_t ^ "\n",
              dst=[Temp.newtemp()],
              src=(map munchExp [e1, e2]),
              jump=SOME([label_t, label_f])})
          end
        
        | munchStm (T.MOVE(T.NAME lab, e2)) =
            emit(A.OPER{
            assem = "sw `s0, (" ^ S.name lab ^ ")\n",
            src = [munchExp e2],
            dst = [],
            jump=NONE})
        | munchStm (T.MOVE(T.MEM(T.BINOP(T.PLUS, e1, T.CONST imm)), e2)) =
            emit(A.OPER{
            assem = "sw `s1 " ^ int2str imm ^  "(`s0)\n",
            src = [munchExp e1, munchExp e2],
            dst = [],
            jump=NONE})
        | munchStm (T.MOVE(T.MEM(T.BINOP(T.MINUS, e1, T.CONST imm)), e2)) =
            emit(A.OPER{
            assem = "sw `s1 " ^ int2str (~imm) ^  "(`s0)\n",
            src = [munchExp e1, munchExp e2],
            dst = [],
            jump=NONE})
        | munchStm (T.MOVE(T.MEM(T.BINOP(T.PLUS, T.CONST imm, e1)), e2)) =
            emit(A.OPER{
            assem = "sw `s1 " ^ int2str imm ^  "(`s0)\n",
            src = [munchExp e1, munchExp e2],
            dst = [],
            jump=NONE})
        | munchStm (T.MOVE(T.MEM(T.BINOP(T.MINUS, T.CONST imm, e1)), e2)) =
            emit(A.OPER{
            assem = "sw `s1 " ^ int2str (~imm) ^  "(`s0)\n",
            src = [munchExp e1, munchExp e2],
            dst = [],
            jump=NONE})
        | munchStm (T.MOVE(T.MEM(e1), e2)) = 
            emit(A.OPER{
            assem = "sw `s1 (`s0)\n",
            src = [munchExp e1, munchExp e2],
            dst = [],
            jump=NONE})

        | munchStm (T.MOVE(e1, e2)) = emit (A.MOVE{
            assem = "move `d0, `s0\n",
            dst = munchExp e1,
            src = munchExp e2})

        | munchStm (T.EXP(e1)) = (munchExp e1; ()) (* This doesn't need to be evaluated *)
              

        (* NOTE: this one takes in $s and an immediate h and returns $d *)
      and munchExp (T.BINOP(T.ARSHIFT, T.CONST(i), e)) = result(fn r => emit(A.OPER{
            assem="srl `d0 `s0 " ^ int2str i ^ "\n",
            src=[munchExp(e)],
            dst=[r],
            jump=NONE}))
        | munchExp (T.BINOP(T.ARSHIFT, e, T.CONST(i))) = result(fn r => emit(A.OPER{
            assem="srl `d0 `s0 " ^ int2str i ^ "\n",
            src=[munchExp(e)],
            dst=[r],
            jump=NONE}))
        | munchExp (T.BINOP(T.ARSHIFT, e1, e2)) = result(fn r => emit(A.OPER{
            assem="srl `d0 `s0 `s1\n",
            src=[munchExp(e1), munchExp(e2)],
            dst=[r],
            jump=NONE}))
        (* NOTE: these take $s and $t and store in $LO 
           TODO: verify $HI is not overflow because of mult *)
        | munchExp (T.BINOP(T.MUL, e1, e2)) = result(fn r => emit(A.OPER{
            assem="mult `s0 `s1\nmflo `d0\n",
            src=[munchExp(e1), munchExp(e2)],
            dst=[r],
            jump=NONE}))
        | munchExp (T.BINOP(T.DIV, e1, e2)) = result(fn r => emit(A.OPER{
            assem="div `s0 `s1\nmflo `d0\n",
            src=[munchExp(e1), munchExp(e2)],
            dst=[r],
            jump=NONE}))
        (* NOTE: these all take $s and $t and return $d *)
        | munchExp (T.BINOP(T.PLUS, e, T.CONST(i))) = result(fn r => emit(A.OPER{
            assem="addi `d0, `s0, " ^ int2str i ^ "\n",
            src=[munchExp(e)],
            dst=[r],
            jump=NONE}))
        | munchExp (T.BINOP(T.PLUS, T.CONST(i), e)) = result(fn r => emit(A.OPER{
            assem="addi `d0, `s0, " ^ int2str i ^ "\n",
            src=[munchExp(e)],
            dst=[r],
            jump=NONE}))
        | munchExp (T.BINOP(T.PLUS, e1, e2)) = result(fn r => emit(A.OPER{
            assem="add `d0, `s0, `s1\n",
            src=[munchExp(e1), munchExp(e2)],
            dst=[r],
            jump=NONE}))
        | munchExp (T.BINOP(T.MINUS, e, T.CONST(i))) = result(fn r => emit(A.OPER{
            assem="addi `d0, `s0, -" ^ int2str i ^ "\n",
            src=[munchExp(e)],
            dst=[r],
            jump=NONE}))
        | munchExp (T.BINOP(T.MINUS, e1, e2)) = result(fn r => emit(A.OPER{
            assem="sub `d0 `s0 `s1\n",
            src=[munchExp(e1), munchExp(e2)],
            dst=[r],
            jump=NONE}))
        | munchExp (T.BINOP(T.AND, e, T.CONST(i))) = result(fn r => emit(A.OPER{
            assem="and `d0 `s0 " ^ int2str i ^ "\n",
            src=[munchExp(e)],
            dst=[r],
            jump=NONE}))
        | munchExp (T.BINOP(T.AND, T.CONST(i), e)) = result(fn r => emit(A.OPER{
            assem="and `d0 `s0 " ^ int2str i ^ "\n",
            src=[munchExp(e)],
            dst=[r],
            jump=NONE}))
        | munchExp (T.BINOP(T.AND, e1, e2)) = result(fn r => emit(A.OPER{
            assem="and `d0 `s0 `s1\n",
            src=[munchExp(e1), munchExp(e2)],
            dst=[r],
            jump=NONE}))
        | munchExp (T.BINOP(T.OR, e, T.CONST(i))) = result(fn r => emit(A.OPER{
            assem="ori `d0 `s0 " ^ int2str i ^ "\n",
            src=[munchExp(e)],
            dst=[r],
            jump=NONE}))
        | munchExp (T.BINOP(T.OR, T.CONST(i), e)) = result(fn r => emit(A.OPER{
            assem="ori `d0 `s0 " ^ int2str i ^ "\n",
            src=[munchExp(e)],
            dst=[r],
            jump=NONE}))
        | munchExp (T.BINOP(T.OR, e1, e2)) = result(fn r => emit(A.OPER{
            assem="or `d0 `s0 `s1\n",
            src=[munchExp(e1), munchExp(e2)],
            dst=[r],
            jump=NONE}))
        | munchExp (T.BINOP(T.LSHIFT, e1, e2)) = result(fn r => emit(A.OPER{
            assem="sllv `d0 `s0 `s1\n",
            src=[munchExp(e1), munchExp(e2)],
            dst=[r],
            jump=NONE}))
        | munchExp (T.BINOP(T.RSHIFT, e1, e2)) = result(fn r => emit(A.OPER{
            assem="srlv `d0 `s0 `s1\n",
            src=[munchExp(e1), munchExp(e2)],
            dst=[r],
            jump=NONE}))
        | munchExp (T.BINOP(T.XOR, T.CONST(i), e)) = result(fn r => emit(A.OPER{
            assem="xori `d0 `s0 " ^ int2str i ^ "\n",
            src=[munchExp(e)],
            dst=[r],
            jump=NONE}))
        | munchExp (T.BINOP(T.XOR, e, T.CONST(i))) = result(fn r => emit(A.OPER{
            assem="xori `d0 `s0 " ^ int2str i ^ "\n",
            src=[munchExp(e)],
            dst=[r],
            jump=NONE}))
        | munchExp (T.BINOP(T.XOR, e1, e2)) = result(fn r => emit(A.OPER{
            assem="xor `d0 `s0 `s1\n",
            src=[munchExp(e1), munchExp(e2)],
            dst=[r],
            jump=NONE}))
        
        | munchExp(T.MEM(T.BINOP(T.PLUS, e, T.CONST i))) = result(fn r => emit(A.OPER{
            assem="lw `d0 " ^ int2str i ^ "(`s0)\n",
            src=[munchExp(e)],
            dst=[r],
            jump=NONE}))

        | munchExp(T.MEM(T.BINOP(T.PLUS, T.CONST i, e))) = result(fn r => emit(A.OPER{
            assem="lw `d0 " ^ int2str i ^ "(`s0)\n",
            src=[munchExp(e)],
            dst=[r],
            jump=NONE}))

        | munchExp(T.MEM(T.CONST i)) = result(fn r => emit(A.OPER{
            assem="lw `d0 " ^ int2str i ^ "(`s0)\n",
            src=[Frame.ZERO],
            dst=[r], 
            jump=NONE}))

        | munchExp (T.MEM(e)) = result(fn r => emit(A.OPER{
            assem="lw `d0 (`s0)\n",
            src=[munchExp(e)],
            dst=[r],
            jump=NONE}))
        
        | munchExp (T.TEMP(t)) = t
        
        | munchExp (T.ESEQ(s,e)) = munchExp (T.CONST 0)
        
        | munchExp (T.NAME(l)) = result(fn r => emit(A.OPER{
            assem="lw `d0 , " ^ S.name l ^ "\n",
            src=[],
            dst=[r],
            jump=NONE}))
        
        | munchExp (T.CONST i) = result(fn r => emit(A.OPER
            {assem="addi `d0, `s0, " ^ int2str i ^ "\n", 
             src=[Frame.ZERO],
             dst=[r], 
             jump=NONE}))

        | munchExp (T.CALL(T.NAME L, args)) = (
            emit(A.OPER{
                assem="jal " ^ S.name L ^ "\n",
                src=munchArgs(0,args), 
                dst=Frame.calldefs,
                jump=NONE}); 
             emit(A.OPER{
                assem="",
                src=Frame.calldefs, 
                dst=[],
                jump=NONE}); 
             Frame.RV
            )

        | munchExp (T.CALL(e, args)) = raise JALRRaised
          (*result(fn r => (
              emit(A.OPER{
                  assem="jalr `s0" ^ S.name L ^ "\n",
                  src=munchArgs(0,args), 
                  dst=Frame.calldefs,
                  jump=NONE}); 
              Frame.RV
                  )
            )
        
        | munchExp (T.CALL(e, args)) = munchExp (T.CONST 1)
           *)
        
    in munchStm stm;
        rev(!ilist)
    end
end
