signature REG_ALLOC = sig
  structure Frame : FRAME
  type allocation = Frame.register Map.map
  val alloc : Assem.instr list * Frame.frame -> Assem.instr list * allocation
end

structure RegAlloc: REG_ALLOC = struct
  structure Frame = MipsFrame
  type allocation = MipsFrame.register Map.map
  fun alloc(instrs, frame) = 
    let
      fun allocWithNSReg(n) = 
        let
          val {prolog, body=instrs'', epilog} = 
            Frame.procEntryExit3(frame, instrs, n)

          val (flowGraph, nodes) = MakeGraph.instrs2graph(instrs'') handle e => raise e
          (* val () = print("Nodes: " ^ Int.toString (List.length nodes) ^ "\n")  *)
          val (igraph, getLiveOut) = Liveness.interferenceGraph(flowGraph) handle e => raise e

          val args = {
                interference=igraph,
                initial = Frame.tempMap,
                spillCost = (fn(a) => 1),
                registers = 
                  map 
                  Frame.getRegName 
                  (Frame.callersaves @ List.take(Frame.calleesaves, n))
              }
            
          val (finalAlloc, spills) = Color.color(args)
        in
          (instrs'', finalAlloc, spills) 
        end

      fun incrementSRegs(n) = 
          let 
            val (finalInstrs, allocation, spills) = allocWithNSReg(n)
          in
            if List.length spills = 0 
            then (finalInstrs, allocation)
            else 
              if n = 8
              then 
                (ERR.error 0 "Spilled register not accounted for";
                (finalInstrs, allocation))
              else incrementSRegs(n+1)
          end
    in
      incrementSRegs(0)
    end
end
