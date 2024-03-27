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
		'sigma',
		'magic'
	],
	#category : 'Roassal-Utils',
	#package : 'Roassal-Utils'
}

{ #category : 'sampling' }
RandomGaussian >> cdf: x [

	self shouldNotImplement
]

{ #category : 'initialization' }
RandomGaussian >> initialize [

	super initialize.

	magic := -0.5 exp * 4 / 2 sqrt.

	self
		mu: 0;
		sigma: 1
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
	u1 := super next.
	u2 := 1.0 - super next.

	z := u1 - 0.5 * magic / u2.

	(z / 2) squared > u2 log negated ] whileTrue.

	^ z * sigma + mu
]

{ #category : 'accessing' }
RandomGaussian >> sigma: anObject [

	sigma := anObject
]
