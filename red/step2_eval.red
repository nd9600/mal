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

repl_env: make map! []
repl_env/+: lambda [?x + ?y]
repl_env/-: lambda [?x - ?y]
repl_env/*: lambda [?x * ?y]
repl_env/('/): lambda [?x / ?y]

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

access: function [block i k] [select (do block/(i)) k]
;put Mal objects in blocks for now


eval_ast: function [
	ast "the Mal AST"
	env [map!] "the REPL environment"
] [
	print_backup rejoin ["#####^/ast2: " mold ast "^/#####^/"]
	print_backup (type? ast)
	case [
		logic? ast [ast]
		integer? ast [ast]
		string? ast [ast]
		ast/is_type "MalList" [f_map lambda [EVAL ? env] ast/data]
		ast/is_type "MalSymbol" [
			either (not none? select env ast/data) [
				select env ast/data
			] [
				do make error! rejoin [ast/data ": symbol not found"]
			]
		]
		true [ast]
	]
]

READ: function [
	str [string!] "the input string"
] [
	read_str str
]

EVAL: function [
	ast "the Mal AST"
	env [map!] "the REPL environment"
] [
	print_backup rejoin ["#####^/ast1: " ast "^/#####^/"]
	case [
		logic? ast [eval_ast ast env]
		integer? ast [eval_ast ast env]
		string? ast [eval_ast ast env]
		not ast/is_type "MalList" [eval_ast ast env]
		empty? ast/data [ast]
		true [ ;the AST will be a non-empty list here
			print_backup rejoin ["#####^/unevaluated_list: " ast "^/#####^/"]
			evaluated_list: eval_ast ast env
			print_backup rejoin ["#####^/evaluated_list: " evaluated_list "^/#####^/"]
			f: to-lit-word first evaluated_list/data
			args: next evaluated_list/data
			return apply f a
		]
	]	
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
	PRINT EVAL (READ str) env
]

;do %step2_tests.red

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
	    	if error? error: try [
	    		result: rep characters repl_env
				print_backup result
				none ; 'print doesn't return anything, so this will (ironically) crash without this line
	    	] [
	    		switch/default error/arg1 [
	    			"blank line" []
	    		] [
    				print_backup rejoin ["error: " error]
    			]
    		]
		]
	]
]