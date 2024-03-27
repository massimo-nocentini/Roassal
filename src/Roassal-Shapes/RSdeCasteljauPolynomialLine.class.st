Class {
	#name : 'RSdeCasteljauPolynomialLine',
	#superclass : 'RSdeCasteljauLine',
	#category : 'Roassal-Shapes-Lines',
	#package : 'Roassal-Shapes',
	#tag : 'Lines'
}

{ #category : 'adding' }
RSdeCasteljauPolynomialLine >> deCasteljau: aSequenceableOfPoints at: t [

	| aPoint n |
	aPoint := 0 @ 0.

	n := pointsSize - 1.

	aSequenceableOfPoints withIndexDo: [ :each :i |
		aPoint := each * (t bernstein: n choose: i - 1) asPoint + aPoint ].

	^ aPoint
]
