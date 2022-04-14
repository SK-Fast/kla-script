Program
    = a:Expression _ Terminator _ b:Program { return [a].concat(b).filter(x=>x!=null) }
    / a:Expression? { return [a].filter(x=>x!=null) }
Expression
    = 'print(' _ a:Expression _ ')' { return [ 'print', a ]}
    / 'wait(' _ a:Expression _ ')' { return [ 'wait', a ]}
    / 'import(' _ a:Expression _ ')' { return [ 'import', a ]}
    / 'set_plr_position_x(' _ a:Expression _ ')' { return [ 'set_playerPosX', a ]}
    / 'set_plr_position_y(' _ a:Expression _ ')' { return [ 'set_playerPosY', a ]}
    / 'eval_js(' _ a:Expression _ ')' { return [ 'run_js', a ]}
    / a:Term _ b:Operator _ c:Expression { return [b, a, c] }
    / a:Term? { return a }
Term =
    Number
    / Parenthetical
    / Identifier
    / Comment
Parenthetical "Parenthetical" = '(' e:Expression ')' { return e }
Operator
    = '+' { return "add" }
    / '*' { return "multiply" }
    / '-' { return "subtract" }
    / '/' { return "divide" }
    / '%' { return "mod" }
    / '&&' { return "and"}
    / '||' { return "or"}
    / '|' { return "map" }
    / '..' { return "range"}
    / '==' { return "equal"}
    / '=' { return "set"}
Comment
  = MultiLineComment
  / SingleLineComment

MultiLineComment
  = "/*" (!"*/" .)* "*/"
MultiLineCommentNoLineTerminator
  = "/*" (!("*/" / LineTerminator) .)* "*/"
SingleLineComment
  = "//" (!LineTerminator .)*

// -- LEXICAL TOKENS --
Number "Number" = n:[0-9]+ { return ["int", n.join('')] }
Identifier "Identifier"
  = n:("\"" CharDoubleQuoted* "\"" / "'" CharSingleQuoted* "'")+ { return ["str", n[0][1].join('')] }
  / n:[a-zA-Z0-9?]+ { return ["var", n.join('')] }

Terminator "Terminator" = LineTerminator / ';'
LineTerminator = [\n\r\u2028\u2029]
_ "whitespace" = " "* {}
__"whitespace" = [ \t\n\r]+ {}

CharDoubleQuoted
  =  "\\\"" / [^"]

CharSingleQuoted
  =  "\\'" / [^']