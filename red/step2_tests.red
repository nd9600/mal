Red [
	"Mal's step 2 tests, implemented in Red"
]

do %testing.red

;; Testing evaluation of arithmetic operations
assert [ (rep "(+ 1 2)" repl_env ) == "3" ]
assert [ (rep "(+ 5 (* 2 3))" repl_env ) == "11" ]
assert [ (rep "(- (+ 5 (* 2 3)) 3)" repl_env ) == "8" ]
assert [ (rep "(/ (- (+ 5 (* 2 3)) 3) 4)" repl_env ) == "2" ]
assert [ (rep "(/ (- (+ 515 (* 87 311)) 302) 27)" repl_env ) == "1010" ]
assert [ (rep "(* -3 6)" repl_env ) == "-18" ]
assert [ (rep "(/ (- (+ 515 (* -87 311)) 296) 27)" repl_env ) == "-994" ]
;assert [ (rep "(abc 1 2 3)" repl_env ) == "abc not found" ]

;; Testing empty list
assert [ (rep "()" repl_env ) == "()" ]

print_backup "all required tests passed"

;>>> deferrable=True
;>>> optional=True
;;
;; -------- Deferrable/Optional Functionality --------

;; Testing evaluation within collection literals
;[1 2 (+ 1 2)]
;=>[1 2 3]

;{"a" (+ 7 8)}
;=>{"a" 15}

;{:a (+ 7 8)}
;=>{:a 15}

;print_backup "all tests passed"