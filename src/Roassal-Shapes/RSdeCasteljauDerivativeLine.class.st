Class {
	#name : 'RSdeCasteljauDerivativeLine',
	#superclass : 'RSdeCasteljauLine',
	#instVars : [
		'translation'
	],
	#category : 'Roassal-Shapes-Lines',
	#package : 'Roassal-Shapes',
	#tag : 'Lines'
}

{ #category : 'actions' }
RSdeCasteljauDerivativeLine >> basicTranslateBy: delta [
	"My curve is not an affine combination of my design points (their sum of weights is not 1): translate it, not them"

	translation := translation + delta.

	self controlPoints: self designPoints
]

{ #category : 'adding' }
RSdeCasteljauDerivativeLine >> deCasteljau: aSequenceableOfPoints at: t [

	| aPoint |
	aPoint := 0 @ 0.

	aSequenceableOfPoints withIndexDo: [ :each :i |
		aPoint := aPoint
		          + (each * (t bernstein: pointsSize choose: i) asPoint) ].

	^ pointsSize + 1 * aPoint + translation
]

{ #category : 'initialization' }
RSdeCasteljauDerivativeLine >> initialize [
	"No translation, before my superclass computes my curve"

	translation := 0 @ 0.

	super initialize
]

{ #category : 'adding' }
RSdeCasteljauDerivativeLine >> newLine [
	"instance creation"

	^ super newLine
		  basicTranslateBy: translation;
		  yourself
]
