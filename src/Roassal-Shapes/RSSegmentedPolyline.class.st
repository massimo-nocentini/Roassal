Class {
	#name : 'RSSegmentedPolyline',
	#superclass : 'RSPolyline',
	#instVars : [
		'lineBlock',
		'junctionBlock'
	],
	#category : 'Roassal-Shapes-Lines',
	#package : 'Roassal-Shapes',
	#tag : 'Lines'
}

{ #category : 'accessing' }
RSSegmentedPolyline >> controlPoints: aCollectionOfArrays [
	"accessing"

	| lines aLine points |
	lines := aCollectionOfArrays collect: lineBlock.

	aLine := lines first.

	points := OrderedCollection withAll: aLine controlPoints.

	lines allButFirstDo: [ :each |
		aLine := junctionBlock value: aLine value: each.

		points addAll: aLine controlPoints ].

	super controlPoints: points
]

{ #category : 'accessing' }
RSSegmentedPolyline >> junctionBlock: anObject [
	"accessing"

	junctionBlock := anObject
]

{ #category : 'accessing' }
RSSegmentedPolyline >> lineBlock: anObject [
	"accessing"

	lineBlock := anObject
]
