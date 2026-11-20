Class {
	#name : 'RandomGeometric',
	#superclass : 'RandomBernoulli',
	#category : 'Roassal-Utils-Random',
	#package : 'Roassal-Utils',
	#tag : 'Random'
}

{ #category : 'sampling' }
RandomGeometric >> cdf: x [

	^ x < 1
		  ifTrue: [ 0.0 ]
		  ifFalse: [ 1.0 - (1.0 - p ** x floor) ]
]

{ #category : 'accessing' }
RandomGeometric >> density: x [

	^ (x isInteger and: [ x >= 1 ])
		  ifTrue: [ 1.0 - p ** (x - 1) * p ]
		  ifFalse: [ 0.0 ]
]

{ #category : 'accessing' }
RandomGeometric >> next [
	"The number of Bernoulli trials up to the first success, included"

	| trials |
	trials := 0.
	[
	trials := trials + 1.
	super next = 0 ] whileTrue.

	^ trials
]
