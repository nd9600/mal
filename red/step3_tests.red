Red [
	"Mal's step 3 tests, implemented in Red"
]

do %testing.red

;; Testing REPL_ENV
assert [ (rep "(+ 1 2)" repl_env ) == "3" ]
assert [ (rep "(/ (- (+ 5 (* 2 3)) 3) 4)" repl_env ) == "2" ]

;; Testing def!
assert [ (rep "(def! x 3)" repl_env ) == "3" ]
assert [ (rep "x" repl_env ) == "3" ]
assert [ (rep "(def! x 4)" repl_env ) == "4" ]
assert [ (rep "x" repl_env ) == "4" ]

assert [ (rep "(def! y (+ 1 7))" repl_env ) == "8" ]
assert [ (rep "y" repl_env ) == "8" ]

assert [ (rep "(def! mynum 111" repl_env ) == "111" ]
assert [ (rep "(def! MYNUM 222" repl_env ) == "222" ]
assert [ (rep "mynum" repl_env ) == "111" ]
assert [ (rep "MYNUM" repl_env ) == "222" ]

;; Check env lookup non-fatal error
assert [ (rep "(abc 1 2 3)" repl_env ) == "'abc' not found" ]

; .*\'abc\' not found.*
;; Check that error aborts def!
rep "(def! w 123)" repl_env
rep "(def! w (abc))" repl_env
assert [ (rep "w" repl_env ) == "123" ]

;; Testing let*
assert [ (rep "(let* (z 9) z)" repl_env ) == "9" ]
assert [ (rep "(let* (x 9) x)" repl_env ) == "9" ]
assert [ (rep "x" repl_env ) == "4" ]
assert [ (rep "(let* (z (+ 2 3)) (+ 1 z))" repl_env ) == "6" ]
assert [ (rep "(let* (p (+ 2 3) q (+ 2 p)) (+ p q))" repl_env ) == "12" ]

rep "(def! y (let* (z 7) z))" repl_env
assert [ (rep "y" repl_env ) == "7" ]

;; Testing outer environment
assert [ (rep "def! a 4" repl_env ) == "4" ]
assert [ (rep "(let* (q 9) q)" repl_env ) == "9" ]
assert [ (rep "(let* (q 9) a)" repl_env ) == "4" ]
assert [ (rep "(let* (z 2) (let* (q 9) a))" repl_env ) == "4" ]
assert [ (rep "(let* (x 4) (def! a 5))" repl_env ) == "5" ]
assert [ (rep "a" repl_env ) == "4" ]

print_backup "all required tests passed"

;; -------- Deferrable/Optional Functionality --------

;; Testing let* with vector bindings
assert [ (rep "(let* [z 9] z)" repl_env ) == "9" ]
assert [ (rep "(let* [p (+ 2 3) q (+ 2 p)] (+ p q))" repl_env ) == "12" ]

;; Testing vector evaluation
assert [ (rep "(let* (a 5 b 6) [3 4 a [b 7] 8])" repl_env ) == "[3 4 5 [6 7] 8]" ]

print_backup "all tests passed"