Red [
    Title: "Red implementation of step 1 of the Mal Lisp"
]

system/options/quiet: true

read_backup: :read
print_backup: :print

READ: function [
	str [string!] "the input string"
] [
	str
]

EVAL: function [
	str [string!] "the input string"
] [
	str
]

PRINT: function [
	str [string!] "the input string"
] [
	str
]

rep: function [
	str [string!] "the input string"
] [
	PRINT EVAL READ str
]


forever [
	char: ask "user> "
	
	either any [char == "^["] [
		break
	] [
		print_backup rep char
	]
]