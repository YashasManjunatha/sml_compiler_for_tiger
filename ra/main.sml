structure Main = struct

   structure Tr = Translate
   structure F = MipsFrame

   fun getsome (SOME x) = x

   fun emitproc out (F.PROC{body,frame}) =
     let 
       val _ = print ("emit " ^ S.name (F.name frame) ^ "\n")
       (* val _ =  TextIO.output(out, "\n\nFUNCTION BODY \n")
       val _ = Printtree.printtree(out,body) *)
	     val stms = Canon.linearize body
(*     val _ = app (fn s => Printtree.printtree(out,s)) stms; *)
       val stms' = Canon.traceSchedule(Canon.basicBlocks stms)
       (*val _ =  TextIO.output(out, "\n\nCANNONIZED BODY \n")
       val _ = app (fn s => Printtree.printtree(out,s)) stms *)
       val instrs =   List.concat(map 
        (fn(stm) => F.procEntryExit2(frame, (Mips.codegen frame stm)))
        stms')
       val format0 = Assem.format(Temp.makestring)
       val format1 = Assem.format(F.getRegName)
       val (instrs', regalloc) = RegAlloc.alloc(instrs, frame)
       
       fun formatByAlloc (reg) = case Map.find(regalloc, reg) of 
                                      SOME(x) => x
                                    | NONE => F.getRegName(reg)
       val format2 = Assem.format(formatByAlloc)
       val _ = TextIO.output(out,  "\n")
       
     in  
       (* app (fn i => Printtree.printtree(out, i)) stms' *)
       app (fn i => TextIO.output(out,format2 i)) instrs
     end
    | emitproc out (F.STRING(lab,s)) = TextIO.output(out,F.string(lab,s))
   
  fun withOpenFile fname f = 
       let val out = TextIO.openOut fname
        in (f out before TextIO.closeOut out) 
	    handle e => (TextIO.closeOut out; raise e)
       end 

  fun compile filename = (
       Translate.resetFragList();
       let val absyn = Parse.parse filename
           val frags = (FindEscape.prog absyn; Semant.transProg absyn)
        in 
            withOpenFile (filename ^ ".s") 
	     (fn out => (app (emitproc out) frags))
       end
       )

end



