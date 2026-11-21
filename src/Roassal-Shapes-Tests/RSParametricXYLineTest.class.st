"
I test RSParametricXYLine, whose points come from its functions x and y and from its translation.
"
Class {
	#name : 'RSParametricXYLineTest',
	#superclass : 'TestCase',
	#category : 'Roassal-Shapes-Tests',
	#package : 'Roassal-Shapes-Tests'
}

{ #category : 'asserting' }
RSParametricXYLineTest >> assertPoints: actualPoints closeTo: expectedPoints [

	self assert: actualPoints size equals: expectedPoints size.
	actualPoints with: expectedPoints do: [ :actual :expected |
		self assert: (actual distanceTo: expected) < 1.0e-9 ]
]

{ #category : 'accessing' }
RSParametricXYLineTest >> line [

	^ RSParametricXYLine new
		  parameterization: (RSLinspaceParameterization new
				   from: 0 to: 1 samples: 11;
				   yourself);
		  x: [ :t | t * 100 ] y: [ :t | t squared * 50 ];
		  yourself
]

{ #category : 'tests' }
RSParametricXYLineTest >> testScaleOfAMovedLine [

	| line scaled |
	line := self line.
	line translateBy: 30 @ -40.
	scaled := line scale: 2.
	self
		assertPoints: scaled controlPoints
		closeTo: (line controlPoints collect: [ :each | each * 2 ])
]

{ #category : 'tests' }
RSParametricXYLineTest >> testTranslateKeepsTheFunctions [
	"Moving a line many times, as dragging it does, adds to its translation and does not wrap its functions in new blocks"

	| line x y before |
	line := self line.
	x := line instVarNamed: #x.
	y := line instVarNamed: #y.
	before := line controlPoints copy.

	100 timesRepeat: [ line translateBy: 1 @ 2 ].

	self
		assert: (line instVarNamed: #x) identicalTo: x;
		assert: (line instVarNamed: #y) identicalTo: y;
		assertPoints: line controlPoints
		closeTo: (before collect: [ :each | each + (100 @ 200) ])
]
