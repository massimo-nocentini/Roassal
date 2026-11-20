"
I test the segmented lines, RSSegmentedPolyline and RSSegmentedBeziersPolyline, and the line builders that make them.
"
Class {
	#name : 'RSSegmentedLinesTest',
	#superclass : 'TestCase',
	#category : 'Roassal-Shapes-Tests',
	#package : 'Roassal-Shapes-Tests'
}

{ #category : 'running' }
RSSegmentedLinesTest >> render: aCanvas [
	"Draw aCanvas on a cairo surface, as RSAthensMorph does, and answer the number of pixels that are not the background"

	| surface renderer form background |
	aCanvas extent: 300 @ 300.
	aCanvas zoomToFit.
	surface := AthensCairoSurface extent: 300 @ 300.
	renderer := RSAthensRenderer new.
	surface drawDuring: [ :athensCanvas |
		renderer
			surface: surface;
			canvas: athensCanvas.
		aCanvas accept: renderer ].
	form := surface asForm.
	background := form colorAt: 0 @ 0.
	^ ((0 to: form height - 1) inject: 0 into: [ :sum :y |
		   sum + ((0 to: form width - 1) count: [ :x | (form colorAt: x @ y) ~= background ]) ])
]

{ #category : 'tests' }
RSSegmentedLinesTest >> testHorizontalDeCasteljauSegmentedLine [

	| canvas boxes lines |
	canvas := RSCanvas new.
	boxes := (1 to: 3) collect: [ :i | RSBox new model: i; size: 20; yourself ].
	canvas addAll: boxes.
	boxes second translateTo: 200 @ 150.
	boxes third translateTo: 200 @ -150.
	lines := (RSLineBuilder horizontalSegmentedLine: (RSSegmentedPolyline new
				   lineBlock: [ :points |
					   RSdeCasteljauLine new
						   samplesChebyshev: points size;
						   controlPoints: points;
						   yourself ];
				   junctionBlock: [ :aLine :each | aLine junction: each right: [ :c0 :c1 :c2 | c1 ] ];
				   yourself))
		         canvas: canvas;
		         shapes: boxes;
		         connectFrom: [ :i | i = 1 ifTrue: [ nil ] ifFalse: [ 1 ] ].
	self assert: lines size equals: 2.
	lines do: [ :each |
		self
			assert: each class equals: RSSegmentedPolyline;
			assert: each controlPoints size > 2 ].
	self assert: (self render: canvas) > 100
]

{ #category : 'tests' }
RSSegmentedLinesTest >> testSegmentedBeziersPolyline [

	| line canvas |
	line := RSSegmentedBeziersPolyline new
		        controlPoints: { 0 @ 0. 100 @ 0. 100 @ 200. 200 @ 200 };
		        yourself.
	self assert: line splits notEmpty.
	self assert: (line splits allSatisfy: [ :each | each class == RSBezier ]).
	self assert: line splits first controlPoints first equals: 0 @ 0.
	self assert: line splits last controlPoints last equals: 200 @ 200.
	"A short vertical distance: one Bezier from the first point to the last"
	line controlPoints: { 0 @ 0. 100 @ 0. 100 @ 3. 200 @ 3 }.
	self assert: line splits size equals: 1.
	canvas := RSCanvas new.
	canvas add: (RSSegmentedBeziersPolyline new
			 controlPoints: { 0 @ 0. 100 @ 0. 100 @ 200. 200 @ 200 };
			 yourself).
	self assert: (self render: canvas) > 100
]
