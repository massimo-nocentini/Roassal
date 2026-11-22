Extension { #name : 'Collection' }

{ #category : '*Roassal-Utils' }
Collection >> at: aKey update: aBlock [

	^ self at: aKey put: (aBlock value: (self at: aKey))
]
