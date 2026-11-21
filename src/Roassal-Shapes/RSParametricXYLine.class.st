Class {
	#name : 'RSParametricXYLine',
	#superclass : 'RSParametricLine',
	#instVars : [
		'x',
		'y',
		'translation'
	],
	#category : 'Roassal-Shapes-Lines',
	#package : 'Roassal-Shapes',
	#tag : 'Lines'
}

{ #category : 'actions' }
RSParametricXYLine >> basicTranslateBy: delta [
	"I have no design points: add delta to my translation, which my points add to the values of my functions, so that moving me often does not nest blocks"

	translation := translation + delta.

	self controlPoints: {  }
]

{ #category : 'accessing' }
RSParametricXYLine >> controlPoints: aSequenceableOfPoints at: t [

	^ (x value: t) + translation x @ ((y value: t) + translation y)
]

{ #category : 'initialization' }
RSParametricXYLine >> initialize [
	"The point 0 @ 0, as the default control points of RSAbstractControlPointsLine, for the parameters 0 and 1, and no translation"

	translation := 0 @ 0.

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
	"My curve scaled by factor, its translation too"

	^ self newLine
		  x: [ :t | (x value: t) * factor ]
		  y: [ :t | (y value: t) * factor ];
		  basicTranslateBy: translation * factor;
		  yourself
]

{ #category : 'accessing' }
RSParametricXYLine >> x: xBlock y: yBlock [

	x := xBlock.
	y := yBlock.

	self controlPoints: {  }
]
