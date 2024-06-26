"
I am a builder to create UML package diagrams in Roassal, see examples
"
Class {
	#name : 'RSUMLPackageBuilder',
	#superclass : 'RSUMLAbstractBuilder',
	#instVars : [
		'packages'
	],
	#category : 'Roassal-UML-Builder',
	#package : 'Roassal-UML',
	#tag : 'Builder'
}

{ #category : 'initialization' }
RSUMLPackageBuilder >> initialize [
	super initialize.
	self
		modelDescriptor: RSUMLPackageDescriptor new;
		renderer: RSBasicUMLPackageRenderer new
]

{ #category : 'hooks' }
RSUMLPackageBuilder >> objects [
	^ packages
]

{ #category : 'accessing' }
RSUMLPackageBuilder >> packages [

	^packages
]

{ #category : 'accessing' }
RSUMLPackageBuilder >> packages: aCollection [

	packages := aCollection
]

{ #category : 'rendering' }
RSUMLPackageBuilder >> renderIn: aCanvas [
	super renderIn: aCanvas.
	self layout on: shapes
]
