"
I am a box that evaluates a block when it is drawn, to test what changes, or fails, while a canvas is drawn.
"
Class {
	#name : 'RSChangingShapeForTest',
	#superclass : 'RSBox',
	#instVars : [
		'block'
	],
	#category : 'Roassal-Shapes-Tests',
	#package : 'Roassal-Shapes-Tests'
}

{ #category : 'visiting' }
RSChangingShapeForTest >> accept: aVisitor [
	block ifNotNil: [ block value ].
	^ super accept: aVisitor
]

{ #category : 'accessing' }
RSChangingShapeForTest >> block: aBlock [
	block := aBlock
]
