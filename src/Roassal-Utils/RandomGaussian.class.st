"
Uses Kinderman and Monahan method. Reference: Kinderman, A.J. and Monahan, J.F., 
""Computer generation of random variables using the ratio of uniform deviates"", 
ACM Trans Math Software, 3, (1977), pp257-260.
"
Class {
	#name : 'RandomGaussian',
	#superclass : 'RSRandom',
	#instVars : [
		'mu',
		'sigma'
	],
	#classVars : [
		'Magic'
	],
	#category : 'Roassal-Utils-Random',
	#package : 'Roassal-Utils',
	#tag : 'Random'
}

{ #category : 'class initialization' }
RandomGaussian class >> initialize [

	Magic := -0.5 exp * 4.0 / 2 sqrt
]

{ #category : 'sampling' }
RandomGaussian >> cdf: x [

	self shouldNotImplement
]

{ #category : 'initialization' }
RandomGaussian >> initialize [

	super initialize.

	self
		mu: 0.0;
		sigma: 1.0
]

{ #category : 'accessing' }
RandomGaussian >> mu: anObject [

	mu := anObject
]

{ #category : 'accessing' }
RandomGaussian >> next [

	| z |
	[
	| u1 u2 |
	u1 := self nextUniform.
	u2 := 1.0 - self nextUniform.

	z := Magic * (u1 - 0.5) / u2.

	z halved squared > u2 ln negated ] whileTrue.

	^ z times: sigma plus: mu
]

{ #category : 'accessing' }
RandomGaussian >> sigma: anObject [

	sigma := anObject
]
