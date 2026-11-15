"
This class is created for example02BigVisualizationHalfMillion.
This class is just an example of how you can speed the loading process of new elements.

The entries are sorted in space (by x into vertical slices, each slice by y), then the array is
halved recursively. The halves differ by at most one entry, so the tree is balanced for any number
of entries, and it accepts add:, remove: and updateEntry: afterwards.
rembember a balance tree offers a better search experience 
"
Class {
	#name : 'RTBulkLoadRTreeCollection',
	#superclass : 'RTreeCollection',
	#category : 'Roassal-Examples-Basic',
	#package : 'Roassal-Examples',
	#tag : 'Basic'
}

{ #category : 'adding' }
RTBulkLoadRTreeCollection >> bulkLoad: aCollection [
	| sorted |
	aCollection ifEmpty: [ ^ self ].
	"the tree is split by position in the array: neighbours in the array must be neighbours in space"
	sorted := self spatiallySorted: aCollection.
	root := RTNode new.
	root bulkLoad: sorted from: 1 to: sorted size
]

{ #category : 'adding' }
RTBulkLoadRTreeCollection >> spatiallySorted: aCollection [
	"Sort-Tile-Recursive order: by the x of the center into about sqrt(n) vertical slices, each slice by y"
	| items sliceSize sorted index |
	items := (aCollection collect: [ :each | | r |
		r := each encompassingRectangle.
		Array with: r origin x + r corner x with: r origin y + r corner y with: each ]) asArray.
	items sort: [ :a :b | a first <= b first ].
	sliceSize := (items size / items size sqrt ceiling) ceiling.
	sorted := Array new: items size.
	index := 0.
	1 to: items size by: sliceSize do: [ :start | | slice |
		slice := items copyFrom: start to: (start + sliceSize - 1 min: items size).
		slice sort: [ :a :b | a second <= b second ].
		slice do: [ :each | sorted at: (index := index + 1) put: each third ] ].
	^ sorted
]
