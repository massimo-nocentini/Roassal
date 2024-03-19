Extension { #name : 'Number' }

{ #category : '*Roassal-Utils' }
Number >> bernstein: n choose: i [

	^ (n choose: i) * (self raisedTo: i) * (1 - self raisedTo: n - i)
]

{ #category : '*Roassal-Utils' }
Number >> halved [

	^ self / 2
]
