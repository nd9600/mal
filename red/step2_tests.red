Red [
	"Mal's step 2 tests, implemented in Red"
]

do %testing.red

;; Testing read of numbers
assert [ (rep "1" repl_env ) == "1" ]
assert [ (rep "7" repl_env ) == "7" ]
assert [ (rep "  7 " repl_env ) == "7" ]  
assert [ (rep "-123" repl_env ) == "-123" ]


;; Testing read of symbols
assert [ (rep "+" repl_env ) == "+" ]
assert [ (rep "abc" repl_env ) == "abc" ]
assert [ (rep "   abc   " repl_env ) == "abc" ]
assert [ (rep "abc5" repl_env ) == "abc5" ]
assert [ (rep "abc-def" repl_env ) == "abc-def" ]


;; Testing read of lists
assert [ (rep "(+ 1 2)" repl_env ) == "(+ 1 2)" ]
assert [ (rep "()" repl_env ) == "()" ]
assert [ (rep "(nil)" repl_env ) == "(nil)" ]
assert [ (rep "((3 4))" repl_env ) == "((3 4))" ]
assert [ (rep "(+ 1 (+ 2 3))" repl_env ) == "(+ 1 (+ 2 3))" ]

assert [ (rep "  ( +   1   (+   2 3   )   )  " repl_env ) == "(+ 1 (+ 2 3))" ]
assert [ (rep "(* 1 2)" repl_env ) == "(* 1 2)" ]
assert [ (rep "(** 1 2)" repl_env ) == "(** 1 2)" ]
assert [ (rep "(* -3 6)" repl_env ) == "(* -3 6)" ]

;; Test commas as whitespace
assert [ (rep "(1 2, 3,,,,),," repl_env ) == "(1 2 3)" ]

print_backup "all required tests passed"

;; Testing read of nil/true/false
assert [ (rep "nil" repl_env ) == "nil" ]
assert [ (rep "true" repl_env ) == "true" ]
assert [ (rep "false" repl_env ) == "false" ]

;; Testing read of strings
assert [ (rep "^"abc^"" repl_env ) == "^"abc^"" ]
assert [ (rep "   ^"abc^"   " repl_env ) == "^"abc^"" ]
assert [ (rep "^"abc (with parens)^"" repl_env ) == "^"abc (with parens)^"" ]
assert [ (rep "^"abc\^"def^"" repl_env ) == "^"abc\^"def^"" ]
assert [ (rep "^"abc\ndef^"" repl_env ) == "^"abc\ndef^"" ]
assert [ (rep "^"^"" repl_env ) == "^"^"" ]

print_backup "all tests passed"