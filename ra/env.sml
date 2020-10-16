structure Env : ENV = 
struct
  type access = Translate.access
  type ty = Types.ty

  datatype enventry = VarEntry of {
                        access:access,
                        ty: ty}
                    | FunEntry of {
                        level: Translate.level, 
                        label: Temp.label,
                        formals: ty list, 
                        result: ty}
  
  fun add2Table( (s, t), table) = Symbol.enter(table, Symbol.symbol s, t)
  
  val base_tenv = foldl add2Table  Symbol.empty [
    ("int", Types.INT), ("string", Types.STRING)
                                                 ]
  fun add2EnvFunction( (s, formals, result), table) = Symbol.enter(table, Symbol.symbol s, 
      FunEntry({formals=formals, result=result, label=Symbol.symbol s, level=Translate.outermost}))

  val base_venv = foldl add2EnvFunction Symbol.empty [
    ("print",     [Types.STRING],                       Types.UNIT   ),
    ("flush",     [],                                   Types.UNIT   ),
    ("getchar",   [],                                   Types.STRING ),
    ("ord",       [Types.STRING],                       Types.INT    ),
    ("chr",       [Types.INT],                          Types.STRING ),
    ("size",      [Types.STRING],                       Types.INT    ),
    ("substring", [Types.STRING, Types.INT, Types.INT], Types.STRING ),
    ("concat",    [Types.STRING, Types.STRING],         Types.STRING ),
    ("not",       [Types.INT],                          Types.INT    ),
    ("exit",      [Types.INT],                          Types.UNIT   )
                                                 ]
end
