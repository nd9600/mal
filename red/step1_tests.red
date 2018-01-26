Red [
]

do %testing.red

;; Testing read of numbers
assert [ (rep "1") == "1" ]
;=>1
assert [ (rep "7") == "7" ]
;=>7
 assert [ (rep "  7 ") == "7" ]  
;=>7
assert [ (rep "-123") == "-123" ]
;=>-123


;; Testing read of symbols
assert [ (rep "+") == "+" ]
;=>+
assert [ (rep "abc") == "abc" ]
;=>abc
assert [ (rep "   abc   ") == "abc" ]
;=>abc
assert [ (rep "abc5") == "abc5" ]
;=>abc5
assert [ (rep "abc-def") == "abc-def" ]
;=>abc-def


;; Testing read of lists
assert [ (rep "(+ 1 2)") == "(+ 1 2)" ]
;=>(+ 1 2)
assert [ (rep "()") == "()" ]
;=>()
assert [ (rep "(nil)") == "(nil)" ]
;=>(nil)
assert [ (rep "((3 4))") == "((3 4))" ]
;=>((3 4))
assert [ (rep "(+ 1 (+ 2 3))") == "(+ 1 (+ 2 3))" ]
;=>(+ 1 (+ 2 3))

assert [ (rep "  ( +   1   (+   2 3   )   )  ") == "(+ 1 (+ 2 3))" ]
;=>(+ 1 (+ 2 3))
assert [ (rep "(* 1 2)") == "(* 1 2)" ]
;=>(* 1 2)
assert [ (rep "(** 1 2)") == "(** 1 2)" ]
;=>(** 1 2)
assert [ (rep "(* -3 6)") == "(* -3 6)" ]
;=>(* -3 6)

;; Test commas as whitespace
assert [ (rep "(1 2, 3,,,,),,") == "(1 2 3)" ]
;=>(1 2 3)

print_backup "all required tests passed"

;; Testing read of nil/true/false
assert [ (rep "nil") == "nil" ]
;=>nil
assert [ (rep "true") == "true" ]
;=>true
assert [ (rep "false") == "false" ]
;=>false

;; Testing read of strings
assert [ (rep "^"abc^"") == "^"abc^"" ]
;=>"abc"
assert [ (rep "^"   abc   ^"") == "^"abc^"" ]
;=>"abc"
assert [ (rep "^"abc (with parens)^"") == "^"abc (with parens)^"" ]
;=>"abc (with parens)"
assert [ (rep "^"abc\^"def^"") == "^"abc\^"def^"" ]
;=>"abc\"def"
;;;"abc\ndef"
assert [ (rep "^"abc\ndef^"") == "^"abc\ndef^"" ]
;;;;=>"abc\ndef"
assert [ (rep "^"^"") == "^"^"" ]
;=>""

print_backup "all tests passed"