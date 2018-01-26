Red [
    Title: "Red implementation of Printer for the Mal Lisp"
]

separate: function [
	block [block!]
	separator [string!]
] [
	while [not tail? next block] [
		block: insert next block copy separator
	]
	block: head block
]

pr_str: function [
	obj "the Mal data structure to print"
	/print_readably "print out the string in a form that can be machine-read"
] [
	;print_backup rejoin ["#####^/obj: " obj "^/#####^/"]
	case [
		logic? obj [return to-string obj]
		integer? obj [return to-string obj]
		string? obj [
			either print_readably [
				part_to_replace: copy/part next obj ((length? obj) - 2)
				backslashes_replaced: replace/all part_to_replace "\" "\\" ; we must replace the backslashes first as it would add in extra ones otherwise
				double_quotes_replaced: replace/all backslashes_replaced "^"" "\^""
				newlines_replaced: replace/all double_quotes_replaced newline "\n"
				return rejoin ["^"" newlines_replaced "^""]
			] [
				return obj
			]
		]
		obj/is_type "MalSequence" [
			middle: rejoin separate (f_map lambda [pr_str ?] obj/data) " "
			case [
				obj/is_type "MalList" [return rejoin ["(" middle ")"]]
				obj/is_type "MalVector" [return rejoin ["[" middle "]"]]
			]
		]
		obj/is_type "MalNil" [return "nil"]
		obj/is_type "MalSymbol" [return obj/data]
	]
]