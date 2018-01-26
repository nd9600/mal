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

MalBoolean: make MalType [
	type: append self/type "MalBoolean"
	data: false
]

MalInteger: make MalType [
	type: append self/type "MalInteger"
	data: 0
]

MalList: make MalType [
	type: append self/type "MalList"
	data: copy []
	_append: function [element] [append/only data element data]
	_get: function [index [integer!]] [data/(index)]
]