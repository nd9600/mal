Red [
    Title: "Red implementation of step 1 of the Mal Lisp"
]

system/options/quiet: true

read_backup: :read
print_backup: :print

do %moduleLoader.red
h: import/only %helpers.red [apply lambda f_map]

do %types.red
do %reader.red
do %printer.red

brackets_match: function [
	str [string!]
	opening_char [char!]
	ending_char [char!]
] [
	brackets: copy rejoin parse str [collect [any [keep opening_char | keep ending_char | skip] ]]
	counter: 0
	foreach bracket brackets [
		if counter < 0 [return false]
		either bracket == opening_char [counter: counter + 1] [counter: counter - 1]
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
    ast: READ str
    ?? ast
	PRINT EVAL ast
]

do %step1_tests.red

forever [
	characters: to-string ask "user> "

	case [
		characters == "^[" [ break ]
		((num: brackets_match characters #"(" #")") <> 0) [
			either (num < 0) [print_backup "expected '('"] [print_backup "expected ')', got EOF"]
		]
		((num: brackets_match characters #"[" #"]") <> 0) [
			either (num < 0) [print_backup "expected '['"] [print_backup "expected ']', got EOF"]
		]
	    true [
	    	try/all [
				result: rep characters
				rejoin ["result: " mold result]
				print_backup result
			]
		]
	]
]