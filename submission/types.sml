structure Types =
struct

  type unique = unit ref

  datatype ty = 
            RECORD of (Symbol.symbol * ty) list * unique
          | NIL
          | INT
          | STRING
          | ARRAY of ty * unique
          | NAME of Symbol.symbol * ty option ref
          | UNIT
          | BOTTOM (* Use for errors *)

  fun str (t: ty) = case t  of
                         RECORD(symtylist, unique) => (
                             let 
                               fun getFieldType (RECORD(_, _)) = "RECORD"
                                 | getFieldType (t) = str t
                             in
                               "{" ^ (foldr (op ^) "" (map (fn(fieldsym, fieldty) => (Symbol.name fieldsym) ^ "=" ^ (getFieldType fieldty) ^ ", ") symtylist)) ^ "}"
                             end)
                       | NIL => "NIL"
                       | INT => "INT"
                       | STRING => "STRING"
                       | ARRAY(ty, unique) =>  (str ty) ^ " array"
                       | NAME(sym, tyoptref) => ( "NAME " ^ (Symbol.name sym))
                       | UNIT => "UNIT"
                       | BOTTOM => "BOTTOM"
 
  fun leq (BOTTOM, _)                    = true
    | leq (_,   UNIT)                    = true
    | leq (INT, INT)                     = true
    | leq (STRING, STRING)               = true
    | leq (NIL, NIL)                     = true
    | leq (NIL, RECORD(_, u2))           = true
    | leq (RECORD(_, u1), RECORD(_, u2)) = u1=u2
    | leq (ARRAY (_, u1), ARRAY (_, u2)) = u1=u2
    | leq (_, _)                         = false

  fun eq(t1, t2) = leq(t1, t2) andalso leq(t2, t1)

end

