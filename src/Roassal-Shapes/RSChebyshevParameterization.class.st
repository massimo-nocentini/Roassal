Class {
	#name : 'RSChebyshevParameterization',
	#superclass : 'RSIntervalParameterization',
	#category : 'Roassal-Shapes-Util',
	#package : 'Roassal-Shapes',
	#tag : 'Util'
}

{ #category : 'as yet unclassified' }
RSChebyshevParameterization >> from: from to: to samples: samples [

	domain := (from to: to) chebyshevInclusive: samples.

	super from: from to: to samples: samples
]
