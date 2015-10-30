; These test cases were formerly contained in the test list even though they
; were failing.  They are being broken out so that they can be examined more
; clearly, and to make the day to day testing run with 0 errors so that a
; log diffing is not required.

[equal? mold/all #[email! ""] {#[email! ""]}]
[equal? mold/all #[email! "a"] {#[email! "a"]}]

; bug#2190
[error? try [catch/quit [attempt [quit]] print x]]

[get-path? load "#[get-path! []]"]
[equal? mold/all load "#[get-path! []]" "#[get-path! []]"]
[equal? mold/all load "#[get-path! [a]]" "#[get-path! [a]]"]

; bug#1477
[get-word? first [:/]]
[get-word? first [://]]
[get-word? first [:///]]

[equal? load mold/all #[image! 0x0 #{}] #[image! 0x0 #{}]]

; datatypes/library.r
[
	success: library? a-library: load/library case [
		; this needs to be system-specific
		system/version/4 = 2 [%libc.dylib]					; OSX
		system/version/4 = 3 [%kernel32.dll]				; Windows
		all [
			system/version/4 = 4
			system/version/5 = 2
		] [
			%/lib/libc.so.6									; Linux libc6
		]
		system/version/4 = 4 [%libc.so]						; Linux
		system/version/4 = 7 [%libc.so]						; FreeBSD
		system/version/4 = 8 [%libc.so]						; NetBSD
		system/version/4 = 9 [%libc.so]						; OpenBSD
		system/version/4 = 10 [%libc.so]					; Solaris
	]
	free a-library
	success
]

; bug #1947
[lit-path? load "#[lit-path! []]"]
[equal? mold/all load "#[lit-path! []]" "#[lit-path! []]"]
[equal? mold/all load "#[lit-path! [a]]" "#[lit-path! [a]]"]

[money? USD$1]
[money? CZK$1]


; division uses "full precision"
["$1.0000000000000000000000000" = mold $1 / $1]
["$1.0000000000000000000000000" = mold $1 / $1.0]
["$1.0000000000000000000000000" = mold $1 / $1.000]
["$1.0000000000000000000000000" = mold $1 / $1.000000]
["$1.0000000000000000000000000" = mold $1 / $1.000000000]
["$1.0000000000000000000000000" = mold $1 / $1.000000000000]
["$1.0000000000000000000000000" = mold $1 / $1.0000000000000000000000000]
["$0.10000000000000000000000000" = mold $1 / $10]
["$0.33333333333333333333333333" = mold $1 / $3]
["$0.66666666666666666666666667" = mold $2 / $3]

; bug#1477
[word? '/]
[word? '//]
[word? '///]

; object cloning
; bug#2050
[
	o: make object! [n: 'o b: reduce [func [] [n]]]
	p: make o [n: 'p]
	(o/b)/1 = 'o
]

; bug#1947
[path? load "#[path! []]"]

[equal? mold/all load "#[path! []]" "#[path! []]"]
[equal? mold/all load "#[path! [a]]" "#[path! [a]]"]

[
	a-value: USD$1
	"USD" = a-value/1
]

; path evaluation order
[
	a: 1x2
	found? any [
		error? try [b: a/(a: [3 4] 1)]
		b = 1
		b = 3
	]
]

; bug#1475
[same? 1.7976931348623157e310% load mold/all 1.7976931348623157e310%]

; 64-bit IEEE 754 minimum
[same? -1.7976931348623157E310% load mold/all -1.7976931348623157e310%]

; datatypes/routine.r
[
	success: routine? case [
		; this needs to be system-specific
		system/version/4 = 2 [							; OSX
			a-library: load/library %libc.dylib
			make routine! [
				tv [struct! []]
				tz [struct! []]
				return: [integer!]
			] a-library "settimeofday"
		]
		system/version/4 = 3 [							; Windows
			a-library: load/library %kernel32.dll
			make routine! [
				systemtime [struct! []]
				return: [int]
			] a-library "SetSystemTime"
		]
		all [system/version/4 = 4 system/version/5 = 2] [			; Linux libc6
			a-library: %/lib/libc.so.6
			make routine! [
				tv [struct! []]
				tz [struct! []]
				return: [integer!]
			] a-library "settimeofday"
		]
		system/version/4 = 4 [							; Linux
			a-library: load/library %libc.so
			make routine! [
				tv [struct! []]
				tz [struct! []]
				return: [integer!]
			] a-library "settimeofday"
		]
		system/version/4 = 7 [							; FreeBSD
			a-library: load/library %libc.so
			make routine! [
				tv [struct! []]
				tz [struct! []]
				return: [integer!]
			] a-library "settimeofday"
		]
		system/version/4 = 8 [							; NetBSD
			a-library: load/library %libc.so
			make routine! [
				tv [struct! []]
				tz [struct! []]
				return: [integer!]
			] a-library "settimeofday"
		]
		system/version/4 = 9 [							; OpenBSD
			a-library: load/library %libc.so
			make routine! [
				tv [struct! []]
				tz [struct! []]
				return: [integer!]
			] a-library "settimeofday"
		]
		system/version/4 = 10 [							; Solaris
			a-library: load/library %libc.so
			make routine! [
				tv [struct! []]
				tz [struct! []]
				return: [integer!]
			] a-library "settimeofday"
		]
	]
	free a-library
	success
]

; bug#1947
[set-path? load "#[set-path! []]"]
[equal? mold/all load "#[set-path! []]" "#[set-path! []]"]
[equal? mold/all load "#[set-path! [a]]" "#[set-path! [a]]"]

; bug#1477
[set-word? first [/:]]
[set-word? first [//:]]
[set-word? first [///:]]

; datatypes/struct.r
[struct? make struct! [i [integer!]] none]
[not struct? 1]
[struct! = type? make struct! [] none]
; minimum
[struct? make struct! [] none]
; literal form
[struct? #[struct! [] []]]
[
	s: make string! 15
	addr: func [s] [copy third make struct! [s [string!]] reduce [s]]
	(addr s) = (addr insert/dup s #"0" 15)
]
[false = not make struct! [] none]
[
	a-value: make struct! [] none
	f: does [:a-value]
	same? third :a-value third f
]
[
	a-value: make struct! [i [integer!]] [1]
	1 == a-value/i
]
[
	a-value: make struct! [] none
	same? third :a-value third all [:a-value]
]
[
	a-value: make struct! [] none
	same? third :a-value third all [true :a-value]
]
[
	a-value: make struct! [] none
	true = all [:a-value true]
]
[
	a-value: make struct! [] none
	same? third :a-value third do reduce [:a-value]
]
[
	a-value: make struct! [] none
	same? third :a-value third do :a-value
]
[if make struct! [] none [true]]
[
	a-value: make struct! [] none
	same? third :a-value third any [:a-value]
]
[
	a-value: make struct! [] none
	same? third :a-value third any [false :a-value]
]
[
	a-value: make struct! [] none
	same? third :a-value third any [:a-value false]
]


[equal? mold/all #[tag! ""] {#[tag! ""]}]

[equal? mold/all #[url! ""] {#[url! ""]}]
[equal? mold/all #[url! "a"] {#[url! "a"]}]

; bug#2011
[not equal? load "http://a.b.c/d?e=f%26" load "http://a.b.c/d?e=f&"]

; object! complex structural equivalence
; Slight differences.
; bug#1133
[
	a-value: construct/only [c: $1]
	b-value: construct/only [c: 100%]
	equal? a-value b-value
]
[
	a-value: construct/only [
		a: 1 b: 1.0 c: $1 d: 1%
		e: [a 'a :a a: /a #"a" #{00}]
		f: ["a" #a http://a a@a.com <a>]
		g: :a/b/(c: 'd/e/f)/(b/d: [:f/g h/i])
	]
	b-value: construct/only [
		a: 1.0 b: $1 c: 100% d: 0.01
		e: [/a a 'a :a a: #"A" #[binary! #{0000} 2]]
		f: [#a <A> http://A a@A.com "A"]
		g: :a/b/(c: 'd/e/f)/(b/d: [:f/g h/i])
	]
	equal? a-value b-value
]

; error! difference in infix code
; bug#60: operators generate errors with offset NEAR field
[not equal? (try [1 / 0]) (try [2 / 0])]

; "decimal tolerance"
; bug#1134
[not equiv? to decimal! #{3FD3333333333333} to decimal! #{3FD3333333333334}]

[not equiv? to decimal! #{3FB9999999999999} to decimal! #{3FB999999999999A}]

; bug#2086
[
	bind next block: [a a] use [a] ['a]
	same? 'a first block
]

[
	o: make object! [a: none]
	same? bound? in o 'self bound? in o 'a
]

; bug#1745
[equal? error? try [set /a 1] error? try [set [/a] 1]]
; bug#1745
[equal? error? try [set #a 1] error? try [set [#a] 1]]

; bug#1949: RETURN/redo can break APPLY security
[same? :add attempt [apply does [return/redo :add] []]]

[false == apply/only func [/a] [a] [#[false]]]

['paren! == apply/only :type? [() true]]

;-- CC#2246
[none? case [true []]]

; #1906
[
	b: copy [] insert/dup b 1 32768 compose b
]

; bug#539
[
	f1: does [do "return 1 2" 2]
	1 = f1
]

; bug#1136
#64bit
[
	num: 0
	for i 9223372036854775807 9223372036854775807 1 [
		num: num + 1
		either num > 1 [break/return false] [true]
	]
]
#64bit
[
	num: 0
	for i -9223372036854775808 -9223372036854775808 -1 [
		num: num + 1
		either num > 1 [break/return false] [true]
	]
]
; bug#1994
#64bit
[
	num: 0
	for i 9223372036854775807 9223372036854775807 9223372036854775807 [
		num: num + 1
		if num <> 1 [break/return false]
		true
	]
]

#64bit
[
	num: 0
	for i -9223372036854775808 -9223372036854775808 -9223372036854775808 [
		num: num + 1
		if num <> 1 [break/return false]
		true
	]
]

; bug#1993
[equal? type? for i 1 2 0 [break] type? for i 2 1 0 [break]]
[equal? type? for i -1 -2 0 [break] type? for i -2 -1 0 [break]]

; pair! test (bug#1995)
[[1x1 2x1 1x2 2x2] == collect [repeat i 2x2 [keep i]]]

[  ; bug#1519
	success: true
	cycle?: true
	while [if cycle? [cycle?: false continue success: false] cycle?] []
	success
]

; closure mold
; bug#23
[
	c: closure [a] [print a]
	equal? "make closure! [[a] [print a]]" mold :c
]

; bug#12
[image? to image! make gob! []]

; bug#1613
[exists? http://www.rebol.com/index.html]

[0 = sign? USD$0]

; bug#1894
[
	port: open/new %pokus.txt
	append port newline
]

#64bit
[[1] = copy/part tail [1] -9223372036854775808]

#64bit
[[] = copy/part [] 9223372036854775807]

; functions/series/deline.r
[
	equal?
		"^/"
		deline case [
			system/version/4 = 3  "^M^/" ; CR LF on Windows
			true                  "^/"   ; LF elsewhere
		]
]

; functions/series/enline.r
; bug#2191
[
	equal?
		enline "^/"
		case [
			system/version/4 = 3  "^M^/" ; CR LF on Windows
			true                  "^/"   ; LF elsewhere
		]
]

; bug#647
[string? enline ["a" "b"]]

; bug#854
[
	a: <0>
	b: make tag! 0
	insert b first a
	a == b
]

[
	; The results of decoding lossless encodings should be identical.
	bmp-img: decode 'bmp read %fixtures/rebol-logo.bmp
	gif-img: decode 'gif read %fixtures/rebol-logo.gif
	png-img: decode 'gif read %fixtures/rebol-logo.png
	all [
		bmp-img == gif-img
		bmp-img == png-img
	]
]

[[<b> "hello" </b>] == decode 'markup "<b>hello</b>"]

; GIF encoding is not yet implemented
[out: encode 'gif decode 'gif src: read %fixtures/rebol-logo.gif out == src]
[out: encode 'png decode 'png src: read %fixtures/rebol-logo.png out == src]
; JPEG encoding is not yet implemented
[out: encode 'jpeg decode 'jpeg src: read %fixtures/rebol-logo.jpeg out == src]

; bug#1986
["aβc" = dehex "a%ce%b2c"]

; bug#1986
[(to-string #{61CEB262}) = dehex "a%ce%b2c"]

; bug#1986
[#{61CEB262} = to-binary dehex "a%ce%b2c"]

; system/clipboard.r
; empty clipboard
[
	write clipboard:// ""
	c: read clipboard://
	all [string? c empty? c]
]
; ASCII string
[
	write clipboard:// c: "This is a test."
	d: read clipboard://
	strict-equal? c d
]
; Unicode string
[
	write clipboard:// c: "Příliš žluťoučký kůň úpěl ďábelské ódy."
	strict-equal? read clipboard:// c
]
; OPEN
; bug#1968
[
	p: open clipboard://
	append p c: "Clipboard port test"
	strict-equal? c copy p
]
[
	p: open clipboard://
	write p c: "Clipboard port test"
	strict-equal? c read p
]
; WRITE shall return a port in R3
[equal? read write clipboard:// c: "test" c]

; bug#2186
["äöü" == read/string %fixtures/umlauts-utf32le.txt]
[["äöü"] == read/lines %fixtures/umlauts-utf32le.txt]

; bug#2186
["äöü" == read/string %fixtures/umlauts-utf32be.txt]
[["äöü"] == read/lines %fixtures/umlauts-utf32be.txt]

; bug#1675 (The extra MOLD is to more consistently provoke the crash.)
; Note: these don't work due to the lack of trailing slash, 
; what is the long-term policy on READ for a directory?
[files: read %. mold files block? files]
; bug#1675
[files: read %fixtures mold files block? files]

; empty string rule
; bug#1880
; NOTE: It would seem that considering this a match violates the "parse
; must make progress" rule.
[parse "12" ["" to end]]

; bug#2214
[not parse "abcd" rule: ["ab" (clear rule) "cd"]]