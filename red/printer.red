Red [
    Title: "Red implementation of Printer for the Mal Lisp"
]

separate: function [
	"Inserts a separator between each element in a list"
	block [block!]
	separator [string!]
] [
	while [not tail? next block] [
		block: insert next block copy separator
	]
	block: head block
]

pr_str: function [
	structure "the Mal data structure to print"
	/print_readably "print out the string in a form that can be machine-read"
    /exactly "return integers as integers"
] [
	;print_backup rejoin ["#####^/structure: " structure ", type: " type? structure  "^/#####^/"]
	case [
		logic? structure [to-string structure]
		integer? structure [either exactly [structure] [to-string structure]]
		string? structure [
			either print_readably [
				part_to_replace: copy/part next structure ((length? structure) - 2)
				backslashes_replaced: replace/all part_to_replace "\" "\\" ; we must replace the backslashes first as it would add in extra ones otherwise
				double_quotes_replaced: replace/all backslashes_replaced "^"" "\^""
				newlines_replaced: replace/all double_quotes_replaced newline "\n"
				rejoin ["^"" newlines_replaced "^""]
			] [
				structure
			]
		]
		structure/is_type "MalSequence" [
			middle: rejoin separate (h/f_map h/lambda [either exactly [pr_str ?] [pr_str/exactly ?] ] structure/data) " "
			case [
				structure/is_type "MalList" [rejoin ["(" middle ")"]]
				structure/is_type "MalVector" [rejoin ["[" middle "]"]]
			]
		]
		structure/is_type "MalNil" ["nil"]
		structure/is_type "MalSymbol" [structure/data]
	]
]