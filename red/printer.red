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
] [
	;print_backup rejoin ["#####^/obj: " obj "^/#####^/"]
	case [
		obj/is_type "MalList" [
			middle: rejoin separate (f_map lambda [pr_str ?] obj/data) " "
			return rejoin ["(" middle ")"]
		]
		obj/is_type "MalNil" [return "nil"]
		obj/is_type "MalBoolean" [return to-string obj/data]
		obj/is_type "MalInteger" [return to-string obj/data]
		obj/is_type "MalSymbol" [return obj/data]
	]
]