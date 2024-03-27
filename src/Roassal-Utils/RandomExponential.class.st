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

	^ x < 0.0
		  ifTrue: [ 0.0 ]
		  ifFalse: [ (x * lambda) negated exp negated increment ]
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

{ #category : 'accessing' }
RandomExponential >> next [

	^ (1.0 - super next) ln negated / lambda
]
