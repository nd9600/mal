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
	case [
		(logic? ast) or (integer? ast) or (string? ast) [return ast]
		ast/is_type "MalSequence" [
			data_evaluated: f_map lambda [EVAL ? env] ast/data
			case [
				ast/is_type "MalList" [return make MalList [data: data_evaluated]]
				ast/is_type "MalVector" [return make MalVector [data: data_evaluated]]
			]
		]
		ast/is_type "MalSymbol" [
			either (not none? select env (to-word ast/data)) [
				return mold select env (to-word ast/data) ; if we don't mold it Red will try to execute it
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
	env [map!] "the REPL environment"
] [
	;print_backup rejoin ["#####^/ast1: " mold ast "^/#####^/"]
	case [
		(logic? ast) or (integer? ast) or (string? ast) [eval_ast ast env]
		not ast/is_type "MalList" [eval_ast ast env]
		empty? ast/data [ast]
		true [ ;the AST will be a non-empty list here
			evaluated_list: eval_ast ast env
			f: do first evaluated_list/data ;it's fine if this fails when you try to eval a list with no function, like (1)
			args: next evaluated_list/data
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
	if error? error: try [
		return PRINT EVAL (READ str) env
	]  [
		switch/default error/arg1 [
			"blank line" [return ""] ; will print nothing if a blank line or a line with only a comment was entered
		] [
			return error/arg1
		]
	]
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
	    	result: rep characters repl_env
    		if result <> "" [print_backup result]
			if system/platform == 'Windows [do-events/no-wait] ; the GUI won't print anything out without this, see issue #2753
    	]
	]
]