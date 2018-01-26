Red [
    Title: "Red implementation of types for the Mal Lisp"
]

MalType: make object! [
	type: copy ["MalType"]
	is_type: function [type_string [string!]] [not none? find self/type type_string]
]

MalSymbol: make MalType [
	type: append self/type "MalSymbol"
	data: copy ""
]

MalNil: make MalType [
	type: append self/type "MalNil"
]

MalSequence: make MalType [
	type: append self/type "MalSequence"
	data: copy []
	_append: function [element] [append/only data element data]
	_get: function [index [integer!]] [data/(index)]
]

MalList: make MalSequence [
	type: append self/type "MalList"
]

MalVector: make MalSequence [
	type: append self/type "MalVector"
]