"
Box–Muller transform, see https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform
"
Class {
	#name : 'RandomBoxMullerBivariateGaussian',
	#superclass : 'RSRandom',
	#category : 'Roassal-Utils-Random',
	#package : 'Roassal-Utils',
	#tag : 'Random'
}

{ #category : 'sampling' }
RandomBoxMullerBivariateGaussian >> cdf: x [

	self shouldNotImplement
]

{ #category : 'accessing' }
RandomBoxMullerBivariateGaussian >> next [

	| z0 z1 z w |
	z := super next ln doubled negated sqrt.
	w := Float twoPi * super next.
	z0 := w cos * z.
	z1 := w sin * z.
	^ z0 @ z1
]
