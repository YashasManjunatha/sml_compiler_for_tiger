structure IGraph = FuncGraph(
    type ord_key = Temp.temp; val compare = Int.compare
  )

structure Liveness: 
sig
  type igraph
  val interferenceGraph : Flow.flowgraph -> igraph * (Assem.instr Flow.Graph.node -> Temp.temp list)
  val show : TextIO.outstream * igraph -> unit 
end =

struct
  structure G = Flow.Graph 
  structure Set = SplaySetFn(type ord_key  = Temp.temp; val compare = Int.compare)

  datatype igraph =
  IGRAPH of { graph: Temp.temp IGraph.graph,
              tnode: Temp.temp -> Temp.temp IGraph.node,
              gtemp: Temp.temp IGraph.node -> Temp.temp,
              moves: (Temp.temp IGraph.node * Temp.temp IGraph.node) list}

  fun formatTempNode(nid, data) = Int.toString nid ^ ": " ^ MipsFrame.getRegName data ^ "\n"
  fun formatTempNodeExcludeSpecial (nid, data) = 
    if (List.exists (fn(r) => (data = r)) (MipsFrame.specialregs @ MipsFrame.calleesaves))
    then ""
    else formatTempNode(nid, data)

  fun fmtRegExcludeSpecial(reg) = 
    if (List.exists (fn(r) => (reg = r)) (MipsFrame.specialregs @ MipsFrame.calleesaves))
    then ""
    else MipsFrame.getRegName(reg)

    fun show (os, IGRAPH{graph, tnode, gtemp, moves}) = 
    let 
      val nodes = IGraph.nodes graph
      fun nodeStr (nid, data) = 
        "Node " ^ Int.toString nid ^ ": " ^ 
        MipsFrame.getRegName(data) ^ "\n"
    in
      IGraph.printGraphToOut os formatTempNodeExcludeSpecial graph
    end

  fun printLivenessMap(liveIn, liveOut, control) = 
    let
      fun list2string (tempList) = 
        foldl 
          (fn(t, s) => 
            if (List.exists (fn(reg) => (reg = t)) (MipsFrame.specialregs @ MipsFrame.calleesaves))
            then s 
            else s ^ ", " ^ MipsFrame.getRegName t)
          ""  
          tempList

      fun prItem(i) = print(
        "Instr " ^ Int.toString i ^ ": " ^
        (Assem.format MipsFrame.getRegName (G.nodeInfo(G.getNode(control, i)
        handle e => raise e))) ^ 
        "\nIn: " ^ list2string (valOf(G.NodeMap.find(liveIn, i))) ^ 
        "\nOut: " ^ list2string (valOf(G.NodeMap.find(liveOut, i))) ^ "\n---\n"
        )
    in
      (
        print( "################## STARTING PRINT FOR NEW LIVENESS MAP ##################");
        G.NodeMap.appi (fn (i, _) => prItem(i)) liveIn
      )
    end

  fun computeLiveness (def, use, liveIn, liveOut, nodes) = 
    let
      val liveIn' = liveIn
      val liveOut' = liveOut

      fun calcIn (useL, outL, defL) =
        let
          val useS = Set.fromList(useL)
          val outS = Set.fromList(outL)
        in
          Set.union(useS, Set.subtractList(outS, defL))
        end
      
      fun calcOut (liveInArg, succ_ids) =
        Set.fromList(foldl 
                     ( fn(s, l) => l @ valOf(G.NodeMap.find(liveInArg, s)))
                     []
                     succ_ids)

      fun applyDataflowEquations(i, succ_ids, liveInArg, liveOutArg, nothingChangeArg) =
       let
        val new_in_set = calcIn(valOf(G.NodeMap.find(use, i)),
                                valOf(G.NodeMap.find(liveOutArg, i)),
                                valOf(G.NodeMap.find(def, i)))
        val new_out_set = calcOut(liveInArg, succ_ids)
        val old_in_set = Set.fromList(valOf(G.NodeMap.find(liveInArg, i))) 
        val old_out_set = Set.fromList(valOf(G.NodeMap.find(liveOutArg, i)))
        val nothingChanged = Set.isSubset(new_in_set, old_in_set) andalso 
                             Set.isSubset(old_in_set, new_in_set) andalso 
                             Set.isSubset(new_out_set, old_out_set) andalso 
                             Set.isSubset(old_out_set, new_out_set) andalso
                             nothingChangeArg
        val liveIn' = G.NodeMap.insert(liveInArg, i, Set.toList(new_in_set))
        val liveOut' = G.NodeMap.insert(liveOutArg, i, Set.toList(new_out_set))
       in
         ((liveIn', liveOut'), nothingChanged) (* ALL LIVEIN LIVEOUT *)
       end

      fun applySuccessiveDFE(liveInArg, liveOutArg) = 
        let
          val ((liveIn', liveOut'), nothing_changing) =  foldl
                                      (fn ((i, _, s, _), ((lI, lO), yes)) => applyDataflowEquations(i, G.NodeSet.toList(s), lI, lO, yes) )
                                      ((liveInArg, liveOutArg), true)
                                      nodes
        in
          if nothing_changing 
          then (liveIn', liveOut')
          else applySuccessiveDFE(liveIn', liveOut')
        end
    in
      applySuccessiveDFE(liveIn,liveOut)
    end

  fun interferenceGraph (flowgraph) = 
    let
      val Flow.FGRAPH{control, def, use, ismove} = flowgraph
      val nodes = G.nodes control 
      val liveIn: Temp.temp list G.NodeMap.map = foldl 
                            ( fn((i, _, _, _), g) => G.NodeMap.insert(g, i, []) )
                            G.NodeMap.empty
                            nodes
      val liveOut: Temp.temp list G.NodeMap.map = foldl 
                            ( fn((i, _, _, _), g) => G.NodeMap.insert(g, i, []) )
                            G.NodeMap.empty
                            nodes
      val (liveIn', liveOut') = computeLiveness(def, use, liveIn, liveOut,
      nodes) handle e => raise e
      
      fun getLiveOut (i,_,_,_) = valOf(G.NodeMap.find(liveOut', i))

      val igraph = 
        let 
          val allTemps = List.concat(G.NodeMap.listItems def) @ List.concat(G.NodeMap.listItems use)
          fun addTempToIgraph(t, g) = IGraph.addNode(g, t, t)
        in
          foldl addTempToIgraph IGraph.empty allTemps
        end

      fun addInstructionNodeEdges((i, _, _, _), igr) =
        let 
          val instructionLiveOuts = valOf(G.NodeMap.find(liveOut', i))
          fun addSingleDefEdges ig (defReg) = 
            foldl 
              (fn(liveOutTemp, g) => (if liveOutTemp = defReg then g else IGraph.addEdge(g, {from=defReg,
               to=liveOutTemp}) 
                  handle e => (
                    print ("Instruction " ^ Int.toString i ^ "\n"); 
                    print ("IGR Nodes: " ^ String.concatWith " " (map (fn (_, d, _, _)
                    => MipsFrame.getRegName d) (IGraph.nodes igr)) ^ "\n");
                    print("Def Reg: " ^ MipsFrame.getRegName defReg ^ "\n");
                    print("Live Out: " ^ MipsFrame.getRegName liveOutTemp);
                    raise e)))
              ig
              instructionLiveOuts
            handle e => ( raise e)
        in
          foldl 
            (fn(defReg, g) => addSingleDefEdges g defReg) 
            igr 
            (valOf(G.NodeMap.find(def, i)))
          handle e => raise e
        end

      val igraph' = foldl addInstructionNodeEdges igraph (G.nodes control)

      (*val () = IGraph.printGraph formatTempNodeExcludeSpecial igraph'*)

      val moveList = 
        let
          val moveinstrs = G.NodeMap.filter 
                           (fn (i, _, _, _)  => valOf(G.NodeMap.find(ismove, i)))
                           control
          exception FailedMoveInstrs                 
          fun getMoveTuple (Assem.MOVE{src, dst, ...}) =
                (IGraph.getNode(igraph', src) handle e => raise e, 
                 IGraph.getNode(igraph', dst) handle e => raise e)
            | getMoveTuple _ = raise FailedMoveInstrs
        in
          map (fn(instrNode) => getMoveTuple(G.nodeInfo(instrNode))) (G.NodeMap.listItems moveinstrs)
          handle e => raise e
        end
      
      val return_igraph = IGRAPH{ graph = igraph',
              tnode = fn(t) => IGraph.getNode(igraph', t),
              gtemp = fn(node) => IGraph.nodeInfo(node),
              moves = moveList}
      val outfile = TextIO.openOut "liveness.out"
    in
      show(outfile, return_igraph) before TextIO.closeOut outfile;
      (return_igraph,
      getLiveOut)

      (* printLivenessMap(liveIn, liveOut); *)
      (* printLivenessMap(liveIn', liveOut', control); *)
      (*app ( fn(node) => getLiveOut(node))) valOf(G.NodeMap.find(liveOut', 0));*)
    end


end
