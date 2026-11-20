Extension { #name : 'Number' }

{ #category : '*Roassal-Utils' }
Number >> bernstein: n choose: i [

	^ (n choose: i) * (self raisedTo: i) * (1 - self raisedTo: n - i)
]

{ #category : '*Roassal-Utils' }
Number >> decrement [

	^ self - 1
]

{ #category : '*Roassal-Utils' }
Number >> doubled [

	^ self * 2
]

{ #category : '*Roassal-Utils' }
Number class >> fifthCarmichaelNumber [

	^ 2821
]

{ #category : '*Roassal-Utils' }
Number class >> firstCarmichaelNumber [

	^ 561
]

{ #category : '*Roassal-Utils' }
Number class >> fourthCarmichaelNumber [

	^ 2465
]

{ #category : '*Roassal-Utils' }
Number >> halved [

	^ self / 2
]

{ #category : '*Roassal-Utils' }
Number >> increment [

	^ self + 1
]

{ #category : '*Roassal-Utils' }
Number class >> secondCarmichaelNumber [

	^ 1105
]

{ #category : '*Roassal-Utils' }
Number class >> thirdCarmichaelNumber [

	^ 1729
]
