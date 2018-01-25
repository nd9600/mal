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
	; thru any whitespace or comma
	; collect one ~@ together
	; collect one of []{}()'`~^@  - special characters
	; collect from " to ", excludes \" any times
	; collect any sequence of characters except newlines that start with ;
	; collect any sequence of characters that aren't whitespace or []{}('"`,;) - non-special characters, as \s means whitespace

	first_group: [newline | cr | lf | "^(0C)" | tab | space | comma] ; 0C is form feed, see https://www.pcre.org/original/doc/html/pcrepattern.html

	tilde_at: "~@"
	special_characters: ["[" | "]" | "^{" | "^}" | "(" | ")" | "'" | "`" | "~" | "^^" | "@"]
	any_characters_except_newlines: charset reduce ['not newline cr lf "^0C"]
	non_special_characters: charset reduce ['not newline cr lf "^0C" tab space "[]^{^}('^"`,;"]
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