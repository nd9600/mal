Red [
    Title: "Red implementation of step 2 of the Mal Lisp"
    Docs: https://github.com/kanaka/mal/blob/master/process/guide.md#step-2-eval
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

apply_repl_env: function [
    "Calls a repl_env function on some arguments"
    env [map!] "the REPL environment"
    f [string!] "the function to apply"
    args [block!]
] [
    apply select env (to-word f) args
]

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

eval_ast: function [
	ast "the Mal AST"
	env [map!] "the REPL environment"
] [
	print_backup rejoin ["#####^/ast2: " mold ast "^/#####^/"]
	case [
		(logic? ast) or (integer? ast) or (string? ast) [return ast]
		ast/is_type "MalList" [
			print_backup rejoin ["#####^/ob: " mold ast/data]
			print_backup rejoin ["env: " mold env]
			return f_map lambda [EVAL ? env] ast/data
		]
		ast/is_type "MalSymbol" [
			either (not none? select env to-word ast/data) [
				print_backup rejoin ["value_of_symbol: " mold select env to-word ast/data]
				return mold select env to-word ast/data
			] [
				do make error! rejoin [ast/data ": symbol not found"]
			]
		]
		true [return ast]
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
	print_backup rejoin ["#####^/ast1: " mold ast "^/#####^/"]
	case [
		(logic? ast) or (integer? ast) or (string? ast) [eval_ast ast env]
		not ast/is_type "MalList" [eval_ast ast env]
		empty? ast/data [ast]
		true [ ;the AST will be a non-empty list here
			print_backup rejoin ["#####^/unevaluated_list: " mold ast "^/#####^/"]
			evaluated_list: eval_ast ast env
			print_backup rejoin ["#####^/evaluated_list: " mold evaluated_list "^/#####^/"]
			f: do first evaluated_list ;it's fine if this fails when you try to eval a list with no function, like (1)
			args: next evaluated_list
			return apply :f args
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
				if system/platform == 'Windows [do-events/no-wait] ; the GUI won't print anything out without this, see issue #2753
				none ; 'print doesn't return anything, so the program will (ironically) crash without this line
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