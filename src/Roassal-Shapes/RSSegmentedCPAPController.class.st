Class {
	#name : 'RSSegmentedCPAPController',
	#superclass : 'RSAbstractCPAPController',
	#instVars : [
		'controlPointsController',
		'linearizationPredicate'
	],
	#category : 'Roassal-Shapes-ControlPoints',
	#package : 'Roassal-Shapes',
	#tag : 'ControlPoints'
}

{ #category : 'accessing' }
RSSegmentedCPAPController >> controlPointsController: anObject [
	"accessing"

	controlPointsController := anObject
]

{ #category : 'hooks' }
RSSegmentedCPAPController >> controlPointsFor: aLine [
	"hooks"

	| random anArray from to |
	random := RandomBoxMullerBivariateGaussian new.

	anArray := controlPointsController controlPointsFor: aLine.

	from := anArray first.
	to := anArray last.

	(linearizationPredicate value: from value: to) ifTrue: [
		anArray := Array with: from with: to ].

	anArray := anArray overlappingPairsCollect: [ :aPoint :anotherPoint |
		           | samples distance |
		           distance := aPoint distanceTo: anotherPoint.

		           samples := ((distance closeTo: 0)
			                       ifTrue: [ 0 ]
			                       ifFalse: [ distance ln ceiling ]) max: 4.

		           (((0 to: 1) linspace: samples + 1) collect: [ :t |
			            | tPoint |
			            tPoint := aPoint unitAffine: anotherPoint at: 1 - t.
			            random next + tPoint ]) allButLast ].

	anArray atLast: 1 put: anArray last , { (random next + to) }.

	^ anArray
]

{ #category : 'hooks' }
RSSegmentedCPAPController >> controlPointsFor_: aLine [
	"hooks"

	| random anArray from to |
	random := RandomBoxMullerBivariateGaussian new.

	anArray := controlPointsController controlPointsFor: aLine.

	from := anArray first.
	to := anArray last.

	(linearizationPredicate value: from value: to) ifTrue: [
		anArray := Array with: from with: to ].

	anArray := anArray overlappingPairsCollect: [ :aPoint :anotherPoint |
		           | samples distance |
		           distance := aPoint distanceTo: anotherPoint.

		           samples := ((distance closeTo: 0)
			                       ifTrue: [ 0 ]
			                       ifFalse: [ distance ln ceiling ]) max: 4.

		           (((0 to: 1) linspace: 5) collect: [ :t |
			            | tPoint |
			            tPoint := aPoint unitAffine: anotherPoint at: 1 - t.
			            random next + tPoint ]) allButLast "samples + 1" ].

	anArray
		atLast: 1
		put: anArray last allButLast , { (random next + to) }.

	^ anArray
]

{ #category : 'hooks' }
RSSegmentedCPAPController >> controlPointsFrom: from to: to [

	self shouldNotImplement
]

{ #category : 'initialization' }
RSSegmentedCPAPController >> initialize [
	"initialization"

	super initialize.

	self linearizationPredicate: [ :from :to |
		(from distanceTo: to) < 50 ]
]

{ #category : 'hooks' }
RSSegmentedCPAPController >> linearizationPredicate [
	"accessing"

	^ linearizationPredicate
]

{ #category : 'hooks' }
RSSegmentedCPAPController >> linearizationPredicate: aBlock [
	"accessing"

	linearizationPredicate := aBlock
]
