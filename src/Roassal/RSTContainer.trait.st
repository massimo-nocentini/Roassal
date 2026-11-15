"
My users can have edges and nodes useful to build graphs with roassal.
My users area:
- RSCanvas
- RSComposite
"
Trait {
	#name : 'RSTContainer',
	#instVars : [
		'shapeCollection',
		'shapesBeingRemoved'
	],
	#category : 'Roassal-Core',
	#package : 'Roassal',
	#tag : 'Core'
}

{ #category : 'adding nodes edges' }
RSTContainer >> add: aShape [
	self
		assert: aShape isNotNil
		description: 'Nil cannot be added to this container'.
	aShape
		addedIn: self; "will choose the correct collection: lines or nodes"
		renderOn: self. "will update if necesary the shape"
	^ aShape
]

{ #category : 'adding nodes edges' }
RSTContainer >> addAll: aCollection [
	"Add a collection of shapes to the canvas. The argument is a collection of shapes."
	self assert: [ aCollection isCollection ] description: 'Need to provide a collection as argument'.
	self assert: [ aCollection allSatisfy: [ :e | e isKindOf: RSShape ] ] description: 'Need to provide a collection of RSShape'.

	"Add each shape"
	aCollection do: [ :aShape | self add: aShape ]
]

{ #category : 'adding' }
RSTContainer >> addAllShapes: aCollection [
	self assert: [ aCollection isCollection ] description: 'Need to provide a collection as argument'.
	self assert: [ aCollection allSatisfy: [ :e | e isKindOf: RSShape ] ] description: 'Need to provide a collection of RSShape'.
	aCollection do: [ :shape | self addShape: shape ]
]

{ #category : 'adding' }
RSTContainer >> addBasicShape: aShape [

	| aCollection |
	aCollection := self privateShapes.
	aCollection add: aShape.
	aShape entryIndex: aCollection size.
	shapeCollection add: aShape.
	aShape invalidate
]

{ #category : 'adding nodes edges' }
RSTContainer >> addEdge: aShape [
	self edges add: aShape.
	^ aShape
]

{ #category : 'adding nodes edges' }
RSTContainer >> addLine: aShape [
	self lines add: aShape.
	^ aShape
]

{ #category : 'adding nodes edges' }
RSTContainer >> addNode: aShape [
	self nodes add: aShape.
	^ aShape
]

{ #category : 'adding' }
RSTContainer >> addShape: aShape [
	aShape addedIn: self
]

{ #category : 'adding' }
RSTContainer >> addShape: aShape before: otherShape [
	| col index otherIndex |
	aShape addedIn: self.
	col := aShape isFixed
		ifTrue: [ self fixedShapes ]
		ifFalse: [ self privateShapes ].
	index := self indexOfShape: aShape in: col.
	col removeAt: index.
	otherIndex := self indexOfShape: otherShape in: col.
	otherIndex = 0 ifTrue: [ ^ col errorNotFound: otherShape ].
	col add: aShape beforeIndex: otherIndex.
	"only the shapes between the old and the new place of aShape moved"
	self renumber: col from: (index min: otherIndex) to: (index max: otherIndex).
	aShape isFixed
		ifFalse: [ self shapeCollection updateEntry: aShape before: otherShape ]
]

{ #category : 'private' }
RSTContainer >> deferRemovalOf: aShape [
	"During removeShapes:, the removal of aShape from my collections waits for the end of the batch.
	Answer whether it does"
	shapesBeingRemoved ifNil: [ ^ false ].
	shapesBeingRemoved add: aShape.
	^ true
]

{ #category : 'private' }
RSTContainer >> indexOfShape: aShape in: aCollection [
	"Answer the index of aShape in aCollection, one of my collections of shapes, or 0. The entryIndex
	of a shape is its index, so the linear search is only a fallback, in case they disagree"
	| index |
	index := aShape entryIndex.
	(index isInteger and: [ index between: 1 and: aCollection size ]) ifTrue: [
		(aCollection at: index) == aShape ifTrue: [ ^ index ] ].
	^ aCollection identityIndexOf: aShape
]

{ #category : 'accessing' }
RSTContainer >> allChildren [
	| allChildren index |
	index := 1.
	allChildren := RSGroup withAll: self shapes.
	[ index <= allChildren size ] whileTrue: [
		allChildren addAll: ((allChildren at: index) children ifNil: [#()]).
		index := index + 1 ].
	^ allChildren
]

{ #category : 'accessing' }
RSTContainer >> children [
	^ self nodes
]

{ #category : 'looking up shapes' }
RSTContainer >> deepShapeFromModel: anObject [
	"Retreive a shape from a given model. Return nil if not found"
	| result |
	result := RSGroup new.
	self deepShapeFromModel: anObject result: result.
	result isEmpty ifTrue: [ ^ nil ].
	^ result first
]

{ #category : 'looking up shapes' }
RSTContainer >> deepShapeFromModel: anObject result: result [
	"Private method"
	| t |
	t := self shapeFromModel: anObject.
	t ifNotNil: [ result add: t ].
	self nodes do: [ :c | c deepShapeFromModel: anObject result: result ]
]

{ #category : 'looking up shapes' }
RSTContainer >> deepShapesFromModel: anObject [
	"Retreive a shape from a given model. Return nil if not found"
	| result |
	result := RSGroup new.
	self deepShapesFromModel: anObject result: result.
	^ result
]

{ #category : 'looking up shapes' }
RSTContainer >> deepShapesFromModel: anObject result: result [
	"Private method"
	self model = anObject ifTrue: [ result add: self ].
	self nodes do: [ :c | c deepShapesFromModel: anObject result: result ]
]

{ #category : 'looking up shapes' }
RSTContainer >> deepShapesFromModels: someObjects [
	"Retreive a shape from a given model. Return nil if not found"
	| result |
	result := RSGroup new.
	self deepShapesFromModels: someObjects result: result.
	^ result
]

{ #category : 'looking up shapes' }
RSTContainer >> deepShapesFromModels: someObjects result: result [
	"Private method"
	(someObjects includes: self model) ifTrue: [ result add: self ].
	self nodes do: [ :c | c deepShapesFromModel: someObjects result: result ]
]

{ #category : 'defaults' }
RSTContainer >> defaultShapeCollection [
	^ RTSequenceableCollection new
]

{ #category : 'accessing' }
RSTContainer >> edges [
	"Return all the lines contained in the canvas."
	^ self privateEdges
		ifNil: [ | res |
			self privateEdges: (res := RSGroup new).
			res ]
]

{ #category : 'accessing' }
RSTContainer >> fixedShapes [
	^ self explicitRequirement
]

{ #category : 'accessing' }
RSTContainer >> lines [
	"Return all the lines contained in the canvas."
	^ self privateEdges
		ifNil: [ | res |
			self privateEdges: (res := RSGroup new).
			res ]
]

{ #category : 'factory' }
RSTContainer >> newBezier [
	| s |
	s := RSBezier new.
	self add: s.
	^ s
]

{ #category : 'factory' }
RSTContainer >> newBox [
	| s |
	s := RSBox new.
	self add: s.
	^ s
]

{ #category : 'factory' }
RSTContainer >> newCircle [
	| s |
	s := RSCircle new.
	self add: s.
	^ s
]

{ #category : 'factory' }
RSTContainer >> newEllipse [
	| s |
	s := RSEllipse new.
	self add: s.
	^ s
]

{ #category : 'factory' }
RSTContainer >> newLabel [
	| s |
	s := RSLabel new.
	self add: s.
	^ s
]

{ #category : 'factory' }
RSTContainer >> newLine [
	| s |
	s := RSLine new.
	self add: s.
	^ s
]

{ #category : 'factory' }
RSTContainer >> newPolygon [
	| s |
	s := RSPolygon new.
	self add: s.
	^ s
]

{ #category : 'factory' }
RSTContainer >> newPolyline [
	| s |
	s := RSPolyline new.
	self add: s.
	^ s
]

{ #category : 'factory' }
RSTContainer >> newSVGPath [
	| s |
	s := RSSVGPath new.
	self add: s.
	^ s
]

{ #category : 'accessing' }
RSTContainer >> nodes [
	"Return all the shapes except lines contained in the canvas."
	^ self privateNodes
		ifNil: [ | res |
			self privateNodes: (res := RSGroup new).
			res ]
]

{ #category : 'accessing' }
RSTContainer >> numberOfEdges [
	"OBSOLETE. USE #numberOfLines INSTEAD"
	"Return the number of edges contained in the container"
	^ self numberOfLines
]

{ #category : 'accessing' }
RSTContainer >> numberOfLines [
	"Return the number of edges contained in the container"
	^ self privateEdges
		ifNil: [ 0 ]
		ifNotNil: [ :aGroupOfEdges | aGroupOfEdges size ]
]

{ #category : 'accessing' }
RSTContainer >> numberOfNodes [
	"Return the number of nodes contained in the container"
	^ self privateNodes
		ifNil: [ 0 ]
		ifNotNil: [ :aGroupOfNodes | aGroupOfNodes size ]
]

{ #category : 'private' }
RSTContainer >> privateEdges [
	^ self explicitRequirement
]

{ #category : 'private' }
RSTContainer >> privateEdges: aTSGroup [
	self explicitRequirement
]

{ #category : 'private' }
RSTContainer >> privateNodes [
	^ self explicitRequirement
]

{ #category : 'private' }
RSTContainer >> privateNodes: aTSGroup [
	self explicitRequirement
]

{ #category : 'private' }
RSTContainer >> privateShapes [
	^ self explicitRequirement
]

{ #category : 'private' }
RSTContainer >> privateShapes: aCollection [
	self explicitRequirement
]

{ #category : 'shapes - ordering' }
RSTContainer >> pushBack: aShape [

	| collection index |
	collection := aShape isFixed
		        ifTrue: [ self fixedShapes ]
		        ifFalse: [ self privateShapes ].
	index := self indexOfShape: aShape in: collection.
	index = 0 ifTrue: [ ^ collection errorNotFound: aShape ].
	collection
		removeAt: index;
		addFirst: aShape.
	aShape isFixed ifFalse: [ self shapeCollection pushBack: aShape ].
	"only the shapes before the old place of aShape moved"
	self renumber: collection from: 1 to: index.
	aShape invalidate
]

{ #category : 'actions' }
RSTContainer >> pushBackEdges [
	"Push back all the edges"
	self edges do: [ :e | e pushBack ]
]

{ #category : 'shapes - ordering' }
RSTContainer >> pushFront: aShape [

	| collection index |
	collection := aShape isFixed
		        ifTrue: [ self fixedShapes ]
		        ifFalse: [ self privateShapes ].
	index := self indexOfShape: aShape in: collection.
	index = 0 ifTrue: [ ^ collection errorNotFound: aShape ].
	collection
		removeAt: index;
		addLast: aShape.
	aShape isFixed ifFalse: [ self shapeCollection pushFront: aShape ].
	"only the shapes after the old place of aShape moved"
	self renumber: collection from: index to: collection size.
	aShape invalidate
]

{ #category : 'private' }
RSTContainer >> removeAll: aSet from: aCollection [
	"Remove from aCollection, in one pass, the shapes that aSet includes; answer them"
	| removed |
	removed := OrderedCollection new.
	aCollection ifNil: [ ^ removed ].
	aCollection removeAllSuchThat: [ :each |
		(aSet includes: each) and: [
			removed add: each.
			true ] ].
	^ removed
]

{ #category : 'private' }
RSTContainer >> removeBatchedFixedShapes: aSet [
	"Only a canvas has fixed shapes"
]

{ #category : 'private' }
RSTContainer >> removeBatchedShapes: aSet [
	"The end of removeShapes:. aSet holds the shapes given to removeShape:, removeNode: and removeEdge:"
	| shapes removed |
	shapes := self privateShapes.
	removed := self removeAll: aSet from: shapes.
	removed ifNotEmpty: [ self renumber: shapes from: 1 to: shapes size ].
	self removeBatchedFixedShapes: aSet.
	self removeAll: aSet from: self privateNodes.
	self removeAll: aSet from: self privateEdges.
	removed ifEmpty: [ ^ self ].
	"RTSequenceableCollection removes an entry with a linear search, and an RTree with more
	removals than entries left is faster to build again"
	(self shapeCollection class == RTSequenceableCollection or: [ removed size > shapes size ])
		ifTrue: [ self shapeCollection: self shapeCollection class new ]
		ifFalse: [ removed do: [ :each | self shapeCollection remove: each ] ]
]

{ #category : 'removing' }
RSTContainer >> removeEdge: anEdge [
	(self deferRemovalOf: anEdge) ifTrue: [ ^ self ].
	self edges remove: anEdge ifAbsent: [  ]
]

{ #category : 'removing' }
RSTContainer >> removeNode: aNode [
	(self deferRemovalOf: aNode) ifTrue: [ ^ self ].
	self nodes remove: aNode ifAbsent: [  ]
]

{ #category : 'removing' }
RSTContainer >> removeShape: aShape [
	^ self explicitRequirement
]

{ #category : 'removing' }
RSTContainer >> removeShapes: aCollection [
	"Remove the shapes of aCollection from their container, as sending #remove to each of them
	does: the lines connected to a removed node are removed too, and every removed shape announces
	an RSShapeRemovedEvent. But my collections of shapes, nodes and lines, the entryIndex of my
	shapes and my shape collection are updated once, at the end. One removeShape: costs O(n): it
	removes the shape from an OrderedCollection and renumbers the shapes after it. So removing
	k shapes one by one costs O(k * n), and removeShapes: costs O(n + k).
	Until the end, the removed shapes, whose parent is already nil, are still in my collections.
	aCollection may be one of my own collections: it does not change during the iteration"

	shapesBeingRemoved ifNotNil: [ ^ aCollection do: [ :each | each remove ] ].
	shapesBeingRemoved := IdentitySet new.
	[ aCollection do: [ :each | each remove ] ] ensure: [
		| batch |
		batch := shapesBeingRemoved.
		shapesBeingRemoved := nil.
		self removeBatchedShapes: batch ]
]

{ #category : 'private' }
RSTContainer >> renumber: aCollection from: start to: stop [
	"The entryIndex of a shape is its index in my shapes (or my fixed shapes): the RTree orders
	the shapes it finds by entryIndex"
	start to: stop do: [ :i | (aCollection at: i) entryIndex: i ]
]

{ #category : 'accessing' }
RSTContainer >> shapeCollection [
	^ shapeCollection
]

{ #category : 'accessing' }
RSTContainer >> shapeCollection: anRSShapeCollection [
	| listOfShapes |
	shapeCollection := anRSShapeCollection.

	listOfShapes := self privateShapes.
	listOfShapes ifNil: [ ^ self ].
	shapeCollection bulkLoad: listOfShapes
]

{ #category : 'looking up shapes' }
RSTContainer >> shapeFromModel: anObject [
	"Retreive a shape from a given model. Return nil if not found"

	^ self nodes shapeFromModel: anObject
]

{ #category : 'accessing' }
RSTContainer >> shapes [
	^ self privateShapes
		ifNil: [ | res |
			self privateShapes: (res := RSGroup new).
			res ]
]

{ #category : 'looking up shapes' }
RSTContainer >> shapesFromModel: anObject [
	"Retreive a shape from a given model. Return nil if not found"

	^ self nodes shapesFromModel: anObject
]

{ #category : 'dirty areas' }
RSTContainer >> updateDirtyRectangleWith: aRectangle [
	self explicitRequirement
]

{ #category : 'private' }
RSTContainer >> updateInShapeCollection: aShape [
	"this is going to update the shape collection cache, spetially in RSRTree"
	self shapeCollection updateEntry: aShape
]

{ #category : 'shape - collection' }
RSTContainer >> useList [
	self shapeCollection: RTSequenceableCollection new
]

{ #category : 'shape - collection' }
RSTContainer >> useRTree [
	"use RTree for big data visualizations"
	self shapeCollection: RTreeCollection new
]

{ #category : 'accessing' }
RSTContainer >> withAllChildren [
	^ self allChildren
		add: self;
		yourself
]
