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
	obj [object!] "the Mal data structure to print"
	/print_readably "print out the string in a form that can be machine-read"
] [
	print_backup rejoin ["#####^/obj: " obj "^/#####^/"]
	case [
		obj/is_type "MalList" [
			middle: rejoin separate (f_map lambda [pr_str ?] obj/data) " "
			return rejoin ["(" middle ")"]
		]
		obj/is_type "MalNil" [return "nil"]
		obj/is_type "MalBoolean" [return to-string obj/data]
		obj/is_type "MalInteger" [return to-string obj/data]
		obj/is_type "MalString" [
			either print_readably [
				backslashes_replaced: replace/all obj/data "\" "\\" ; we must replace the backslashes first as it would add in extra ones otherwise
				double_quotes_replaced: replace/all backslashes_replaced newline "\n"
				newlines_replaced: replace/all double_quotes_replaced "^"" "\^""
				return backslashes_replaced
			] [
				return obj/data
			]
		]
		obj/is_type "MalSymbol" [return obj/data]
	]
]