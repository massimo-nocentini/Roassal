Extension { #name : 'Rectangle' }

{ #category : '*Roassal-Utils' }
Rectangle class >> extentCenteredAtCartesianOrigin: extentPoint [

	^ self origin: extentPoint halved negated extent: extentPoint
]
