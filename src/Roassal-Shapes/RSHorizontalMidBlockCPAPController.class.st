Class {
	#name : 'RSHorizontalMidBlockCPAPController',
	#superclass : 'RSHorizontalCPAPController',
	#instVars : [
		'midPointBlock'
	],
	#category : 'Roassal-Shapes-ControlPoints',
	#package : 'Roassal-Shapes',
	#tag : 'ControlPoints'
}

{ #category : 'hooks' }
RSHorizontalMidBlockCPAPController >> controlPointsFor: aLine [
	"hooks"

	| anArray ratio mid |
	anArray := super controlPointsFor: aLine.

	ratio := midPointBlock
		         value: aLine from
		         value: aLine to
		         value: anArray.

	mid := anArray last x - anArray first x * ratio + anArray first x.

	anArray
		at: 2 put: mid @ anArray second y;
		at: 3 put: mid @ anArray third y.

	^ anArray
]

{ #category : 'hooks' }
RSHorizontalMidBlockCPAPController >> midPointBlock: anObject [
	"accessing"

	midPointBlock := anObject
]
