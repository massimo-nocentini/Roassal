"
I am a builder to create UML diagrams in Roassal, see examples
"
Class {
	#name : 'RSUMLClassBuilder',
	#superclass : 'RSUMLAbstractBuilder',
	#instVars : [
		'classes'
	],
	#category : 'Roassal-UML-Builder',
	#package : 'Roassal-UML',
	#tag : 'Builder'
}

{ #category : 'accessing' }
RSUMLClassBuilder >> classes [
	^ classes
]

{ #category : 'accessing' }
RSUMLClassBuilder >> classes: aColletionOfClasses [
	classes := aColletionOfClasses
]

{ #category : 'initialization' }
RSUMLClassBuilder >> initialize [
	super initialize.
	self
		modelDescriptor: RSUMLClassDescriptor new;
		renderer: RSBasicUMLClassRenderer new
]

{ #category : 'hooks' }
RSUMLClassBuilder >> objects [
	^ classes
]

{ #category : 'rendering' }
RSUMLClassBuilder >> renderIn: aCanvas [
	super renderIn: aCanvas.
	self renderer edgeBuilder
		canvas: aCanvas;
		shapes: shapes;
		connectFrom: modelDescriptor superclass.
	self layout on: shapes.
	self renderer renderAssociations.
	renderer setUpCanvas: aCanvas
]
