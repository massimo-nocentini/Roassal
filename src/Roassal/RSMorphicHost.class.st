"
Default host for roassal is MorphicHost, but you can add other one.
"
Class {
	#name : 'RSMorphicHost',
	#superclass : 'RSHost',
	#instVars : [
		'morph',
		'antialiasing',
		'dirtyRectangle'
	],
	#pools : [
		'AthensCairoDefinitions'
	],
	#category : 'Roassal-Core',
	#package : 'Roassal',
	#tag : 'Core'
}

{ #category : 'antialiasing' }
RSMorphicHost >> aaBest [
	self setAA: CAIRO_ANTIALIAS_BEST
]

{ #category : 'antialiasing' }
RSMorphicHost >> aaDefault [
	self setAA: CAIRO_ANTIALIAS_DEFAULT
]

{ #category : 'antialiasing' }
RSMorphicHost >> aaFast [
	self setAA: CAIRO_ANTIALIAS_FAST
]

{ #category : 'antialiasing' }
RSMorphicHost >> aaGood [
	self setAA: CAIRO_ANTIALIAS_GOOD
]

{ #category : 'antialiasing' }
RSMorphicHost >> aaGray [
	self setAA: CAIRO_ANTIALIAS_GRAY
]

{ #category : 'antialiasing' }
RSMorphicHost >> aaNone [
	self setAA: CAIRO_ANTIALIAS_NONE
]

{ #category : 'antialiasing' }
RSMorphicHost >> antialiasing [
	^ antialiasing
]

{ #category : 'converting' }
RSMorphicHost >> asForm [

	| formCanvas |
	formCanvas := FormCanvas extent: canvas extent.

	morph ifNil: [ self createMorph ].
	morph
		extent: formCanvas extent;
		drawOn: formCanvas.

	^ formCanvas form
]

{ #category : 'accessing' }
RSMorphicHost >> canvas: aRSCanvas [

	super canvas: aRSCanvas.
	self createMorph
]

{ #category : 'private' }
RSMorphicHost >> createMorph [
	"Create a Morph that contains myself. This is a private method"

	morph := RSAthensMorph new.
	morph renderer: RSAthensRenderer new.
	morph canvas: canvas.
	^ morph
]

{ #category : 'accessing' }
RSMorphicHost >> dirtyRectangle [
	^ dirtyRectangle
]

{ #category : 'accessing' }
RSMorphicHost >> dirtyRectangle: aRectangleOrNil [
	"Nothing is dirty when aRectangleOrNil is out of the window"

	dirtyRectangle := aRectangleOrNil ifNotNil: [ :rectangle |
		                  rectangle intersect: canvas visibleRectangle ifNone: [ nil ] ]
]

{ #category : 'antialiasing' }
RSMorphicHost >> disableAntialiasing [
	self hasAntialiasing: false
]

{ #category : 'antialiasing' }
RSMorphicHost >> enableAntialiasing [
	self hasAntialiasing: true
]

{ #category : 'antialiasing' }
RSMorphicHost >> hasAntialiasing [
	^ self antialiasing ~= CAIRO_ANTIALIAS_NONE
]

{ #category : 'antialiasing' }
RSMorphicHost >> hasAntialiasing: aBoolean [
	aBoolean
		ifTrue: [ self aaGood ]
		ifFalse: [ self aaNone ]
]

{ #category : 'initialization' }
RSMorphicHost >> initialize [
	super initialize.
	self aaBest
]

{ #category : 'accessing' }
RSMorphicHost >> lastMousePosition [
	^ morph lastMousePosition - morph bounds origin
]

{ #category : 'accessing' }
RSMorphicHost >> morph [
	"Return the Athens morph used by the canvas to render the visualization"

	^ morph
]

{ #category : 'accessing' }
RSMorphicHost >> morph: aMorph [
	"Set the RSAthensMorph. The canvas will directly render in the morph"

	morph := aMorph
]

{ #category : 'opening' }
RSMorphicHost >> openWithTitle: aTitleAsString [
	"Open a canvas with a given title"

	| window |
	self createMorph.
	window := morph openInWindowLabeled: aTitleAsString.
	window extent: 500 @ 500.
	morph privateOwner: window.
	^ window
]

{ #category : 'antialiasing' }
RSMorphicHost >> setAA: aNumber [
	antialiasing := aNumber
]

{ #category : 'signalling' }
RSMorphicHost >> signalUpdate [
	"Signal a platform signal that the canvas should be refreshed. This is important when some shapes are modified (color or position)."

	morph changed
]

{ #category : 'update' }
RSMorphicHost >> updateDirtyRectangleWith: aRectangle [
	"The part of aRectangle in the window is dirty too. The rest is left out before merging, so that
	a change out of the window does not extend what is repainted"

	| visible |
	visible := aRectangle intersect: canvas visibleRectangle ifNone: [ ^ self ].
	dirtyRectangle := dirtyRectangle
		                  ifNil: [ visible ]
		                  ifNotNil: [ :current | current merge: visible ]
]
