signature COLOR =
sig
  structure Frame : FRAME 
  type allocation = Frame.register Map.map
  val color: {interference: Liveness.igraph, 
              initial: allocation,
              spillCost: Temp.temp Graph.node -> int, 
              registers: Frame.register list} 
              -> allocation * Temp.temp list
end

structure Color : COLOR = struct
  structure Frame = MipsFrame
  structure SS = SplaySetFn(type ord_key=string; val compare=String.compare)
  datatype stackItem = SIMPLE of Temp.temp Graph.node
                     | POTENTIAL_SPILL of Temp.temp Graph.node

  type allocation = MipsFrame.register Map.map
  fun color ({
      interference=Liveness.IGRAPH{graph=original_graph, tnode, gtemp, moves}, 
      initial, 
      spillCost, 
      registers
    }) =
    let
      val numColors = List.length registers
      val colorSet = foldl SS.add' SS.empty registers
      (*
       * val () = 
          app 
          (fn(c) => (print("Color Available: " ^ c ^ "\n")))
          (SS.listItems colorSet)
       *)
        
      fun isNotPrecolored(node) = not (isSome(Map.find(initial, Graph.getNodeID node)))
      fun printNodeList(l) = 
        let
          fun format(n) = ", " ^ Frame.getRegName(Graph.getNodeID n)
          val nodestring = String.concat(map format l)
        in
          print("Nodes: " ^ nodestring ^ "\n")
        end
        

      fun simplify(graph, stack) = 
        let 
          fun checkNode(node, (g, s)) =
            if (Graph.degree node < numColors andalso isNotPrecolored(node))
            then (Graph.remove(g, node), SIMPLE(node)::s)
            else (g, s)

          val originalNodes = Graph.nodes graph
          val (graph', stack') = foldl checkNode (graph, stack) originalNodes
        in
          if List.length (Graph.nodes graph) = List.length originalNodes
          then (graph', stack')
          else simplify(graph', stack')
        end

      fun issuePotentialSpill(graph, stack) = 
        let 
          val nodes  = List.filter isNotPrecolored (Graph.nodes graph)
          fun takeLowerSpillCost (a, b) = 
            if spillCost(a) < spillCost(b) then a else b
          val spill = foldl takeLowerSpillCost (List.hd nodes) nodes
          (*val () = print("Potenail Spill: " ^ Int.toString
           * (Graph.getNodeID(spill)))*)
        in
          (Graph.remove(graph, spill), POTENTIAL_SPILL(spill)::stack)
        end

      fun simplifyToEmptyStack(graph, stack) = 
        let
          val (simpleG, simpleS) = simplify(graph, stack)
          val nonColoredNodes = List.filter isNotPrecolored (Graph.nodes simpleG)
          (*val () = printNodeList(nonColoredNodes) *)
          val simplifiedIsEmpty = List.length(nonColoredNodes) = 0
        in
          if simplifiedIsEmpty
          then simpleS
          else simplifyToEmptyStack(issuePotentialSpill(simpleG, simpleS))
        end

      fun select(stack) = 
        let 
          fun pickColor (allocation, node) = 
            let
              val (nid, _, _, _) = node
              fun assignedFilter nid = isSome(Map.find(allocation, nid))
              val assignedNodes = List.filter assignedFilter (Graph.adj node)
              fun updateAssignedRegs ((nid, _, _, _), s) = 
                case Map.find(allocation, nid) of 
                     SOME(reg) => SS.add(s, reg)
                   | NONE => s

              fun printAdj(nid) = 
                let
                  val adjset = Graph.adj(node)
                  fun nodeStr nid = ", " ^ MipsFrame.getRegName(nid)
                  val tempListStr = String.concat(map nodeStr adjset)
                in
                  print("NID " ^ Int.toString (nid) ^ " -> " ^ tempListStr ^ "\n")
                end
              (* val() = printAdj(nid) *)

              val assignedRegs = 
                foldl 
                updateAssignedRegs 
                SS.empty 
                (map (fn(id) => Graph.getNode(original_graph, id)) (Graph.adj node))


              val availableRegs = SS.difference(colorSet, assignedRegs)
            in
              if isSome(Map.find(allocation, nid)) 
              then Map.find(allocation, nid)
              else 
                if SS.isEmpty(availableRegs) 
                then NONE 
                else SOME(List.hd (SS.listItems availableRegs))
                
            end

          fun updateAllocation(SIMPLE(node), (allocation, spilledTemps)) =
                let
                  val (t, _, _, _) = node
                in
                  (Map.insert(allocation, t, valOf(pickColor(allocation, node))), spilledTemps)
                end

            | updateAllocation(POTENTIAL_SPILL (node),  (allocation, spilledTemps)) =
                let
                  val (t, _, _, _) = node
                in
                  (*print("Potentially Spilling: " ^ Int.toString(t) ^ "\n"); *)
                  case pickColor(allocation, node) of 
                       SOME(reg) => (Map.insert(allocation, t, reg), spilledTemps)
                     | NONE => (Map.insert(allocation, t, "UNDEFINED"),  t::spilledTemps)
                end
        in
          foldl updateAllocation (initial, []) stack
        end 

      val stack = simplifyToEmptyStack(original_graph, [])
      fun printStackItem(POTENTIAL_SPILL(node)) = print("PS(" ^ Frame.getRegName (Graph.getNodeID node) ^")\n")
        | printStackItem(SIMPLE(node)) = print("N(" ^ Frame.getRegName (Graph.getNodeID node) ^ ")\n")
      
      fun nodeStr(nid, data) = MipsFrame.getRegName(nid)
    in
      (
      (* Graph.printGraph nodeStr original_graph; *)
      (* app printStackItem stack ; *)
      select(stack))
    end
  end
