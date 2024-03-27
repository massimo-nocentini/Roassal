Class {
	#name : 'RSdeCasteljauRationalWoznyChudyLine',
	#superclass : 'RSdeCasteljauWeightedLine',
	#category : 'Roassal-Shapes-Lines',
	#package : 'Roassal-Shapes',
	#tag : 'Lines'
}

{ #category : 'adding' }
RSdeCasteljauRationalWoznyChudyLine >> weight: aNumber atIndex: anIndex [

	^ (super weight: aNumber atIndex: anIndex) * (weights at: anIndex)
]
