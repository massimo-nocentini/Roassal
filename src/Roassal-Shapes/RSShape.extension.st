Extension { #name : 'RSShape' }

{ #category : '*Roassal-Shapes' }
RSShape >> asMarker [
	^ RSMarker new shape: self
]

{ #category : '*Roassal-Shapes' }
RSShape >> sameColorAsBorderColor [

	self color: self border color
]
