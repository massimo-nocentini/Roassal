Extension { #name : #RSBitmap }

{ #category : #'*Roassal3-Examples' }
RSBitmap class >> example [
	| image |
	image := self new.
	image form: (self iconNamed: #pharo).
	^ Smalltalk tools inspector inspect: image
]