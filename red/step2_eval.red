Red [
    Title: "Red implementation of step 2 of the Mal Lisp"
]

system/options/quiet: true

read_backup: :read
print_backup: :print

do %types.red
do %functional.red
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

repl_env: make map! []
repl_env/+: lambda [?x + ?y]
repl_env/-: lambda [?x - ?y]
repl_env/*: lambda [?x * ?y]
repl_env/('/): lambda [?x / ?y]

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
	env [map!] "the REPL environment"
] [
	PRINT EVAL READ str
]

do %step2_tests.red

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
				result: rep characters repl_env
				rejoin ["result: " mold result]
				print_backup result
			]
		]
	]
]