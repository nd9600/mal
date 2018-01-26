Red [
    Title: "Red implementation of step 1 of the Mal Lisp"
]

system/options/quiet: true

read_backup: :read
print_backup: :print

do %types.red
do %functional.red
do %reader.red
do %printer.red

READ: function [
	str [string!] "the input string"
] [
	read_str str
]

EVAL: function [
	str "the input string"
] [
	str
]

PRINT: function [
	str "the input string"
] [
	pr_str str
]

rep: function [
	str [string!] "the input string"
] [
	PRINT EVAL READ str
]

;do %step1_tests.red

forever [
	characters: to-string ask "user> "
	
	either any [characters == "^["] [
		break
	] [
		result: rep characters
		rejoin ["result: " mold result]
		print_backup result
	]
]