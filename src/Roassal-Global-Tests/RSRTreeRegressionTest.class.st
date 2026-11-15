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

{ #category : 'tests' }
RSRTreeRegressionTest >> testLineHitsAgree [
	"the list found a line at points around its end points that are outside its rectangle, where the
	tree, which prunes with the rectangle, did not. The points on the far border of a rectangle
	(x = corner x or y = corner y) are left out: RTree v1.01 tests them with the half-open
	Rectangle>>containsPoint:, so only the list finds a line there"
	| canvases |
	canvases := self canvasesWith: [ :canvas | | a b line |
		a := RSBox new size: 20; model: #a; yourself.
		b := RSBox new size: 20; model: #b; position: 0 @ 100; yourself.
		line := RSLine new from: a; to: b; model: #line; yourself.
		canvas add: a; add: b; add: line.
		canvas add: (RSLine new startPoint: 0 @ 0; endPoint: 100 @ 0; width: 1; model: #h; yourself) ].
	{ 0 @ 0. 50 @ 0.2. 100.3 @ 0.1. -0.3 @ 0.1. 0.3 @ 50. 0.2 @ -0.3. 0 @ 100.3 } do: [ :p |
		self assert: (self modelsAt: p in: canvases second) equals: (self modelsAt: p in: canvases first) ].
	self assert: (self modelsAt: 0 @ 100.3 in: canvases first) equals: #( #b ).
	self assert: (self modelsAt: 0.3 @ 50 in: canvases first) equals: #( #line )
]

{ #category : 'tests' }
RSRTreeRegressionTest >> testMarkerAddedAfterTheLineIsInTheTree [
	"a marker enlarges the rectangle of a line: setting it must update the shape collection"
	| canvas line |
	canvas := RSCanvas new.
	canvas useRTree.
	line := RSLine new startPoint: 0 @ 0; endPoint: 200 @ 0; yourself.
	canvas add: line.
	line markerEnd: (RSBox new size: 20; yourself) asMarker.
	self assert: ((canvas shapeCollection entriesAtPoint: 205 @ -8) includes: line).
	self assert: ((canvas shapeCollection entriesAtRectangle: (204 @ -9 corner: 206 @ -7)) includes: line)
]

{ #category : 'tests' }
RSRTreeRegressionTest >> testBitmapFormUpdatesTheShapeCollection [
	"RSBitmap>>form: cleared the cached rectangle without telling the shape collection;
	the new area was not hit and the next move signalled NotFound"
	(self canvasesWith: [ :canvas | | bitmap |
		bitmap := RSBitmap new form: (Form extent: 10 @ 10 depth: 32); model: #bitmap; yourself.
		canvas add: bitmap.
		bitmap form: (Form extent: 200 @ 200 depth: 32) ]) do: [ :canvas | | bitmap |
			bitmap := canvas shapes first.
			self assert: (self modelsAt: 90 @ 0 in: canvas) equals: #( #bitmap ).
			bitmap translateTo: 50 @ 50.
			self assert: (self modelsAt: 140 @ 140 in: canvas) equals: #( #bitmap ).
			self assert: (self modelsAt: -60 @ -60 in: canvas) isEmpty ]
]

{ #category : 'tests' }
RSRTreeRegressionTest >> testRotateByRadiansResetsTheBoundingBox [
	"rotateByRadians: did not reset the bounding box, unlike rotateByDegrees:"
	(self canvasesWith: [ :canvas |
		canvas add: (RSBox new extent: 100 @ 10; model: #box; yourself).
		canvas shapes first rotateByRadians: Float pi / 2 ]) do: [ :canvas |
			self assert: (self modelsAt: 0 @ 40 in: canvas) equals: #( #box ).
			self assert: (self modelsAt: 40 @ 0 in: canvas) isEmpty ]
]

{ #category : 'tests' }
RSRTreeRegressionTest >> testHitOrderWithNestedComposites [
	"the tree orders the shapes that hit by entryIndex and keeps the order of the hits of a
	composite (its children first): the same order as useList"
	| canvases random points |
	random := Random seed: 3.
	points := (1 to: 300) collect: [ :i | (random next * 300) @ (random next * 300) ].
	canvases := self canvasesWith: [ :canvas | | r |
		r := Random seed: 2.
		1 to: 40 do: [ :i | | composite |
			composite := RSComposite new model: i; yourself.
			(canvas shapeCollection isKindOf: RTreeCollection) ifTrue: [ composite useRTree ].
			1 to: 4 do: [ :j | | inner |
				inner := RSComposite new model: i * 100 + j; yourself.
				inner add: (RSBox new size: 20; model: i * 10000 + j; yourself).
				inner add: (RSEllipse new size: 12; model: i * 10000 + j + 50; position: 3 @ 3; yourself).
				inner adjustToChildren.
				inner position: (r next * 40) @ (r next * 40).
				composite add: inner ].
			composite adjustToChildren.
			composite position: (r next * 260) @ (r next * 260).
			canvas add: composite ].
		1 to: 60 do: [ :i | canvas add: (RSBox new size: 30; model: i negated; position: (r next * 300) @ (r next * 300); yourself) ] ].
	points do: [ :p |
		self assert: (self modelsAt: p in: canvases second) equals: (self modelsAt: p in: canvases first) ]
]

{ #category : 'tests' }
RSRTreeRegressionTest >> testLayoutAfterAdd [
	"shapes added at 0@0 to an RTree canvas, then laid out: every removal had to search a tree
	of identical rectangles. The result must equal useList"
	| canvases |
	canvases := self canvasesWith: [ :canvas | | shapes |
		shapes := (1 to: 500) collect: [ :i | RSBox new size: 10; model: i; yourself ].
		canvas addAll: shapes.
		RSGridLayout on: shapes ].
	canvases second shapes with: canvases first shapes do: [ :a :b |
		self assert: a position equals: b position.
		self assert: (self modelsAt: a position in: canvases second) equals: (self modelsAt: b position in: canvases first) ].
	self assert: canvases second shapeCollection isTotalBalanced
]

{ #category : 'helpers' }
RSRTreeRegressionTest >> nonFinitePoints [
	^ {
		  (Float nan @ 10).
		  (10 @ Float nan).
		  (Float infinity @ 10).
		  (10 @ Float infinity negated) }
]

{ #category : 'tests' }
RSRTreeRegressionTest >> testNonFiniteExtentOrPositionIsRejected [
	"a NaN or infinite extent gave the box a NaN rectangle: in an RTree canvas the boxes next to it
	could no longer be found, and moving them signaled NotFound. The setters signal an
	AssertionFailure and leave the shape as it was"
	(self canvasesWith: [ :canvas |
		0 to: 15 do: [ :i |
			canvas add: (RSBox new size: 10; model: i; position: (i \\ 4 * 20) @ (i // 4 * 20); yourself) ] ])
		do: [ :canvas | | box |
			box := canvas shapes first.
			self nonFinitePoints do: [ :point |
				self should: [ box extent: point ] raise: AssertionFailure.
				self should: [ box translateTo: point ] raise: AssertionFailure.
				self should: [ box translateBy: point ] raise: AssertionFailure ].
			self assert: box extent equals: 10 @ 10.
			self assert: box position equals: 0 @ 0.
			canvas shapes do: [ :each |
				each translateBy: 1 @ 1.
				self assert: (self modelsAt: each position in: canvas) equals: { each model } ] ]
]

{ #category : 'tests' }
RSRTreeRegressionTest >> testNonFiniteLinePointsAreRejected [
	"lines accepted NaN or infinite end and control points, with the same effect as a NaN extent"
	(self canvasesWith: [ :canvas |
		canvas add: (RSLine new startPoint: 0 @ 0; endPoint: 100 @ 0; model: #line; yourself).
		canvas add: (RSPolyline new controlPoints: { 0 @ 20. 50 @ 20. 100 @ 20 }; model: #polyline; yourself).
		canvas add: (RSBezier new controlPoints: { 0 @ 40. 50 @ 40. 100 @ 40 }; model: #bezier; yourself) ])
		do: [ :canvas |
			canvas shapes do: [ :line |
				self nonFinitePoints do: [ :point |
					self should: [ line startPoint: point ] raise: AssertionFailure.
					self should: [ line endPoint: point ] raise: AssertionFailure.
					self should: [ line controlPoints: { 0 @ 0. point } ] raise: AssertionFailure.
					self should: [ line translateBy: point ] raise: AssertionFailure ].
				self assert: line startPoint y equals: line endPoint y ].
			self assert: (self modelsAt: 50 @ 0 in: canvas) equals: #( #line ).
			self assert: (self modelsAt: 50 @ 20 in: canvas) equals: #( #polyline ).
			canvas shapes do: [ :line | line translateBy: 0 @ 5 ].
			self assert: (self modelsAt: 50 @ 25 in: canvas) equals: #( #polyline ) ]
]
