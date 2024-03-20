"
I am an abstract class for random variables.
"
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
RSRandom >> cdf: x ifLessThan: sBlock else: fBlock [

	^ super next < (self cdf: x)
		  ifTrue: [ sBlock cull: x ]
		  ifFalse: [ fBlock cull: x ]
]
