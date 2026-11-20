Class {
	#name : 'RSdeCasteljauWeightedLine',
	#superclass : 'RSdeCasteljauLine',
	#instVars : [
		'weights'
	],
	#category : 'Roassal-Shapes-Lines',
	#package : 'Roassal-Shapes',
	#tag : 'Lines'
}

{ #category : 'adding' }
RSdeCasteljauWeightedLine >> newLine [
	"instance creation"

	^ super newLine
		  weights: weights;
		  yourself
]

{ #category : 'adding' }
RSdeCasteljauWeightedLine >> weights: anObject [
	"accessing"

	weights := anObject
]

{ #category : 'initialization' }
RSdeCasteljauWeightedLine >> initialize [
	"The weights of the two default control points, before my superclass computes my curve: the polynomial one"

	weights := #( 1 1 ).

	super initialize
]
