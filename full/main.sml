structure Main = struct

   structure Tr = Translate
   structure F = MipsFrame

   fun getsome (SOME x) = x

   fun emitproc out (F.PROC{body,frame}) =
     let 
       val _ = print ("emit " ^ S.name (F.name frame) ^ "\n")
       (*val _ = print("Formals Length: " ^ Int.toString(List.length (F.formals
       frame)) ^ "\n") *)
       (*val _ = TextIO.output(out, "\n\nFRAME: " ^ S.name (F.name frame) ^ "\n")
       val _ =  TextIO.output(out, "FUNCTION BODY \n")
       val _ = Printtree.printtree(out,body) *)
	     val stms = Canon.linearize body
(*     val _ = app (fn s => Printtree.printtree(out,s)) stms; *)
       val stms' = Canon.traceSchedule(Canon.basicBlocks stms)
       (*val _ =  TextIO.output(out, "\n\nCANNONIZED BODY \n")
       val _ = app (fn s => Printtree.printtree(out,s)) stms  *)
       val instrs =  List.concat(map 
        (fn(stm) => (Mips.codegen frame stm))
        stms')
       (* val instrs = F.procEntryExit2(frame, instrs) *)

       val (instrs', regalloc) = RegAlloc.alloc(instrs, frame) handle e =>
       (print("Could not allocate registers"); raise e)
       
       val format0 = Assem.format(Temp.makestring)
       val format1 = Assem.format(F.getRegName)
       val format2 = Assem.format(fn(t) => valOf(Map.find(regalloc, t)))
       val format3 = Assem.format(fn(t) => valOf(Map.find(regalloc, t)) ^ " (" ^ Temp.makestring t ^ ")")
       (*
        * val () = app (fn(t, reg) => print("Reg " ^ Int.toString t ^ " -> " ^ reg ^ " \n")) (Map.listItemsi regalloc)
        *)


       val _ = TextIO.output(out,  "\n")
       
     in  
       (* app (fn i => Printtree.printtree(out, i)) stms' *)
       app (fn i => TextIO.output(out,format2 i)) instrs'
     end
    | emitproc out (F.STRING(lab,s)) = TextIO.output(out,F.string(lab,s))
   
  fun withOpenFile fname f = 
       let val out = TextIO.openOut fname
        in (f out before TextIO.closeOut out) 
	    handle e => (TextIO.closeOut out; raise e)
       end 

  fun appendFile(filename, outstream) =
    let 
      val instream = TextIO.openIn(filename)
    in
      TextIO.output(outstream, "\n");
      TextIO.output(outstream, TextIO.inputAll(instream));
      TextIO.output(outstream, "\n");
      TextIO.closeIn(instream)
    end

  fun compile filename = (
       print("RV = " ^ Temp.makestring F.RV ^ "\n");
       print("FP = " ^ Temp.makestring F.FP ^ "\n");
       Translate.resetFragList();
       let 

         fun isStringFrag (F.STRING(_, _)) = true
           | isStringFrag (F.PROC{...}) = false

         val absyn = Parse.parse filename
         val frags = (FindEscape.prog absyn; Semant.transProg absyn)
         val stringFrags = List.filter isStringFrag frags
         val procFrags = List.filter (fn(f) => not (isStringFrag(f))) frags
        in 
          withOpenFile (filename ^ ".s") 
          (fn out => (
            TextIO.output(out, ".data\n");
            app (emitproc out) stringFrags;
            TextIO.output(out, "\n.text\n");
            TextIO.output(out, "tig_main:\n");
            app (emitproc out) procFrags;
            appendFile("runtimele.s", out);
            appendFile("sysspim.s", out)
          ))
       end
       )

end



