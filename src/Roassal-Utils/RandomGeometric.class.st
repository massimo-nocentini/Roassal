Class {
	#name : 'RandomGeometric',
	#superclass : 'RandomBernoulli',
	#category : 'Roassal-Utils-Random',
	#package : 'Roassal-Utils',
	#tag : 'Random'
}

{ #category : 'accessing' }
RandomGeometric >> next [

	| failures |
	failures := 0.
	[
	failures := failures + 1.
	super next = 0 ] whileTrue.

	^ failures
]
