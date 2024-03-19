Class {
	#name : 'RSRandom',
	#superclass : 'Random',
	#category : 'Roassal-Utils-Random',
	#package : 'Roassal-Utils',
	#tag : 'Random'
}

{ #category : 'sampling' }
RSRandom >> cdf: x [

	self subclassResponsibility
]

{ #category : 'sampling' }
RSRandom >> cdf: x ifSuccess: sBlock ifFailure: fBlock [

	^ super next < (self cdf: x)
		  ifTrue: [ sBlock cull: x ]
		  ifFalse: [ fBlock cull: x ]
]
