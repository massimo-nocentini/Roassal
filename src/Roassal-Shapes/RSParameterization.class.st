Class {
	#name : 'RSParameterization',
	#superclass : 'RSObject',
	#instVars : [
		'domain',
		'cumulativeArcLengths'
	],
	#category : 'Roassal-Shapes-Util',
	#package : 'Roassal-Shapes',
	#tag : 'Util'
}

{ #category : 'as yet unclassified' }
RSParameterization >> arcLength [

	^ cumulativeArcLengths last
]

{ #category : 'as yet unclassified' }
RSParameterization >> collect: aBlock [
	"I enumerate the domain, just avoid to expose it through an accessor."

	^ domain collect: aBlock
]

{ #category : 'as yet unclassified' }
RSParameterization >> controlPointsChanged: points overlappingDistancesSum: controlPolygonLength [

	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
RSParameterization >> domain [

	^ domain
]

{ #category : 'as yet unclassified' }
RSParameterization >> from [

	^ domain first
]

{ #category : 'as yet unclassified' }
RSParameterization >> parameterize_RSParametricLine: aLine [

	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
RSParameterization >> postCopy [

	domain := domain copy.

	cumulativeArcLengths := cumulativeArcLengths copy
]

{ #category : 'as yet unclassified' }
RSParameterization >> size [

	^ domain size
]

{ #category : 'as yet unclassified' }
RSParameterization >> to [

	^ domain last
]

{ #category : 'as yet unclassified' }
RSParameterization >> unitAt: aNumber [

	^ domain unitAt: aNumber
]

{ #category : 'as yet unclassified' }
RSParameterization >> withIndexDo: aBlock [

	| lastPoint arcLength |
	arcLength := 0.0.
	cumulativeArcLengths at: 1 put: 0.0.

	lastPoint := aBlock value: domain first value: 1.

	2 to: self size do: [ :index |
		| aPoint t |
		t := domain at: index.
		aPoint := aBlock value: t value: index.

		"`arcLength` receives the #+ in order to have a floating addition."
		arcLength := arcLength + (lastPoint distanceTo: aPoint).

		cumulativeArcLengths at: index put: arcLength.

		lastPoint := aPoint ].

	^ cumulativeArcLengths
]
