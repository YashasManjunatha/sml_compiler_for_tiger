structure Env : ENV = 
struct
  type access = unit
  type ty = Types.ty

  datatype enventry = VarEntry of {ty: ty}
                      | FunEntry of {formals: ty list, result : ty}
  
  fun add2Table( (s, t), table) = Symbol.enter(table, Symbol.symbol s, t)
  
  val base_tenv = foldl add2Table  Symbol.empty [
    ("int", Types.INT), ("string", Types.STRING)
                                                 ]
  
  val base_venv = foldl add2Table  Symbol.empty [
    ("print", FunEntry ({formals=[Types.STRING], result=Types.UNIT})),
    ("flush", FunEntry ({formals=[], result=Types.UNIT})),
    ("getchar", FunEntry ({formals=[], result=Types.STRING})),
    ("ord", FunEntry ({formals=[Types.STRING], result=Types.INT})),
    ("chr", FunEntry ({formals=[Types.INT], result=Types.STRING})),
    ("size", FunEntry ({formals=[Types.STRING], result=Types.INT})),
    ("substring", FunEntry ({formals=[Types.STRING, Types.INT, Types.INT], result=Types.STRING})),
    ("concat", FunEntry ({formals=[Types.STRING, Types.STRING], result=Types.STRING})),
    ("not", FunEntry ({formals=[Types.INT], result=Types.INT})),
    ("exit", FunEntry ({formals=[Types.INT], result=Types.UNIT}))
                                                 ]
end
