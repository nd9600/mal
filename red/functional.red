Red [
    Title: "Red implementation of Mal - functional programming functions"
]

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
        found? find spec '?
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
    while [not tail? result] [
        replacement: f first result
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