Extension { #name : 'Float' }

{ #category : '*Roassal-Utils' }
Float class >> bronzeRatio [

	^ self silverRatio / self goldenRatio
]

{ #category : '*Roassal-Utils' }
Float >> decrement [

	^ self - 1.0
]

{ #category : '*Roassal-Utils' }
Float >> doubled [

	^ self * 2.0
]

{ #category : '*Roassal-Utils' }
Float class >> goldenPlatinumRatio [

	^ self platinumRatio * self goldenRatio
]

{ #category : '*Roassal-Utils' }
Float class >> goldenRatio [

	^ 1.61803398874989484820458683436563811772030917980576286213544862270526046281890244970720720418939113748475
]

{ #category : '*Roassal-Utils' }
Float >> increment [

	^ self + 1.0
]

{ #category : '*Roassal-Utils' }
Float class >> platinumRatio [

	^ self goldenRatio * self goldenRatio
]

{ #category : '*Roassal-Utils' }
Float class >> silverRatio [

	^ 1.0 / self goldenRatio
]

{ #category : '*Roassal-Utils' }
Float class >> π [

	^ self pi
]
