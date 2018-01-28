Red [
    Title: "Red implementation of step 3 of the Mal Lisp"
    Docs: https://github.com/kanaka/mal/blob/master/process/guide.md#step-3-environments
]

system/options/quiet: true

read_backup: :read
print_backup: :print

do %types.red
do %functional.red
do %reader.red
do %printer.red
do %env.red

repl_env: make Env []
repl_env/set "+" lambda [?x + ?y]
repl_env/set "-" lambda [?x - ?y]
repl_env/set "*" lambda [?x * ?y]
repl_env/set "/" lambda [?x / ?y]

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
	this_env [object!] "the REPL environment"
] [
	case [
		(logic? ast) or (integer? ast) or (string? ast) [return ast]
		ast/is_type "MalSequence" [
			data_evaluated: f_map lambda [EVAL ? this_env] ast/data
			case [
				ast/is_type "MalList" [return make MalList [data: data_evaluated]]
				ast/is_type "MalVector" [return make MalVector [data: data_evaluated]]
			]
		]
		ast/is_type "MalSymbol" [
			either (not none? this_env/get ast/data) [
				d2: mold this_env/get ast/data
				print_backup rejoin ["#####^/this_env/data: " this_env/data "^/#####^/"]
				print_backup rejoin ["#####^/d2: " d2 "^/#####^/"]
				return d2 ; if we don't mold it Red will try to execute it
			] [
				do make error! rejoin ["'" ast/data "' not found"]
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
	this_env [object!] "the REPL environment"
] [
	;print_backup rejoin ["#####^/ast1: " mold ast "^/#####^/"]
	case [
		(logic? ast) or (integer? ast) or (string? ast) [eval_ast ast this_env]
		not ast/is_type "MalList" [eval_ast ast this_env]
		empty? ast/data [ast]
		true [ ;the AST will be a non-empty list here
			evaluated_list: eval_ast ast this_env
			f: do first evaluated_list/data ;it's fine if this fails when you try to eval a list with no function, like (1)
			args: next evaluated_list/data
			return apply :f args
		]
	]	
]

PRINT: function [
	structure "the structure to print"
] [
	pr_str/print_readably structure
]

rep: function [
	str [string!] "the input string"
	this_env [object!] "the REPL environment"
] [
	if error? error: try [
		return PRINT EVAL (READ str) this_env
	]  [
		switch/default error/arg1 [
			"blank line" [return ""] ; will print nothing if a blank line or a line with only a comment was entered
		] [
			return error/arg1
		]
	]
]

;do %step3_tests.red

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
	    	result: rep characters repl_env
    		if result <> "" [print_backup result]
			if system/platform == 'Windows [do-events/no-wait] ; the GUI won't print anything out without this, see issue #2753
    	]
	]
]