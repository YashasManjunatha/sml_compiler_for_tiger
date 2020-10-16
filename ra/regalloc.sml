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
      val (flowGraph, nodes) = MakeGraph.instrs2graph(instrs)
      val (igraph, getLiveOut) = Liveness.interferenceGraph(flowGraph)
      val args = {
            interference=igraph,
            initial = MipsFrame.tempMap,
            spillCost = (fn(a) => 1),
            registers = map 
              (fn(t) => valOf(Map.find(MipsFrame.tempMap, t)))
              (MipsFrame.callersaves )
          }

      val (finalAlloc, spills) = Color.color(args) 
      val () = if List.length spills = 0 
               then () 
               else ERR.error 0 "Spills detected and unaccounted for in register allocation"
    in
      (instrs, finalAlloc)
    end
end
