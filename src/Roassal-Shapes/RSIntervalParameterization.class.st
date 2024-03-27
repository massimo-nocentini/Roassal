Class {
	#name : 'RSIntervalParameterization',
	#superclass : 'RSParameterization',
	#category : 'Roassal-Shapes-Util',
	#package : 'Roassal-Shapes',
	#tag : 'Util'
}

{ #category : 'as yet unclassified' }
RSIntervalParameterization >> controlPointsChanged: points overlappingDistancesSum: controlPolygonLength [

	| samples |
	samples := (controlPolygonLength / (points size - 1)
	            * Float goldenRatio) floor max: domain size.

	self from: domain first to: domain last samples: samples
]

{ #category : 'as yet unclassified' }
RSIntervalParameterization >> from: from to: to samples: samples [

	cumulativeArcLengths := Array new: samples
]

{ #category : 'as yet unclassified' }
RSIntervalParameterization >> parameterize_RSParametricLine: aLine [
	"dispatching"

	aLine parameterized_RSIntervalParameterization: self
]
