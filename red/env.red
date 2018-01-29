Red [
    Title: "Red implementation of environments for the Mal Lisp"
    Docs: https://github.com/kanaka/mal/blob/master/process/guide.md#step-3-environments
]

make_env: function [
	/set_outer "set an outer environment"
	outer_env [object!] "the outer environment to set"
] [
	make object! [
		outer: either set_outer [:outer_env] [none]
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
				(not none? outer) [self/outer/find key]
				true [none]
			]
		]
		get: function [
			key [string!]
		] [
			either (not none? e: self/find key) [
				select e/data (to-word key)
			] [
				do make error! rejoin [key " not found"]
			]
		]
	]
]