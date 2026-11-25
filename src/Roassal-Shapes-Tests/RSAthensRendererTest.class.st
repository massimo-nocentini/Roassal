"
I am the test class for TSAthensRenderer 
"
Class {
	#name : 'RSAthensRendererTest',
	#superclass : 'RSTest',
	#category : 'Roassal-Shapes-Tests',
	#package : 'Roassal-Shapes-Tests'
}

{ #category : 'helpers' }
RSAthensRendererTest >> assertPartialRepaintOf: aCanvas after: aBlock [
	"Draw aCanvas, change it with aBlock and draw what is dirty: the pixels must be those of a full repaint.
	The tolerance is for the antialiasing of cairo, which depends on the clip"
	| partial full |
	aCanvas asForm.
	aBlock value.
	partial := self pixelsOf: aCanvas.
	aCanvas camera invalidate.
	full := self pixelsOf: aCanvas.
	self assert: (self worstDifferenceBetween: partial and: full) < 24
]

{ #category : 'helpers' }
RSAthensRendererTest >> newCanvas: anExtent [
	^ RSCanvas new
		extent: anExtent;
		yourself
]

{ #category : 'helpers' }
RSAthensRendererTest >> pixelsOf: aCanvas [
	^ aCanvas asForm bits copy
]

{ #category : 'tests' }
RSAthensRendererTest >> testArcCorner [
	| renderer |
	renderer := RSAthensRenderer new.
	self assert: (renderer
		arcCornerTangets: -17.172947580489485@ -71.29423293069038
		p1: -58.258908750504766 @ -212.1459392757739
		r: 220
		rc: 11.316433244555238
		cw: true)

		equals: (-54.9506649278924@ 200.80455223867077) -> (-46.47771241701749@ 215.03446758248086)
]

{ #category : 'tests - dirty rectangle' }
RSAthensRendererTest >> testChangeWhileDrawing [
	"A shape that changes while the canvas is drawn is repainted at the next frame"
	| canvas box hook |
	canvas := self newCanvas: 100 @ 100.
	box := RSBox new
		       extent: 20 @ 20;
		       position: -30 @ 0;
		       color: Color red;
		       yourself.
	hook := RSChangingShapeForTest new.
	hook extent: 20 @ 20; position: 30 @ 0.
	canvas add: box.
	canvas add: hook.
	canvas asForm.
	hook block: [
		hook block: nil.
		box color: Color blue ].
	hook color: Color green.
	canvas asForm.
	self assert: canvas dirtyRectangle isNotNil.
	self assert: (canvas asForm colorAt: 20 @ 50) equals: Color blue.
	self assert: canvas dirtyRectangle isNil
]

{ #category : 'tests - nested' }
RSAthensRendererTest >> testChildrenOfACompositeAfterAQuarterTurn [
	"The sine and the cosine of a quarter turn are not exactly 0: the children in the window are drawn all the same"
	#( 90 270 -90 450 ) do: [ :degrees |
		| canvas composite |
		canvas := self newCanvas: 300 @ 300.
		composite := RSComposite new.
		-19 to: 20 do: [ :i |
			-19 to: 20 do: [ :j |
				composite add: (RSBox new
						 extent: 12 @ 12;
						 position: i * 12 @ (j * 12);
						 color: Color red;
						 yourself) ] ].
		composite adjustToChildren.
		composite rotateByDegrees: degrees.
		canvas add: composite.
		{ 0 @ 0. 0 @ 100. 0 @ -100. -50 @ 0. -50 @ 100. 50 @ -100 } do: [ :position |
			| form |
			canvas camera position: position.
			form := canvas asForm.
			5 to: 295 by: 10 do: [ :x |
				5 to: 295 by: 10 do: [ :y |
					((composite encompassingRectangle insetBy: 10) containsPoint: (canvas camera fromPixelToSpace: x @ y)) ifTrue: [
						self assert: (form colorAt: x @ y) equals: Color red ] ] ] ] ]
]

{ #category : 'tests - nested' }
RSAthensRendererTest >> testChildrenOfACompositeScaledToZero [
	"Nothing of the composite shows, and the other shapes of the canvas are drawn"
	| canvas composite |
	canvas := self newCanvas: 100 @ 100.
	canvas add: (RSBox new
			 extent: 20 @ 20;
			 position: 30 @ 30;
			 color: Color blue;
			 yourself).
	composite := RSComposite new.
	composite add: (RSBox new size: 20; color: Color red; yourself).
	composite adjustToChildren.
	composite scaleBy: 0.
	canvas add: composite.
	self assert: (canvas asForm colorAt: 80 @ 80) equals: Color blue
]

{ #category : 'tests - dirty rectangle' }
RSAthensRendererTest >> testDirtyRectangleOfAChangeOutOfTheWindow [
	"It does not join the window, nor the space origin, to what is out of the window"
	#( #( 0 0 ) #( 400 400 ) #( -400 -400 ) ) do: [ :center |
		| canvas visible box |
		canvas := self newCanvas: 100 @ 100.
		visible := RSBox new extent: 10 @ 10; yourself.
		canvas add: visible.
		box := RSBox new extent: 10 @ 10; position: 7000 @ 7000; yourself.
		canvas add: box.
		canvas camera position: center first @ center second.
		visible translateTo: canvas visibleRectangle floatCenter.
		canvas asForm.
		self assert: canvas dirtyRectangle isNil.
		box color: Color green.
		box translateBy: 1 @ 1.
		self assert: canvas dirtyRectangle isNil.
		visible color: Color green.
		box translateBy: 1 @ 1.
		self assert: canvas dirtyRectangle equals: visible encompassingRectangle ]
]

{ #category : 'tests - dirty rectangle' }
RSAthensRendererTest >> testErrorWhileDrawing [
	"What an error leaves undrawn is still to repaint"
	| canvas hook |
	canvas := self newCanvas: 100 @ 100.
	hook := RSChangingShapeForTest new.
	hook extent: 20 @ 20.
	canvas add: hook.
	canvas asForm.
	hook color: Color green.
	hook block: [ self error: 'while drawing' ].
	self should: [ canvas asForm ] raise: Error.
	hook block: nil.
	self assert: canvas dirtyRectangle equals: hook encompassingRectangle.
	self assert: (canvas asForm colorAt: 50 @ 50) equals: Color green
]

{ #category : 'tests - partial repaint' }
RSAthensRendererTest >> testPartialRepaintNextToALine [
	"The line is in the pixels that the repaint of the box clears, rounded outwards, and not in the rectangle of the box"
	| canvas box |
	canvas := self newCanvas: 200 @ 200.
	box := RSBox new
		       extent: 100 @ 100.2;
		       color: Color red;
		       yourself.
	canvas add: box.
	canvas add: (RSLine new
			 startPoint: -50 @ 50.7;
			 endPoint: 50 @ 50.7;
			 color: Color black;
			 yourself).
	self assertPartialRepaintOf: canvas after: [ box color: Color green ]
]

{ #category : 'tests - partial repaint' }
RSAthensRendererTest >> testPartialRepaintNextToASibling [
	"As testPartialRepaintNextToALine, for two children of a composite"
	| canvas composite box |
	canvas := self newCanvas: 200 @ 200.
	box := RSBox new
		       extent: 100 @ 100.4;
		       color: Color red;
		       yourself.
	composite := RSComposite new.
	composite add: box.
	composite add: (RSBox new
			 extent: 100 @ 10;
			 position: 0 @ 55.4;
			 color: Color blue;
			 yourself).
	composite adjustToChildren.
	composite translateTo: 0 @ 5.
	canvas add: composite.
	self assertPartialRepaintOf: canvas after: [ box color: Color green ]
]

{ #category : 'tests - partial repaint' }
RSAthensRendererTest >> testPartialRepaintOfAChildOfAFixedComposite [
	"The rectangles of a fixed composite are in pixels, also when its nested composites change"
	| canvas composite nested box |
	canvas := self newCanvas: 400 @ 400.
	canvas camera scale: 2; position: 30 @ 20.
	nested := RSComposite new.
	box := RSBox new
		       extent: 30 @ 30;
		       color: Color red;
		       yourself.
	nested add: box.
	nested add: (RSBox new size: 10; position: 60 @ 60; yourself).
	nested adjustToChildren.
	composite := RSComposite new.
	composite add: nested.
	composite adjustToChildren.
	canvas add: composite.
	composite setAsFixed.
	composite translateTo: 220 @ 80.
	self assertPartialRepaintOf: canvas after: [ box color: Color blue ].
	self assertPartialRepaintOf: canvas after: [ box translateBy: 5 @ 5 ]
]

{ #category : 'tests - dirty rectangle' }
RSAthensRendererTest >> testPartialRepaintOfAShapeLeavingTheWindow [
	| canvas box |
	canvas := self newCanvas: 100 @ 100.
	box := RSBox new extent: 10 @ 10; color: Color red; yourself.
	canvas add: box.
	self assertPartialRepaintOf: canvas after: [ box translateTo: 7000 @ 7000 ].
	self assertPartialRepaintOf: canvas after: [ box translateTo: 45 @ 45 ]
]

{ #category : 'helpers' }
RSAthensRendererTest >> worstDifferenceBetween: pixels and: otherPixels [
	"The largest difference of a channel, from 0 to 255"
	^ (1 to: pixels size) inject: 0 into: [ :max :i |
		  | a b |
		  a := pixels at: i.
		  b := otherPixels at: i.
		  a = b
			  ifTrue: [ max ]
			  ifFalse: [
				  #( 0 8 16 24 ) inject: max into: [ :worst :shift |
					  worst max: (((a >> shift) bitAnd: 255) - ((b >> shift) bitAnd: 255)) abs ] ] ]
]
