Extension { #name : 'Point' }

{ #category : '*Roassal-Utils' }
Point >> asFloatPointRound: numberOfWishedDecimal [

	| aPoint |
	aPoint := self asFloatPoint.

	^ (aPoint x round: numberOfWishedDecimal)
	  @ (aPoint y round: numberOfWishedDecimal)
]

{ #category : '*Roassal-Utils' }
Point >> distanceToOrigin [

	^ self distanceTo: 0 @ 0
]

{ #category : '*Roassal-Utils' }
Point >> halved [

	^ self x halved @ self y halved
]

{ #category : '*Roassal-Utils' }
Point >> halvedAsFloat [

	^ self x halved asFloat @ self y halved asFloat
]

{ #category : '*Roassal-Utils' }
Point >> unitAffine: aPoint at: aParam [

	| t |
	t := aParam min: 1 max: 0.

	^ self * t + (1 - t * aPoint)
]

{ #category : '*Roassal-Utils' }
Point >> unitAffine: aPoint at: aParam and: anotherPoint at: anotherParam [

	| t s |
	t := aParam min: 1 max: 0.
	s := anotherParam min: 1 max: 0.


	^ self * t + (aPoint * s) + (1 - t - s * anotherPoint)
]

{ #category : '*Roassal-Utils' }
Point >> xMinusY [

	^ self x - self y
]

{ #category : '*Roassal-Utils' }
Point >> yMinusX [

	^ self y - self x
]

{ #category : '*Roassal-Utils' }
Point >> π [

	| radians |
	radians := (self angle / Float pi) asFraction.

	^ radians < 0
		  ifTrue: [ radians + 2 ]
		  ifFalse: [ radians ]
]
