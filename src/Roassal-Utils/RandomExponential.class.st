Class {
	#name : 'RandomExponential',
	#superclass : 'RSRandom',
	#instVars : [
		'lambda'
	],
	#category : 'Roassal-Utils-Random',
	#package : 'Roassal-Utils',
	#tag : 'Random'
}

{ #category : 'sampling' }
RandomExponential >> cdf: x [

	^ x < 0
		  ifTrue: [ Error signal: 'I accept non negative arguments only.' ]
		  ifFalse: [ 1.0 - (x * lambda) negated exp ]
]

{ #category : 'initialization' }
RandomExponential >> initialize [

	super initialize.

	self lambda: 1.0
]

{ #category : 'initialization' }
RandomExponential >> lambda: anObject [

	lambda := anObject
]

{ #category : 'initialization' }
RandomExponential >> next [

	^ (1.0 - super next) ln negated / lambda
]
