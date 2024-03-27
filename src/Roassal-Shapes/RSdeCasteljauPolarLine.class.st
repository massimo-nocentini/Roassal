Class {
	#name : 'RSdeCasteljauPolarLine',
	#superclass : 'RSdeCasteljauLine',
	#instVars : [
		'ratio'
	],
	#category : 'Roassal-Shapes-Lines',
	#package : 'Roassal-Shapes',
	#tag : 'Lines'
}

{ #category : 'adding' }
RSdeCasteljauPolarLine >> deCasteljau: aSequenceableOfPoints at: t [

	| aPoint n |
	n := aSequenceableOfPoints size - 1.
	aPoint := 0 @ 0.

	1 to: n do: [ :i |
		| each p |
		each := aSequenceableOfPoints at: i.

		p := 1 - ratio * (aSequenceableOfPoints at: i)
		     + (ratio * (aSequenceableOfPoints at: i + 1))
		     * (t bernstein: n - 1 choose: i - 1) asPoint.

		aPoint := aPoint + p ].

	^ aPoint
]

{ #category : 'adding' }
RSdeCasteljauPolarLine >> newLine [
	"instance creation"

	^ super newLine
		  ratio: ratio;
		  yourself
]

{ #category : 'adding' }
RSdeCasteljauPolarLine >> ratio: anObject [
	"accessing"

	ratio := anObject
]
