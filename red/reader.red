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
	"lexes an input string"
	str [string!] "the input string"
] [
	; [\s,]* ( ~@ | [\[\]{}()'`~^@] | "(?:\\. | [^\\"])*" | ;.* | [^\s\[\]{}('"`,;)]* )
	;any times
	; thru any whitespace or comma - "\s" means whitespace
	;then
	;collect 
	;  one ~@ together
	; or
	;  one of []{}()'`~^@  - special characters
	; or
	;  from " to ", skip through \"
	; or
	;  a comma and any sequence of characters except newlines
	; or
	;  any sequence of characters that aren't whitespace or []{}('"`,;) - non-special characters

	; rebol/red escapes characters with "^", not "\"

	whitespace_or_comma: [newline | cr | lf | "^(0C)" | tab | space | comma] ; 0C is form feed, see https://www.pcre.org/original/doc/html/pcrepattern.html
	special_character: ["[" | "]" | "^{" | "^}" | "(" | ")" | "'" | "`" | "~" | "^^" | "@"]

	thru_escaped_double_quote: [any [thru "\^""]]
	between_double_quotes: ["^"" thru_escaped_double_quote thru "^""]

	characters_except_newlines: charset reduce ['not newline cr lf "^0C"]
	non_special_characters: charset reduce ['not newline cr lf "^0C" tab space "[]^{^}('^"`,;)"]

	lexer_rules: [
		collect any [ ; the regex seems to repeat until you get to the end of the string, so we have to put in an 'any here
			thru [any whitespace_or_comma]
			[
				keep "~@"
			|
				keep special_character
			|
			    keep between_double_quotes
			|
				[";" any characters_except_newlines]
			|
				keep some non_special_characters
			]
		]
	]

	;tokens are put into nested blocks sometimes, this puts them all into a flat block, as strings, rather than occasionally chars
	tokens: parse str lexer_rules
	;flattened_tokens: copy []
	;foreach token tokens [append flattened_tokens token]

	tokens_as_strings: f_map lambda [to-string ?] tokens
]

read_form: function [
	current_reader [object!] "the current reader"
] [
	if empty? current_reader/tokens [throw "blank line"] ;if just a comment is entered

	first_token: current_reader/peek
	switch/default first_token [
		"(" [return read_list current_reader]
		"[" [return read_vector current_reader]
	] [
		return read_atom current_reader
	]
]

read_sequence: function [
	current_reader [object!] "the current reader"
	sequence [object!] "the initially empty sequence"
	final_token [string!] "the token that marks the end of the sequence"
] [
	current_reader/next
	while [current_reader/peek <> final_token] [
		sequence/_append read_form current_reader 
		current_reader/next 
	]
	sequence
]

read_list: function [
	current_reader [object!] "the current reader"
] [
	list: make MalList []
	read_sequence current_reader list ")"
]

read_vector: function [
	current_reader [object!] "the current reader"
] [
	vector: make MalVector []
	read_sequence current_reader vector "]"
]

read_atom: function [
	current_reader [object!] "the current reader"
] [
	digit: charset "0123456789"
	thru_escaped_double_quote: [any [thru "\^""]]
	string: ["^"" thru_escaped_double_quote thru "^""]

	token: current_reader/peek
	case [
		(parse token [some digit]) [return to-integer token]
		(parse token string) [return make_string token]
		token == "nil" [return make MalNil []]
		(parse token ["true" | "false"]) [return either (token == "true") [true][false] ]
		true [return make MalSymbol [data: token]]
	]
]

make_string: function [
	token [string!]
] [
	newlines_replaced: replace/all token "\n" newline
	double_quotes_replaced: replace/all newlines_replaced "\^"" "^""
	backslashes_replaced: replace/all double_quotes_replaced "\\" "\"
]