structure MipsFrame: FRAME = 
  struct
    type register = string
    datatype access = InFrame of int | InReg of Temp.temp
    datatype frame = FRAME of { name: Temp.label, 
                                formals: access list, 
                                localsAllocated: int ref
                              }
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

    val calldefs = argregs @ callersaves @ specialregs 
    val tempMap = foldl
      (fn( (temp, str), tab) => Map.insert(tab, temp, str))
      Map.empty (
      [
        (ZERO, "$0"),
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
       (List.mapi( fn(i, item) => (item, "$a" ^ Int.toString i)) argregs) @
       (List.mapi( fn(i, item) => (item, "$t" ^ Int.toString i)) callersaves) @
       (List.mapi( fn(i, item) => (item, "$s" ^ Int.toString i)) calleesaves)
       )
    fun getRegName t = (case Map.find(tempMap, t) of 
                                       SOME(s) => s
                                     | NONE => "$" ^ Temp.makestring t)


    val registers = map 
      (fn(t) => valOf(Map.find(tempMap, t)))
      (callersaves @ calleesaves) (*@ argregs @ [RV, RV2])*)

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
          | mapToFrame(a::l, complete, n) = 
              mapToFrame(l, complete @ [InFrame(wordSize * n)], n+1) (* Can do this because we assume all paramaters escape *)

      in FRAME{
                name=name, 
                formals=mapToFrame (formals, [], 0),
                localsAllocated=ref 0
              }
      end

    fun name (FRAME{name=n, ...}:frame): Temp.label = n

    fun formals (FRAME{formals=f, ... }:frame): access list = f

    fun localsAllocated  (FRAME{localsAllocated, ... }:frame) = !localsAllocated

    fun allocLocal (FRAME{localsAllocated, formals, ...}:frame) (isInFrame) = 
      if isInFrame 
      then (
        localsAllocated := (!localsAllocated + 1); 
        InFrame(~(!localsAllocated) * wordSize)
      )
      else (InReg(Temp.newtemp()))

    fun exp (a:access) (fp:Tree.exp) = 
      case a of 
           InFrame(x) => Tree.MEM(Tree.BINOP(Tree.PLUS, fp, Tree.CONST x))
         | InReg(x) => Tree.TEMP x


    fun string (lab, s) = 
      let 
        fun formatChar #"\n" = "\\n"
          | formatChar #"\t" = "\\t"
          | formatChar c = Char.toString c
        
        val s' = String.translate formatChar s
        val slen = String.size(s)
        val lab' = S.name lab
        
      in
        String.concat([
        lab', ":\n .word ", lab', "_data\n",
        lab', "_data:\n .word ", Int.toString(slen) , "\n .ascii \"", s', "\"\n"]) 
      end

    fun externalCall (s, args) = Tree.CALL(Tree.NAME(Temp.namedlabel s), args)
   
    fun procEntryExit1(FRAME{name, formals, ...},  body:Tree.stm):Tree.stm = 
      let 
        fun moveArg (argNum) = 
          Tree.MOVE(
            exp(List.nth(formals, argNum)) (Tree.TEMP FP), 
            Tree.TEMP (List.nth(argregs, argNum))
           )
        val beginning = List.tabulate(List.length formals, moveArg)
      in
          Tree.SEQ(beginning @ [body])
      end

    fun intstr (n) = if n >= 0 then Int.toString(n) else "-" ^ Int.toString(~n)

    fun procEntryExit3(FRAME{name, formals, localsAllocated}, body, numCalleeSavesUsed) = 
      let
        val argSpaceSize = wordSize * List.length formals
        val localsSize = wordSize * !localsAllocated
        val savedRegsSize = wordSize * (2 + numCalleeSavesUsed)
        val frameSize = argSpaceSize + localsSize +  savedRegsSize

        fun makeSRegSaveInsn(temp, index) = 
          Assem.OPER { 
            assem="sw `s0 "^ intstr((wordSize * (index))) ^
            "(`s1)\n",
            src=[temp, SP], dst=[], jump=NONE
          }

        fun makeSRegLoadInsn(temp, index) = 
          Assem.OPER { 
            assem="lw `d0 "^ intstr((wordSize * (index))) ^
            "(`s0)\n",
            src=[SP], dst=[temp], jump=NONE
          }

        val (saveIns, _) = foldl 
                        (fn(temp, (insList, index)) => 
                          (insList @ [makeSRegSaveInsn(temp, index)], index + 1))
                        ([], 0)
                        (RA::FP::List.take(calleesaves, numCalleeSavesUsed))

        val (loadIns, _) = foldl 
                        (fn(temp, (insList, index)) => 
                          (insList @ [makeSRegLoadInsn(temp, index)], index + 1))
                        ([], 0)
                        (RA::FP::List.take(calleesaves, numCalleeSavesUsed))


        val prologIns = [
          (* Function Label *)
          Assem.LABEL{ assem=S.name name ^ ":\n",                                             lab=name},
          (* Allocated Incoming Stack  Space *)
          Assem.OPER { assem="addi `d0 `s0 " ^ intstr (~frameSize) ^ "\n",                 src = [SP], dst = [SP], jump = NONE }
                        ] @
          (* Preserve registers from previous stack *)
          saveIns @
                        [
          (* Set Frame Pointer *)
          Assem.OPER { assem="addi `d0 `s0 " ^ intstr(savedRegsSize + localsSize) ^ "\n",  src = [SP], dst = [FP], jump = NONE }
                        ]

        val epilogIns = loadIns @ [
        (*
          (* Load the Return Address *)
          Assem.OPER { assem="lw `d0 " ^ intstr raOffset ^ "(`s0)\n", src=[FP], dst=[RA], jump=NONE },
          (* Load the old frame pointer *)
          Assem.OPER { assem="lw `d0 (`s0) \n", src=[FP], dst=[FP], jump = NONE } ,
           *)
          (* Deallocate stack *)
          Assem.OPER { assem="addi `d0 `s0 " ^ intstr(frameSize) ^ "\n", src = [SP], dst = [SP], jump = NONE },
          (* Jump to return address *)
          Assem.OPER { assem="jr `s0\n", src=(RA::calleesaves@specialregs), dst=[], jump=SOME[] }
                        ]
      in
        {
          prolog = "PROCEDURE " ^ Symbol.name name ^ "\n", 
          body = 
            prologIns @  
            body 
            @ epilogIns 
            ,
          epilog = "END " ^ Symbol.name name ^ "\n"
        }
      end

    fun procEntryExit(f:frame, t:Tree.stm):unit = ()
          
  end
