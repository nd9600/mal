Red [
    Title: "Red implementation of Printer for the Mal Lisp"
]

read_str: function [
	str [string!] "the input string"
] [
	new_reader: make Reader [
		tokens: tokenizer str
	]
	read_form new_reader
]