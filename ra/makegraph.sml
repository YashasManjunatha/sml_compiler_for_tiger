
structure MakeGraph: 
sig
  val instrs2graph: Assem.instr list -> Flow.flowgraph * Assem.instr Graph.node list
end
= 
struct
  structure G = Graph
  structure SM = SplayMapFn(type ord_key=Symbol.symbol; 
    val compare= fn(s1, s2) => String.compare (Symbol.name s1, Symbol.name s2))

  exception LabelNotFound

  fun instrs2graph (instrs) = 
    let
      fun printNode (nid, instr) = 
        Int.toString nid ^ "\n" ^
        (Assem.format MipsFrame.getRegName instr) 

      val numberedNodes = 
        List.tabulate (List.length instrs, fn(i) => (i, List.nth (instrs, i)))

      val nodeGraph  = 
        foldl 
          (fn((i, ins), g) => G.addNode(g, i, ins)) 
          G.empty
          numberedNodes

      val labelMap = 
        foldl 
          (fn((i, ins), m) => case ins of 
                              Assem.LABEL{lab, ...} => SM.insert(m, lab, i)
                            | _ => m)
           SM.empty 
           numberedNodes

      fun makeEdgeTo fromNodeIndex (label, g) = 
        (case SM.find(labelMap, label) of 
             SOME(toNode) => (

             print( Int.toString fromNodeIndex ^ " -> " 
             ^ S.name label ^  " " ^ Int.toString toNode ^ "\n");

             G.addEdge(g, {from=fromNodeIndex, to=toNode}))
           | NONE => raise LabelNotFound
           )


      fun addFlowToNext(g, i) =
        if i < List.length numberedNodes 
        then G.addEdge(g, {from=i, to=i + 1})
        else g

      val instrGraph = 
        foldl
        (fn((i, ins), g) => (case ins of 
                                  Assem.OPER{jump, ...} => 
                                    if isSome(jump) 
                                    then (foldl (makeEdgeTo i) g (valOf(jump))) 
                                    else addFlowToNext(g, i)
                                | _ => addFlowToNext(g, i)
                              ))
         nodeGraph numberedNodes

      fun getDef (Assem.OPER{dst, ...}) = dst
        | getDef (Assem.MOVE{dst, ...}) = [dst]
        | getDef _ = [] 

      fun getUse (Assem.OPER{src, ...}) = src
        | getUse (Assem.MOVE{src, ...}) = [src]
        | getUse _ = [] 

      fun getMoves (Assem.MOVE{...}) = true
        | getMoves _ = false

    in
      (*G.printGraph printNode instrGraph;
      print ("\n Instruction List Length: " ^ 
             Int.toString (List.length instrs) ^ "\n");*)
      (Flow.FGRAPH{
        control=instrGraph,

        def = foldl 
          ( fn((i, ins), g) => G.NodeMap.insert(g, i, getDef ins) )
          G.NodeMap.empty 
          numberedNodes,

        use = foldl 
          ( fn((i, ins), g) => G.NodeMap.insert(g, i, getUse ins) )
          G.NodeMap.empty 
          numberedNodes,

        ismove=foldl 
          ( fn((i, ins), g) => G.NodeMap.insert(g, i, getMoves ins) )
          G.NodeMap.empty 
          numberedNodes
      }, G.nodes instrGraph)

    end
end
