Class {
	#name : 'RSdeCasteljauRawLine',
	#superclass : 'RSdeCasteljauLine',
	#category : 'Roassal-Shapes-Lines',
	#package : 'Roassal-Shapes',
	#tag : 'Lines'
}

{ #category : 'adding' }
RSdeCasteljauRawLine >> deCasteljau: aSequenceableOfPoints at: t [

	1 to: pointsSize do: [ :k |
		| delta |
		delta := pointsSize - k.

		1 to: delta do: [ :i |
			| aPoint |
			aPoint := (aSequenceableOfPoints at: i)
				          unitAffine: (aSequenceableOfPoints at: i + 1)
				          at: 1 - t.

			aSequenceableOfPoints at: i put: aPoint ] ].

	^ aSequenceableOfPoints first
]
