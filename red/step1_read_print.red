Red [
    Title: "Red implementation of step 1 of the Mal Lisp"
]

system/options/quiet: true

read_backup: :read
print_backup: :print

do %types.red
do %functional.red
do %reader.red
do %printer.red

parens_match: function [
	str [string!]
] [
	parens: copy rejoin parse str [collect [any [keep "(" | keep ")" | skip] ]]
	counter: 0
	foreach paren parens [
		if counter < 0 [return false]
		either paren == #"(" [counter: counter + 1] [counter: counter - 1]
	]
	counter
]

READ: function [
	str [string!] "the input string"
] [
	read_str str
]

EVAL: function [
	str "the input string"
] [
	str
]

PRINT: function [
	str "the input string"
] [
	pr_str/print_readably str
]

rep: function [
	str [string!] "the input string"
] [
	PRINT EVAL READ str
]

do %step1_tests.red

forever [
	characters: to-string ask "user> "

	case [
		characters == "^[" [ break ]
		((num: parens_match characters) <> 0) [
			either (num < 0) [print_backup "expected '(', got EOF"] [print_backup "expected ')', got EOF"]
		]
	    true [
			result: rep characters
			rejoin ["result: " mold result]
			print_backup result
		]
	]
]