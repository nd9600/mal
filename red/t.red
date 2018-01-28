Red []

a: make object! [m: make map! []]
b: make object! [m: make map! []]
;b: make e []

a/m/x: 1
probe b/m

e: make object! [m: make hash! [x: 1]]
same? get in copy/deep e 'm get in copy/deep e 'm