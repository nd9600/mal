Red [
    Title: "Red implementation of Printer for the Mal Lisp"
]

separate: function [
	block [block!]
	separator [string!]
] [
	until [
		block: insert next block copy separator
		tail? next block
	]
	block: head block
]

pr_str: function [
	obj [object!] "the Mal data structure to print"
] [
	case [
		obj/is_type "MalSymbol" [return obj/data]
		obj/is_type "MalInteger" [return to-string obj/data]
		obj/is_type "MalList" [
			middle: rejoin separate (f_map lambda [pr_str ?] obj/data) " "
			return rejoin ["(" middle ")"]
		]
	]
]