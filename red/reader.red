Red [
    Title: "Red implementation of Reader for the Mal Lisp"
]

Reader: make object! [
	tokens: copy []
	position: 1
	next: function [] [
		position: position + 1
		tokens/(position - 1)
	]
	peek: function[] [
		tokens/(position)
	]
]

read_str: function [
	str [string!] "the input string"
] [
	new_reader: make Reader [
		tokens: tokenizer str
	]
	read_form new_reader
]

tokenizer: function [
	str [string!] "the input string"
] [
	; [\s,]*(~@|[\[\]{}()'`~^@]|"(?:\\.|[^\\"])*"|;.*|[^\s\[\]{}('"`,;)]*)
]

read_form: function [
	current_reader [object!] "the current reader"
] [
	first_token: current_reader/peek
	switch/default first_token [
		"(" [return read_list current_reader]
	] [
		return read_atom current_reader
	]
]

read_list: function [
	current_reader [object!] "the current reader"
] [
	first_token: current_reader/next
	list: copy []
	until [
		append list read_form current_reader
		first_token: current_reader/next
		first_token == ")"
	]
	list
]

read_atom: function [
	current_reader [object!] "the current reader"
] [

	digit: charset "0123456789"

	token: current_reader/peek
	case [
		(parse token [some digit]) [return to-integer token]
		true [make_symbol token]
	]
]

make_symbol: function [
	token [string!]
] [
	token
]