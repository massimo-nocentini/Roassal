Class {
	#name : 'RandomInteger',
	#superclass : 'RSRandom',
	#instVars : [
		'atLeast',
		'atMost'
	],
	#category : 'Roassal-Utils-Random',
	#package : 'Roassal-Utils',
	#tag : 'Random'
}

{ #category : 'accessing' }
RandomInteger >> atLeast: anObject [

	atLeast := anObject
]

{ #category : 'accessing' }
RandomInteger >> atMost: anObject [

	atMost := anObject
]

{ #category : 'sampling' }
RandomInteger >> cdf: x [

	self shouldNotImplement
]

{ #category : 'initialization' }
RandomInteger >> initialize [

	super initialize.

	self
		atLeast: 0;
		atMost: SmallInteger maxVal
]

{ #category : 'accessing' }
RandomInteger >> next [

	^ self nextIntegerBetween: atLeast and: atMost
]
