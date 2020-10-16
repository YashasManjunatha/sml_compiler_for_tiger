signature ENV =
sig
  type access
  type ty
  datatype enventry = VarEntry of {ty: ty, access: access}
                    | FunEntry of {
                        level: Translate.level, 
                        label: Temp.label,
                        formals: ty list, 
                        result: ty}
  val base_tenv : ty Symbol.table
  val base_venv : enventry Symbol.table
end
