"
I build the same scene (boxes, labels, lines with markers, nested composites) in three canvases: one uses an `RTSequenceableCollection` (useList), one an `RTreeCollection` (useRTree), and one is bulk loaded into an `RTBulkLoadRTreeCollection` once the scene is built. Then I apply the same random operations to the three canvases: moves, extent and text changes, rotations, removals one by one and in batch, additions, z-order changes, layouts and moves inside composites. After every few operations, the RTree canvases must answer what the list answers: the shapes at many points (in the same order), the shape with an action, and the shapes in rectangles. Since both collections test the cached rectangle of a shape first, every shape must also have an up-to-date rectangle, and an entryIndex equal to its index.

The seeds are fixed, so a failure can be replayed.
"
Class {
	#name : 'RSShapeCollectionDifferentialTest',
	#superclass : 'RSTest',
	#instVars : [
		'canvases',
		'shapesByModel',
		'random',
		'nextModel'
	],
	#category : 'Roassal-Global-Tests-Rendering',
	#package : 'Roassal-Global-Tests',
	#tag : 'Rendering'
}

{ #category : 'running' }
RSShapeCollectionDifferentialTest >> addInteractionTo: aShape with: aRandom [
	"half of the shapes have an event callback, for shapeWithActionForPosition:"
	aRandom next < 0.5 ifTrue: [ aShape when: RSMouseClick do: [  ] for: self ]
]

{ #category : 'asserting' }
RSShapeCollectionDifferentialTest >> assertCanvasesAgree [
	| reference bounds points rectangles |
	canvases do: [ :each | self assertConsistent: each ].
	reference := canvases first.
	bounds := reference encompassingRectangle expandBy: 20.
	points := ((1 to: 250) collect: [ :i | bounds origin + ((random next * bounds width) @ (random next * bounds height)) ]) asOrderedCollection.
	"points near the centre of the nodes: a stale rectangle hides a node there"
	reference nodes do: [ :node |
		points add: node position + ((random next - 0.5) @ (random next - 0.5)) ].
	"points around the end points of lines, outside or inside their rectangle"
	(reference lines first: (reference lines size min: 15)) do: [ :line | | start end direction normal |
		start := line startPoint.
		end := line endPoint.
		start = end ifFalse: [
			direction := (end - start) / (end - start) r.
			normal := direction y negated @ direction x.
			1 to: 3 do: [ :i |
				points add: end + (direction * random next * line width) + (normal * (random next - 0.5) * line width).
				points add: start - (direction * random next * line width) + (normal * (random next - 0.5) * line width) ] ] ].
	rectangles := (1 to: 25) collect: [ :i | | origin |
		origin := bounds origin + ((random next * bounds width) @ (random next * bounds height)).
		origin extent: (random next * bounds width / 4) @ (random next * bounds height / 4) ].
	canvases allButFirst do: [ :canvas |
		points do: [ :p |
			self assert: (self modelsAt: p in: canvas) equals: (self modelsAt: p in: reference).
			self
				assert: ((canvas shapeWithActionForPosition: p) ifNotNil: [ :shape | shape model ])
				equals: ((reference shapeWithActionForPosition: p) ifNotNil: [ :shape | shape model ]) ].
		rectangles do: [ :r |
			self assert: (self modelsIn: r in: canvas) equals: (self modelsIn: r in: reference) ] ]
]

{ #category : 'asserting' }
RSShapeCollectionDifferentialTest >> assertConsistent: aContainer [
	"the entryIndex of a shape is its index, the cached rectangle of a shape is up to date (both
	collections test it before the shape), and the shape collection holds every shape"
	aContainer privateShapes withIndexDo: [ :each :i |
		self assert: each entryIndex equals: i.
		self assert: each parent identicalTo: aContainer.
		self assert: each encompassingRectangle equals: each computeEncompassingRectangle.
		each isComposite ifTrue: [ self assertConsistent: each ] ].
	self assert: aContainer shapeCollection size equals: aContainer privateShapes size
]

{ #category : 'running' }
RSShapeCollectionDifferentialTest >> buildSceneWithSeed: anInteger [
	canvases := #( #list #rtree #bulk ) collect: [ :kind | | canvas r boxes |
		canvas := RSCanvas new.
		kind = #rtree ifTrue: [ canvas useRTree ].
		r := Random seed: anInteger.
		nextModel := 0.
		boxes := (1 to: 60) collect: [ :i | | box |
			box := (r next < 0.7 ifTrue: [ RSBox ] ifFalse: [ RSEllipse ]) new.
			box
				extent: (r next * 25 + 3) @ (r next * 25 + 3);
				model: self newModel;
				position: (r next * 400) @ (r next * 400).
			self addInteractionTo: box with: r.
			box ].
		canvas addAll: boxes.
		1 to: 15 do: [ :i | | label |
			label := RSLabel new
				text: 'label ' , i printString;
				model: self newModel;
				position: (r next * 400) @ (r next * 400);
				yourself.
			self addInteractionTo: label with: r.
			canvas add: label ].
		1 to: 8 do: [ :i | | composite |
			composite := RSComposite new model: self newModel; yourself.
			kind = #rtree ifTrue: [ composite useRTree ].
			1 to: 3 do: [ :j | | inner |
				inner := RSComposite new model: self newModel; yourself.
				kind = #rtree ifTrue: [ inner useRTree ].
				inner add: (RSBox new size: 15; model: self newModel; yourself).
				inner add: (RSEllipse new size: 9; model: self newModel; position: 4 @ 4; yourself).
				inner adjustToChildren.
				inner position: (r next * 40) @ (r next * 40).
				self addInteractionTo: inner with: r.
				composite add: inner ].
			composite adjustToChildren.
			composite position: (r next * 400) @ (r next * 400).
			kind = #bulk ifTrue: [
				composite children do: [ :each | each shapeCollection: RTBulkLoadRTreeCollection new ].
				composite shapeCollection: RTBulkLoadRTreeCollection new ].
			self addInteractionTo: composite with: r.
			canvas add: composite ].
		1 to: 30 do: [ :i | | line |
			line := RSLine new
				from: (boxes at: (r nextInteger: boxes size));
				to: (boxes at: (r nextInteger: boxes size));
				width: r next * 3 + 0.5;
				model: self newModel;
				yourself.
			r next < 0.5 ifTrue: [ line markerEnd: (RSBox new size: 8; yourself) asMarker ].
			r next < 0.3 ifTrue: [ line markerStart: (RSEllipse new size: 6; yourself) asMarker ].
			self addInteractionTo: line with: r.
			canvas add: line ].
		canvas add: (RSPolyline new
			controlPoints: { 10 @ 10. 200 @ 50. 380 @ 10 };
			model: self newModel;
			yourself).
		kind = #bulk ifTrue: [ canvas shapeCollection: RTBulkLoadRTreeCollection new ].
		canvas ].
	shapesByModel := canvases collect: [ :canvas | | map |
		map := Dictionary new.
		canvas allChildren do: [ :each | map at: each model put: each ].
		map ]
]

{ #category : 'running' }
RSShapeCollectionDifferentialTest >> isAlive: aShape [
	"aShape is in the reference canvas, maybe inside composites"
	| container |
	container := aShape parent.
	[ container isNil or: [ container == canvases first ] ] whileFalse: [ container := container parent ].
	^ container == canvases first
]

{ #category : 'running' }
RSShapeCollectionDifferentialTest >> modelSuchThat: aBlock [
	"the model of a random shape of the reference canvas that satisfies aBlock, or nil"
	| candidates |
	candidates := (shapesByModel first associations
		select: [ :each | (self isAlive: each value) and: [ aBlock value: each value ] ])
		collect: [ :each | each key ].
	candidates ifEmpty: [ ^ nil ].
	candidates := candidates asSortedCollection asArray.
	^ candidates at: (random nextInteger: candidates size)
]

{ #category : 'asserting' }
RSShapeCollectionDifferentialTest >> modelsAt: aPoint in: aCanvas [
	^ ((aCanvas shapeCollection entriesAtPoint: aPoint) collect: [ :each | each model ]) asArray
]

{ #category : 'asserting' }
RSShapeCollectionDifferentialTest >> modelsIn: aRectangle in: aCanvas [
	^ ((aCanvas shapeCollection entriesAtRectangle: aRectangle) collect: [ :each | each model ]) asSet
]

{ #category : 'running' }
RSShapeCollectionDifferentialTest >> newModel [
	^ nextModel := nextModel + 1
]

{ #category : 'running' }
RSShapeCollectionDifferentialTest >> randomDelta [
	^ (random next * 60 - 30) @ (random next * 60 - 30)
]

{ #category : 'running' }
RSShapeCollectionDifferentialTest >> randomOperation [
	"a block that applies the same operation to a canvas and its map from models to shapes"
	| kind topLevel |
	kind := random nextInteger: 13.
	topLevel := [ :shape | shape parent isKindOf: RSCanvas ].
	(kind between: 1 and: 3) ifTrue: [ | m delta |
		m := self modelSuchThat: [ :shape | shape isNode and: [ topLevel value: shape ] ].
		delta := self randomDelta.
		m ifNil: [ ^ nil ].
		^ [ :canvas :map | (map at: m) translateBy: delta ] ].
	kind = 4 ifTrue: [ | m extent |
		m := self modelSuchThat: [ :shape | shape isNode and: [ shape isLabel not and: [ shape isComposite not ] ] ].
		extent := (random next * 30 + 2) @ (random next * 30 + 2).
		m ifNil: [ ^ nil ].
		^ [ :canvas :map | (map at: m) extent: extent ] ].
	kind = 5 ifTrue: [ | m text |
		m := self modelSuchThat: [ :shape | shape isLabel ].
		text := 'label ' , (random nextInteger: 100000) printString.
		m ifNil: [ ^ nil ].
		^ [ :canvas :map | (map at: m) text: text ] ].
	kind = 6 ifTrue: [ | m |
		m := self modelSuchThat: topLevel.
		m ifNil: [ ^ nil ].
		^ [ :canvas :map | (map at: m) remove ] ].
	kind = 7 ifTrue: [ | models |
		models := ((1 to: 4) collect: [ :i | self modelSuchThat: topLevel ]) reject: [ :each | each isNil ].
		^ [ :canvas :map | canvas removeShapes: (models collect: [ :each | map at: each ]) ] ].
	kind = 8 ifTrue: [ | m lineModel other extent position |
		m := self newModel.
		lineModel := self newModel.
		other := self modelSuchThat: [ :shape | shape isNode and: [ topLevel value: shape ] ].
		extent := (random next * 20 + 3) asPoint.
		position := (random next * 400) @ (random next * 400).
		^ [ :canvas :map | | box |
			box := RSBox new extent: extent; model: m; position: position; yourself.
			box when: RSMouseClick do: [  ] for: self.
			canvas add: box.
			map at: m put: box.
			other ifNotNil: [ | line |
				line := RSLine new from: box; to: (map at: other); model: lineModel; yourself.
				line markerEnd: (RSBox new size: 8; yourself) asMarker.
				canvas add: line.
				map at: lineModel put: line ] ] ].
	kind = 9 ifTrue: [ | m selector |
		m := self modelSuchThat: topLevel.
		selector := #( #pushFront: #pushBack: ) at: (random nextInteger: 2).
		m ifNil: [ ^ nil ].
		^ [ :canvas :map | canvas perform: selector with: (map at: m) ] ].
	kind = 10 ifTrue: [ | m other |
		m := self modelSuchThat: topLevel.
		"a node: re-adding m removes the lines connected to it"
		other := self modelSuchThat: [ :shape | shape isNode and: [ (topLevel value: shape) and: [ shape model ~= m ] ] ].
		(m isNil or: [ other isNil ]) ifTrue: [ ^ nil ].
		^ [ :canvas :map | canvas addShape: (map at: m) before: (map at: other) ] ].
	kind = 11 ifTrue: [ | m delta front |
		m := self modelSuchThat: [ :shape | shape parent isKindOf: RSComposite ].
		delta := (random next * 10 - 5) @ (random next * 10 - 5).
		front := random next < 0.3.
		m ifNil: [ ^ nil ].
		^ [ :canvas :map | | shape |
			shape := map at: m.
			shape translateBy: delta.
			front ifTrue: [ shape pushFront ] ] ].
	kind = 12 ifTrue: [ | m variant angle scale |
		m := self modelSuchThat: [ :shape | shape isNode and: [ shape isLabel not and: [ topLevel value: shape ] ] ].
		variant := random nextInteger: 4.
		angle := random nextInteger: 90.
		scale := random next + 0.5.
		m ifNil: [ ^ nil ].
		^ [ :canvas :map | | shape |
			shape := map at: m.
			variant = 1 ifTrue: [ shape loadIdentity ].
			variant = 2 ifTrue: [ shape matrix: (shape matrix copy scaleBy: scale; yourself) ].
			variant > 2 ifTrue: [ shape rotateByDegrees: angle ] ] ].
	random next < 0.3 ifFalse: [ ^ nil ].
	^ [ :canvas :map | RSGridLayout new gapSize: 7; on: canvas nodes ]
]

{ #category : 'running' }
RSShapeCollectionDifferentialTest >> runWithSeed: anInteger operations: count [
	self buildSceneWithSeed: anInteger.
	random := Random seed: anInteger + 1000.
	self assertCanvasesAgree.
	1 to: count do: [ :i | | operation |
		operation := self randomOperation.
		operation ifNotNil: [
			canvases with: shapesByModel do: [ :canvas :map | operation value: canvas value: map ] ].
		i \\ 15 = 0 ifTrue: [ self assertCanvasesAgree ] ].
	self assertCanvasesAgree
]

{ #category : 'tests' }
RSShapeCollectionDifferentialTest >> testRandomOperationsSeed1 [
	self runWithSeed: 1 operations: 300
]

{ #category : 'tests' }
RSShapeCollectionDifferentialTest >> testRandomOperationsSeed2 [
	self runWithSeed: 2 operations: 300
]

{ #category : 'tests' }
RSShapeCollectionDifferentialTest >> testRandomOperationsSeed3 [
	self runWithSeed: 3 operations: 300
]
