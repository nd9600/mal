Red [
    Title: "An assert function for unit testing"
]

assert: function [
    "Raises an error if every value in 'conditions doesn't evaluate to true. Inclose variables in brackets to compose them"
    conditions [block!]
] [
    any [
        all conditions
        do [
            e: rejoin [
                "assertion failed for: " mold/only conditions "," 
                newline 
                "conditions: [" compose/only conditions "]"
            ] 
            print_backup e 
            do make error! rejoin ["assertion failed for: " mold conditions]
        ]
    ]
]
