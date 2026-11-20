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

{ #category : 'accessing' }
RSParametricXYLine >> controlPoints: aSequenceableOfPoints at: t [

	^ (x value: t) @ (y value: t)
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
