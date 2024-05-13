Extension { #name : 'Rectangle' }

{ #category : '*Roassal-Utils' }
Rectangle class >> at00extent: extentPoint [

	^ self origin: extentPoint halved negated extent: extentPoint
]
