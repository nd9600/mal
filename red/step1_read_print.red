Red [
    Title: "Red implementation of step 1 of the Mal Lisp"
]

system/options/quiet: true

read_backup: :read
print_backup: :print

do %reader.red

READ: function [
	str [string!] "the input string"
] [
	data: read_str str
	probe data
	data
]

EVAL: function [
	str "the input string"
] [
	str
]

PRINT: function [
	str "the input string"
] [
	str
]

rep: function [
	str [string!] "the input string"
] [
	PRINT EVAL READ str
]


forever [
	characters: to-string ask "user> "
	
	either any [characters == "^["] [
		break
	] [
		print_backup rep characters
	]
]