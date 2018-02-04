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

repl_env: make_env
repl_env/set "+" lambda [?x + ?y]
repl_env/set "-" lambda [?x - ?y]
repl_env/set "*" lambda [?x * ?y]
repl_env/set "/" lambda [?x / ?y]

READ: function [
	str [string!] "the input string"
] [
	read_str str
]

eval_ast: function [
	ast "the Mal AST"
	this_env [object!] "the REPL environment"
] [
	case [
		(logic? ast) or (integer? ast) or (string? ast) [ast]
		ast/is_type "MalSequence" [
			data_evaluated: f_map lambda [EVAL ? this_env] ast/data
			case [
				ast/is_type "MalList" [make MalList [data: data_evaluated]]
				ast/is_type "MalVector" [make MalVector [data: data_evaluated]]
			]
		]
		ast/is_type "MalSymbol" [
			either (not none? value: this_env/get ast/data) [
				either function? :value [mold :value][value] ; if we don't mold it Red will try to execute it
			] [
				do make error! rejoin ["'" ast/data "' not found"]
			]
		]
		true [ast]
	]
]

EVAL: function [
	ast "the Mal AST"
	this_env [object!] "the REPL environment"
] [
	print_backup rejoin ["#####^/ast1: " mold ast "^/#####^/"]
	case [
		(logic? ast) or (integer? ast) or (string? ast) [eval_ast ast this_env]
		not ast/is_type "MalList" [eval_ast ast this_env]
		empty? ast/data [ast]
		true [ ;the AST will be a non-empty list here
			first_element: (ast/_get 1)
			case [
				first_element/data == "def!" [
					mal_symbol: ast/_get 2
					key: mal_symbol/data
					value: EVAL (ast/_get 3) this_env
					this_env/set key value
				]
				first_element/data == "let*" [
					new_env: make_env/set_outer this_env
					new_bindings_list: ast/_get 2
					new_bindings: new_bindings_list/data

					if not ((length? new_bindings) % 2) == 0 [do make error! "wrong number of bindings"]

					until [
						binding_key_symbol: first new_bindings
						binding_key: binding_key_symbol/data
						evaluated_binding_value: EVAL (first next new_bindings) new_env

						new_env/set binding_key evaluated_binding_value
						tail? new_bindings: next next new_bindings
					]
					print_backup rejoin ["new_env/data: " mold new_env/data]
					EVAL (ast/_get 3) new_env
				]
				true [
					evaluated_list: eval_ast ast this_env
					f: do first evaluated_list/data ;it's fine if this fails when you try to eval a list with no function, like (1)
					args: next evaluated_list/data
					apply :f args
				]
			]
		]
	]	
]

PRINT: function [
	structure "the structure to print"
] [
	pr_str/print_readably structure
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