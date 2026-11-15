Extension { #name : 'RTNode' }

{ #category : '*Roassal-Examples' }
RTNode >> bulkLoad: aCollection from: a to: b [
	"a and b are indeces, used to copy part of the boxes.
	The halves differ by at most one entry, so the tree is balanced for any size"
	| mid |
	b < a ifTrue: [ ^ self error: 'should not' ].
	a = b ifTrue: [
		contents := aCollection at: a.
		rectangle := contents encompassingRectangle.
		height := 1.
		^ self ].
	mid := a + b // 2.
	self left: (self class new bulkLoad: aCollection from: a to: mid; yourself).
	self right: (self class new bulkLoad: aCollection from: mid + 1 to: b; yourself).
	"the rectangle and the height from the two children; add:, remove: and updateEntry: need the height"
	self computeRectangle
]
