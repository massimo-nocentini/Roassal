"
I test the notes (RSNote, RSSimplerNote) and the padded compositions of RSBoundingShape.
"
Class {
	#name : 'RSNoteTest',
	#superclass : 'TestCase',
	#category : 'Roassal-Shapes-Tests',
	#package : 'Roassal-Shapes-Tests'
}

{ #category : 'running' }
RSNoteTest >> render: aShape [
	"Draw a canvas with aShape on a cairo surface, as RSAthensMorph does, and answer the number of pixels that are not the background"

	| canvas surface renderer form background |
	canvas := RSCanvas new.
	canvas add: aShape.
	canvas extent: 300 @ 300.
	canvas zoomToFit.
	surface := AthensCairoSurface extent: 300 @ 300.
	renderer := RSAthensRenderer new.
	surface drawDuring: [ :athensCanvas |
		renderer
			surface: surface;
			canvas: athensCanvas.
		canvas accept: renderer ].
	form := surface asForm.
	background := form colorAt: 0 @ 0.
	^ ((0 to: form height - 1) inject: 0 into: [ :sum :y |
		   sum + ((0 to: form width - 1) count: [ :x | (form colorAt: x @ y) ~= background ]) ])
]

{ #category : 'tests' }
RSNoteTest >> testBaseRectangle [

	| box |
	box := RSBox new.
	self
		assert: box extent equals: 10 @ 10;
		assert: box baseRectangle equals: (-5 @ -5 corner: 5 @ 5);
		assert: (box baseRectangleAtPoint: 4 @ 6) equals: (-2 @ -3 corner: 2 @ 3).
	box extent: 30 @ 20.
	self assert: box baseRectangle equals: (-15 @ -10 corner: 15 @ 10)
]

{ #category : 'tests' }
RSNoteTest >> testBoxedWithPad [

	| label composite |
	label := RSLabel new
		         text: 'Roassal';
		         yourself.
	composite := label boxedWithPad: 5.
	self
		assert: composite class equals: RSComposite;
		assert: composite children size equals: 2;
		assert: composite children first class equals: RSBox;
		assert: composite children second equals: label;
		assert: (composite children first extent - (label extent + 10)) abs <= (2 @ 2);
		assert: composite children first position equals: label position.
	self assert: (self render: composite) > 100
]

{ #category : 'tests' }
RSNoteTest >> testNote [

	| note |
	note := RSNote new
		        extent: 120 @ 80;
		        color: Color yellow;
		        withBorder;
		        yourself.
	self assert: (self render: note) > 1000
]

{ #category : 'tests' }
RSNoteTest >> testNotedWithPad [

	| composite |
	composite := (RSLabel new
		              text: 'Roassal';
		              yourself) notedWithPad: Float goldenPlatinumRatio.
	self assert: composite children first class equals: RSNote.
	self assert: (self render: composite) > 100
]

{ #category : 'tests' }
RSNoteTest >> testPaddedWithGoldenRatio [

	| box composite |
	box := RSBox new
		       extent: 100 @ 40;
		       yourself.
	composite := box paddedWithGoldenRatio.
	self
		assert: composite class equals: RSComposite;
		assert: composite children asArray equals: { box };
		assert: (composite extent x - (100 + (100 * Float silverRatio))) abs < 1.0e-6
]

{ #category : 'tests' }
RSNoteTest >> testSimplerNote [

	| note composite |
	note := RSSimplerNote new
		        extent: 120 @ 80;
		        color: Color yellow;
		        withBorder;
		        yourself.
	self assert: (self render: note) > 1000.
	composite := (RSLabel new
		              text: 'Roassal';
		              yourself) padded: 8 withSimplerNoteDo: [ :aNote | aNote color: Color yellow ].
	self assert: composite children first class equals: RSSimplerNote.
	self assert: (self render: composite) > 100
]
