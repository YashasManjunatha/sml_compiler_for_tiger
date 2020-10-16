structure A = Absyn
structure T = Types
structure S = Symbol
structure ERR = ErrorMsg

structure ORD_INT = struct type ord_key = int; val compare = Int.compare end
structure Graph =  FuncGraph(ORD_INT)
structure Map = SplayMapFn(ORD_INT)
structure Set = SplaySetFn(ORD_INT)
