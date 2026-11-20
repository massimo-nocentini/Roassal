Class {
	#name : 'RSdeCasteljauDerivativeLine',
	#superclass : 'RSdeCasteljauLine',
	#category : 'Roassal-Shapes-Lines',
	#package : 'Roassal-Shapes',
	#tag : 'Lines'
}

{ #category : 'adding' }
RSdeCasteljauDerivativeLine >> deCasteljau: aSequenceableOfPoints at: t [

	| aPoint |
	aPoint := 0 @ 0.

	aSequenceableOfPoints withIndexDo: [ :each :i |
		aPoint := aPoint
		          + (each * (t bernstein: pointsSize choose: i) asPoint) ].

	^ pointsSize + 1 * aPoint
]
