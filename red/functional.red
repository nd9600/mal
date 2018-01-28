Red [
    Title: "Red implementation of Mal - functional programming functions"
]

;apply: function [f x][f x] ;monadic argument only
;apply: function [f args][do head insert args 'f]
;apply: function [f args][do append copy [f] args]
apply: function [f args][do compose [f (args)] ]

lambda: function [
        "makes lambda functions - https://gist.github.com/draegtun/11b0258377a3b49bfd9dc91c3a1c8c3d"
        block [block!] "the function to make"
    ] [
    spec: make block! 0

    parse block [
        any [
            set word word! (
                if (strict-equal? first to-string word #"?") [
                    append spec word
                    ]
                )
            | skip
        ]
    ]

    spec: unique sort spec
    
    if all [
        (length? spec) > 1
        not none? find spec '?
    ] [ 
        do make error! {cannot match ? with ?name placeholders}
    ]

    function spec block
]

f_map: function [
    "The functional map"
    f  [function!] "the function to use, as a lambda function" 
    block [block!] "the block to map across"
] [
    result: copy/deep block
    print_backup rejoin ["#####^/f_map, f: " source f "^/#####^/"]
    print_backup rejoin ["block: " mold result]
    print_backup rejoin ["length?: " length? result]
    print_backup rejoin ["first?: " mold first result]
    print_backup rejoin ["second?: " mold second result]
    print_backup rejoin ["third?: " mold third result]

    while [not tail? result] [
        fi: first result
        print_backup rejoin ["fi?: " mold fi]
        replacement: f fi
        print_backup rejoin ["replacement?: " mold replacement]
        result: change/part result replacement 1
    ]
    head result
]

f_fold: function [
    "The functional left fold"
    f  [function!] "the function to use, as a lambda function" 
    init [any-type!] "the initial value"
    block [block!] "the block to fold"
] [
    result: init
    while [not tail? block] [
        result: f result first block
        block: next block
    ]
    result
]

f_filter: function [
    "The functional filter"
    condition [function!] "the condition to check, as a lambda function" 
    block [block!] "the block to fold"
] [
    result: copy []
    while [not tail? block] [
        if (condition first block) [
            append result first block
        ]
        block: next block
    ]
    result
]