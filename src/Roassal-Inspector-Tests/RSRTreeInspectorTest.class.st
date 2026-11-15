"
I test the inspector views of an RTreeCollection.
"
Class {
	#name : 'RSRTreeInspectorTest',
	#superclass : 'RSTest',
	#category : 'Roassal-Inspector-Tests',
	#package : 'Roassal-Inspector-Tests'
}

{ #category : 'tests' }
RSRTreeInspectorTest >> testViewsShowTheMovesNotYetApplied [
	"updateEntry: may only record a far move, applied at the next query, and the tree can then be
	built again: the views must ask for the root, not read the instance variable"
	| tree boxes far |
	tree := RTreeCollection new.
	boxes := (1 to: 50) collect: [ :i | RSBox new size: 10; model: i; position: (i * 20) @ 0; yourself ].
	tree bulkLoad: boxes.
	far := boxes first.
	far translateTo: 5000 @ 5000.
	tree updateEntry: far.
	#( #inspectorTree: #inspectorWithParent: #inspectorRectangles: ) do: [ :selector | | presenter leaf |
		presenter := tree perform: selector with: SpPresenter new.
		leaf := presenter canvas shapes
			detect: [ :each | each model isLeaf and: [ each model contents == far ] ].
		self assert: leaf model rectangle equals: far encompassingRectangle ]
]
