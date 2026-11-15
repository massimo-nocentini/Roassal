"
Regression tests for the use of RTree by Roassal: the shape collection of a canvas must follow its shapes,
and a useRTree canvas must answer the same hits as a useList one. The comment of each test describes the bug it covers.
"
Class {
	#name : 'RSRTreeRegressionTest',
	#superclass : 'RSTest',
	#category : 'Roassal-Global-Tests-Rendering',
	#package : 'Roassal-Global-Tests',
	#tag : 'Rendering'
}

{ #category : 'helpers' }
RSRTreeRegressionTest >> canvasesWith: aBlock [
	"two canvases with the same shapes, one with RTSequenceableCollection, one with RTreeCollection"
	^ #( #useList #useRTree ) collect: [ :selector | | canvas |
		canvas := RSCanvas new.
		canvas perform: selector.
		aBlock value: canvas.
		canvas ]
]

{ #category : 'helpers' }
RSRTreeRegressionTest >> modelsAt: aPoint in: aCanvas [
	^ ((aCanvas shapeCollection entriesAtPoint: aPoint) collect: [ :each | each model ]) asArray
]

{ #category : 'tests' }
RSRTreeRegressionTest >> testBulkLoadedCanvasAcceptsChanges [
	"RTBulkLoadRTreeCollection left every height nil: the first drag, add or remove failed"
	| canvas shapes random box |
	canvas := RSCanvas new.
	random := Random seed: 1.
	shapes := (1 to: 100) collect: [ :i |
		RSBox new size: 10; model: i; position: (random next * 500) @ (random next * 500); yourself ].
	canvas addAll: shapes.
	canvas shapeCollection: RTBulkLoadRTreeCollection new.
	self assert: canvas shapeCollection height notNil.
	self assert: canvas shapeCollection isTotalBalanced.
	(shapes first: 30) do: [ :each | each translateBy: 3 @ 3 ].
	box := RSBox new size: 10; model: 101; position: 600 @ 600; yourself.
	canvas add: box.
	canvas removeShape: shapes last.
	self assert: canvas shapeCollection size equals: 100.
	self assert: canvas shapeCollection isTotalBalanced.
	self assert: ((canvas shapeCollection entriesAtPoint: 600 @ 600) includes: box).
	(shapes first: 30) do: [ :each |
		self assert: ((canvas shapeCollection entriesAtPoint: each position) includes: each) ]
]
