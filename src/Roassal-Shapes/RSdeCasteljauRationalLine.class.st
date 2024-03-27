Class {
	#name : 'RSdeCasteljauRationalLine',
	#superclass : 'RSdeCasteljauWeightedLine',
	#instVars : [
		'mappedPoints'
	],
	#category : 'Roassal-Shapes-Lines',
	#package : 'Roassal-Shapes',
	#tag : 'Lines'
}

{ #category : 'accessing' }
RSdeCasteljauRationalLine >> controlPoints: aSequenceableOfPoints [
	"accessing"

	mappedPoints := Array streamContents: [ :aStream |
		                weights withIndexDo: [ :each :i |
			                | aPoint |
			                aPoint := aSequenceableOfPoints at: i.
			                aStream nextPut: aPoint * each asPoint ] ].

	super controlPoints: aSequenceableOfPoints
]

{ #category : 'accessing' }
RSdeCasteljauRationalLine >> deCasteljau: aSequenceableOfPoints at: t [

	| factor n |
	n := pointsSize - 1.
	factor := 0.0.

	weights withIndexDo: [ :each :i |
		factor := factor + (each * (t bernstein: n choose: i - 1)) ].

	^ (super deCasteljau: mappedPoints at: t) / factor
]
