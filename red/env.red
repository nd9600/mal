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
		self/data/(to-word key): :value
	]
	find: function [
		key [string!]
	] [
		case [
			(not none? select self/data (to-word key)) [self]
			all [(not self/outer/is_type "MalNil") (not none? self/outer/find key)] [self/outer]
			true [none]
		]
	]
	get: function [
		key [string!]
	] [
		either (not none? e: self/find key) [
			return select e/data (to-word key)
			print_backup rejoin ["#####^/da: " daaaaaa "^/#####^/"]
			print_backup rejoin ["#####^/d: " select e/data (to-word key) "^/#####^/"]
			d
		] [
			do make error! rejoin [key " not found"]
		]
	]
]