Class {
	#name : 'RSCollectionTest',
	#superclass : 'ParametrizedTestCase',
	#instVars : [
		'shapeCollection',
		'shapeCollectionClass',
		'canvas'
	],
	#category : 'Roassal-Global-Tests-Rendering',
	#package : 'Roassal-Global-Tests',
	#tag : 'Rendering'
}

{ #category : 'building suites' }
RSCollectionTest class >> testParameters [
	| m classesToConsider |
	m := ParametrizedTestMatrix new.
	"allSubclasses: RTBulkLoadRTreeCollection is a subclass of RTreeCollection"
	classesToConsider := RTAbstractCollection allSubclasses reject: [ :each | each isAbstract ].
	classesToConsider do: [ :cls |
		m addCase: { (#shapeCollectionClass: -> cls) }
	].
	^ m
]

{ #category : 'running' }
RSCollectionTest >> setUp [
	super setUp.
	shapeCollection := self shapeCollectionClass new.
	canvas := RSCanvas new.
	canvas shapeCollection: shapeCollection
]

{ #category : 'accessing' }
RSCollectionTest >> shapeCollection [
	^ shapeCollection
]

{ #category : 'accessing' }
RSCollectionTest >> shapeCollection: anObject [

	shapeCollection := anObject
]

{ #category : 'accessing' }
RSCollectionTest >> shapeCollectionClass [

	^ shapeCollectionClass
]

{ #category : 'accessing' }
RSCollectionTest >> shapeCollectionClass: anObject [
	shapeCollectionClass := anObject
]

{ #category : 'tests - adding' }
RSCollectionTest >> testAdd [
	canvas add: RSBox new.
	self assert: canvas shapes size equals: 1.
	self assert: canvas nodes size equals: 1.
	self assert: canvas lines size equals: 0.
	self assert: canvas fixedShapes size equals: 0.
	self assert: shapeCollection size equals: 1.

	canvas add: RSLine new.
	self assert: canvas shapes size equals: 2.
	self assert: canvas nodes size equals: 1.
	self assert: canvas lines size equals: 1.
	self assert: canvas fixedShapes size equals: 0.
	self assert: shapeCollection size equals: 2.

	canvas add: (RSBox new isFixed: true).
	self assert: canvas shapes size equals: 2.
	self assert: canvas nodes size equals: 2.
	self assert: canvas lines size equals: 1.
	self assert: canvas fixedShapes size equals: 1.
	self assert: shapeCollection size equals: 2.

	canvas addShape: RSBox new.
	self assert: canvas shapes size equals: 3.
	self assert: canvas nodes size equals: 2.
	self assert: canvas lines size equals: 1.
	self assert: canvas fixedShapes size equals: 1.
	self assert: shapeCollection size equals: 3
]

{ #category : 'tests' }
RSCollectionTest >> testBulkLoadOfShapesThenUpdates [
	"setUp gives the collection to an empty canvas. Here it bulk loads the shapes of a canvas, then
	the shapes move, change size, leave, arrive and change order: the collection must answer what a
	list of the same shapes answers"
	| random boxes reference |
	random := Random seed: 11.
	canvas := RSCanvas new.
	boxes := (1 to: 300) collect: [ :i |
		RSBox new
			size: random next * 20 + 5;
			model: i;
			position: (random next * 400) @ (random next * 400);
			yourself ].
	canvas addAll: boxes.
	shapeCollection := self shapeCollectionClass new.
	canvas shapeCollection: shapeCollection.
	self assert: shapeCollection size equals: 300.
	(boxes first: 100) do: [ :each | each translateBy: (random next * 40 - 20) @ (random next * 40 - 20) ].
	(boxes copyFrom: 101 to: 150) do: [ :each | each extent: (random next * 30 + 1) @ (random next * 30 + 1) ].
	(boxes copyFrom: 151 to: 200) do: [ :each | each remove ].
	1 to: 50 do: [ :i |
		canvas add: (RSBox new size: 10; model: 300 + i; position: (random next * 400) @ (random next * 400); yourself) ].
	(1 to: 300 by: 7) do: [ :i | (boxes at: i) isInACanvas ifTrue: [ (boxes at: i) pushFront ] ].
	self assert: shapeCollection size equals: 300.
	reference := RTSequenceableCollection new.
	reference addAll: canvas privateShapes.
	1 to: 500 do: [ :i | | point |
		point := (random next * 440 - 20) @ (random next * 440 - 20).
		self
			assert: ((shapeCollection entriesAtPoint: point) collect: [ :each | each model ]) asArray
			equals: ((reference entriesAtPoint: point) collect: [ :each | each model ]) asArray ].
	1 to: 50 do: [ :i | | rectangle |
		rectangle := (random next * 400) @ (random next * 400) extent: (random next * 80) @ (random next * 80).
		self
			assert: ((shapeCollection entriesAtRectangle: rectangle) collect: [ :each | each model ]) asSet
			equals: ((reference entriesAtRectangle: rectangle) collect: [ :each | each model ]) asSet ]
]

{ #category : 'tests' }
RSCollectionTest >> testContainsPoint [

	| box shape position |
	position := 1000 @ 1000.
	box := RSBox new
		       size: 100 @ 100;
		       position: position;
		       yourself.
	canvas add: box.
	self assert: shapeCollection notEmpty.
	shape := canvas shapeWithActionForPosition: position.
	self assert: shape isNil.
	shape := shapeCollection entryAtPoint: position.
	self assert: shape equals: box.
	box @ RSDraggable.
	shape := canvas shapeWithActionForPosition: position.
	self assert: shape equals: box
]

{ #category : 'tests' }
RSCollectionTest >> testContainsPointInComposite [

	| box shapes position composite |
	position := 1000 @ 1000.
	box := RSBox new
		       size: 100;
		       position: position;
		       yourself.
	composite := { box } asShape size: 200.
	composite draggable.
	canvas add: composite.

	shapes := canvas shapesWithActionForPosition: position.
	self assert: shapes size equals: 1.
	self assert: shapes first equals: composite.
	shapes := shapeCollection entriesAtPoint: position.
	self assert: shapes size equals: 2
]

{ #category : 'tests' }
RSCollectionTest >> testContainsShapeWithInteractions [

	| box shape position |
	position := 1000 @ 1000.
	box := RSBox new
		       size: 100 @ 100;
		       position: position;
		       yourself.
	canvas add: box.
	self assert: shapeCollection notEmpty.
	shape := canvas shapeWithActionForPosition: position.
	self assert: shape isNil.
	shape := shapeCollection entryAtPoint: position.
	self assert: shape equals: box.
	box @ RSDraggable.
	shape := canvas shapeWithActionForPosition: position.
	self assert: shape equals: box
]

{ #category : 'tests' }
RSCollectionTest >> testGetEntriesFromRectangleInParent [

	| listOfShapes box composite |
	box := RSBox new
		       size: 20 @ 20;
		       yourself.
	composite := RSComposite new
		             size: 100;
		             yourself.
	composite add: box.
	shapeCollection add: composite.
	listOfShapes := shapeCollection entriesAtRectangle: (-5 @ -5 corner: 5 @ 5).
	self assert: listOfShapes asArray equals: { composite }
]

{ #category : 'tests' }
RSCollectionTest >> testGetShapeFromRectangle [

	| listOfShapes |
	shapeCollection add: (RSBox new
			 size: 20 @ 20;
			 yourself).
	listOfShapes := shapeCollection entriesAtRectangle: (-5 @ -5 corner: 5 @ 5).
	self assert: (listOfShapes includes: shapeCollection anyOne)
]

{ #category : 'tests' }
RSCollectionTest >> testGetShapesFromRectangle [

	| listOfShapes box1 box2 box3 |
	box1 := RSBox new
		        size: 20 @ 20;
		        position: -50 @ -50;
		        entryIndex: 1;
		        yourself.
	box2 := RSBox new
		        size: 20 @ 20;
		        position: 50 @ 50;
		        entryIndex: 2;
		        yourself.
	box3 := RSBox new
		        size: 20 @ 20;
		        entryIndex: 3;
		        yourself.
	shapeCollection addAll: {
			box1.
			box2.
			box3 }.
	listOfShapes := shapeCollection entriesAtRectangle: (5 @ 5 corner: 45 @ 45).
	self assert: listOfShapes asArray equals: {
			box2.
			box3 }
]

{ #category : 'tests' }
RSCollectionTest >> testGetShapesFromRectangleInCompositeWithChildOutside [

	| listOfShapes box composite |
	box := RSBox new
		       size: 20 @ 20;
		       position: 80 @ 80;
		       yourself.
	composite := RSComposite new
		             size: 100;
		             yourself.
	composite add: box.
	shapeCollection add: composite.
	listOfShapes := shapeCollection entriesAtRectangle: (85 @ 85 corner: 95 @ 95).
	self assert: listOfShapes asArray isEmpty
]

{ #category : 'tests' }
RSCollectionTest >> testOneElement [

	shapeCollection add: (RSBox new size: 10).
	self deny: shapeCollection isEmpty
]

{ #category : 'tests - removing' }
RSCollectionTest >> testRemoveOneElement [
	| box |
	box := RSBox new.
	canvas add: box.
	box remove.
	self assert: canvas shapes isEmpty.
	self assert: shapeCollection isEmpty
]

{ #category : 'tests' }
RSCollectionTest >> testSortResultArray [

	| shapes a b c d tree e |
	shapes := {
		          ((a := RSBox model: 'a') -> { 1. 1 }).
		          ((b := RSBox model: 'b') -> { 1. 2 }).
		          ((c := RSBox model: 'c') -> { 3. 1 }).
		          ((d := RSBox model: 'd') -> { 1. 4 }).
		          ((e := RSBox model: 'e') -> { 1. 4. 1 }) }.
	tree := RTreeCollection new.
	tree sortResultList: shapes.

	self assert: (shapes collect: #key) equals: {
			c.
			e.
			d.
			b.
			a }
]
