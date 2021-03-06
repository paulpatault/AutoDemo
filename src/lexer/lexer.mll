{
  open Lexing
  open Parser
  open Printf

  exception Eof
}

let alpha = ['a'-'z' 'A'-'Z']
let digit = ['0'-'9']
let ident = (alpha | digit) (alpha | digit | '_')*
let land  = "&&" | "/\\"
let lor   = "||" | "\\/"

rule scan_token = parse
  | [' ' '\t' '\r']+ { scan_token lexbuf }
  | '\n' { EOF }
  | ident as id  { IDENT(id) }
  | '!'    { NOT }
  | '_'    { EMPTY }
  | land   { AND }
  | lor    { OR }
  | "->"   { FLECHE }
  | '('    { LPAR }
  | ')'    { RPAR }
  | ';'    { SEMI }
  | _ as c { failwith (Printf.sprintf "-> invalid character: %c" c) }
  | eof    { raise Eof }

{
}
