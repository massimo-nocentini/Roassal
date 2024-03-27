Class {
	#name : 'RSParametricLine',
	#superclass : 'RSPolyline',
	#instVars : [
		'points',
		'pointsSize',
		'sandboxPoints',
		'parameterization',
		'overlappingControlPointsDistance'
	],
	#category : 'Roassal-Shapes-Lines',
	#package : 'Roassal-Shapes',
	#tag : 'Lines'
}

{ #category : 'accessing' }
RSParametricLine >> arcLengthParameterization [
	"accessing"

	self parameterization: RSArcLengthParameterization new
]

{ #category : 'accessing' }
RSParametricLine >> asGroupWithControlNet [
	"converting"

	^ self asGroupWithControlNetColoured: Color gray
]

{ #category : 'accessing' }
RSParametricLine >> controlPoints: aSequenceableOfPoints [
	"accessing"

	| lastPoint |
	pointsSize := aSequenceableOfPoints size.

	points := Array new: pointsSize.
	sandboxPoints := Array new: pointsSize.

	overlappingControlPointsDistance := 0.0.
	lastPoint := aSequenceableOfPoints
		             ifEmpty: [ nil ]
		             ifNotEmpty: [ aSequenceableOfPoints first ].

	aSequenceableOfPoints withIndexDo: [ :each :index |
		| aPoint |
		aPoint := each asFloatPoint.

		overlappingControlPointsDistance := overlappingControlPointsDistance
		                                    + (lastPoint distanceTo: each).
		lastPoint := each.

		points at: index put: aPoint.
		sandboxPoints at: index put: aPoint ].

	self notifyDesignPointsChanged.

	controlPoints := Array new: parameterization size.

	self
		refreshControlPoints;
		resetPath
]

{ #category : 'accessing' }
RSParametricLine >> controlPoints: aSequenceableOfPoints at: t [

	self subclassResponsibility
]

{ #category : 'accessing' }
RSParametricLine >> controlPointsAt: t [
	"accessing"

	self refreshSandboxPoints.

	^ (self controlPoints: sandboxPoints at: t) asFloatPoint
]

{ #category : 'accessing' }
RSParametricLine >> controlPointsSize [
	"accessing"

	^ pointsSize
]

{ #category : 'accessing' }
RSParametricLine >> designPoints [
	"accessing"

	^ points
]

{ #category : 'initialization' }
RSParametricLine >> initialize [
	"initialization"

	super initialize.

	self capRound
]

{ #category : 'accessing' }
RSParametricLine >> newLine [
	"instance creation"

	^ self class new
]

{ #category : 'accessing' }
RSParametricLine >> notifyDesignPointsChanged [
	"accessing"

	self subclassResponsibility
]

{ #category : 'accessing' }
RSParametricLine >> notifyExtentChanged [
	"event handling"

	self announce: [
		RSExtentChangedEvent new
			shape: self;
			oldExtent: nil;
			newExtent: (Rectangle encompassing: self controlPoints) extent ]
]

{ #category : 'accessing' }
RSParametricLine >> overlappingControlPointsDistance [
	"accessing"

	^ overlappingControlPointsDistance
]

{ #category : 'accessing' }
RSParametricLine >> parameterization [
	"accessing"

	^ parameterization
]

{ #category : 'accessing' }
RSParametricLine >> parameterization: anObject [
	"accessing"

	anObject parameterize_RSParametricLine: self
]

{ #category : 'accessing' }
RSParametricLine >> parameterized_RSArcLengthParameterization: aParameterization [
	"accessing"

	parameterization := aParameterization
		                    parameterization: parameterization;
		                    yourself.

	self
		refreshControlPoints;
		resetPath
]

{ #category : 'accessing' }
RSParametricLine >> parameterized_RSIntervalParameterization: aParameterization [
	"accessing"

	parameterization := aParameterization
]

{ #category : 'accessing' }
RSParametricLine >> refreshControlPoints [
	"accessing"

	parameterization withIndexDo: [ :t :index |
		| aPoint |
		aPoint := self controlPointsAt: t.
		controlPoints at: index put: aPoint.

		"Ensure to return the point on the curve."
		aPoint ]
]

{ #category : 'accessing' }
RSParametricLine >> refreshSandboxPoints [
	"accessing"

	sandboxPoints
		replaceFrom: 1
		to: pointsSize
		with: points
		startingAt: 1
]

{ #category : 'accessing' }
RSParametricLine >> reversed [
	"converting"

	^ self newLine
		  controlPoints: points reversed;
		  yourself
]

{ #category : 'accessing' }
RSParametricLine >> scale: factor [
	"accessing"

	^ self newLine
		  controlPoints: (points collect: [ :each | each * factor ]);
		  yourself
]
