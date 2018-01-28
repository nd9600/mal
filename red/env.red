Red [
    Title: "Red implementation of environments for the Mal Lisp"
    Docs: https://github.com/kanaka/mal/blob/master/process/guide.md#step-3-environments
]

Env: make object! [
	outer: make MalNil []
	data: make map! []
	set: function [
		key [string!]
		value "the Mal value to add"
	] [
		self/data/(to-word key): value
	]
	find: function [
		key [string!]
	] [
		case [
			(not none? select self/data (to-word key)) [self/data]
			((not self/outer/is_type "MalNil") and (not none? self/outer/find key)) [self/data]
			true [none]
		]
	]
	get: function [
		key [string!]
	] [
		either (not none? self/find key) [
			select self/data (to-word ast/data)
		] [
			do make error! rejoin [key " not found"]
		]
	]
]