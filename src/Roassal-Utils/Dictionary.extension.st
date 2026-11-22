Extension { #name : 'Dictionary' }

{ #category : '*Roassal-Utils' }
Dictionary >> at: aKey inOrderedCollectionAdd: anObject [

	^ (self at: aKey ifAbsentPut: [ OrderedCollection new ])
		  add: anObject;
		  yourself
]

{ #category : '*Roassal-Utils' }
Dictionary >> ifAbsentPutOrderAt: anObject [

	^ self at: anObject ifAbsentPut: [ self size + 1 ]
]
