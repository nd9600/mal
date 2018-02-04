Red [
    Title: "Red implementation of environments for the Mal Lisp"
    Docs: https://github.com/kanaka/mal/blob/master/process/guide.md#step-3-environments
]

make_env: function [
	/set_outer "set an outer environment"
	outer_env [object!] "the outer environment to set"
] [
	context [
		make_key: function [key [string!]] [rejoin [key "-" enbase/base key 2]]
		return make object! [
			outer: either set_outer [:outer_env] [none]
			data: make map! []
			set: function [
				key [string!]
				value "the Mal value to add"
			] [
				self/data/(make_key key): :value
			]
			find: function [
				key [string!]
			] [
				case [
					(not none? select self/data (make_key key)) [self]
					(not none? outer) [self/outer/find key]
					true [none]
				]
			]
			get: function [
				key [string!]
			] [
				if (not none? e: self/find key) [return select e/data (make_key key)]
				do make error! rejoin [key " not found"]
			]
		]
	]
]