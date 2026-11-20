Class {
	#name : 'RSParametricXYLine',
	#superclass : 'RSParametricLine',
	#instVars : [
		'x',
		'y'
	],
	#category : 'Roassal-Shapes-Lines',
	#package : 'Roassal-Shapes',
	#tag : 'Lines'
}

{ #category : 'actions' }
RSParametricXYLine >> basicTranslateBy: delta [
	"I have no design points: translate my functions"

	| xBlock yBlock |
	xBlock := x.
	yBlock := y.

	self
		x: [ :t | (xBlock value: t) + delta x ]
		y: [ :t | (yBlock value: t) + delta y ]
]

{ #category : 'accessing' }
RSParametricXYLine >> controlPoints: aSequenceableOfPoints at: t [

	^ (x value: t) @ (y value: t)
]

{ #category : 'initialization' }
RSParametricXYLine >> initialize [
	"The point 0 @ 0, as the default control points of RSAbstractControlPointsLine, for the parameters 0 and 1"

	super initialize.

	self
		parameterization: (RSLinspaceParameterization new
				 from: 0 to: 1 samples: 2;
				 yourself);
		x: [ :t | 0 ] y: [ :t | 0 ]
]

{ #category : 'accessing' }
RSParametricXYLine >> newLine [
	"instance creation"

	^ super newLine
		  parameterization: (RSLinspaceParameterization new
				   from: parameterization from
				   to: parameterization to
				   samples: parameterization size;
				   yourself);
		  yourself
]

{ #category : 'accessing' }
RSParametricXYLine >> notifyDesignPointsChanged [
	"accessing"

	
]

{ #category : 'accessing' }
RSParametricXYLine >> scale: factor [
	"accessing"

	^ self newLine
		  x: [ :t | (x value: t) * factor ]
		  y: [ :t | (y value: t) * factor ];
		  yourself
]

{ #category : 'accessing' }
RSParametricXYLine >> x: xBlock y: yBlock [

	x := xBlock.
	y := yBlock.

	self controlPoints: {  }
]
