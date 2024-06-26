"
I hold some examples about Bezier curves, computed via the deCasteljau's algorithm in particular.
"
Class {
	#name : 'RSdeCasteljauExamples',
	#superclass : 'RSAbstractExamples',
	#category : 'Roassal-Examples-Basic',
	#package : 'Roassal-Examples',
	#tag : 'Basic'
}

{ #category : 'examples' }
RSdeCasteljauExamples >> example44deCasteljauLine [
	"lines"

	<script: 'self new example44deCasteljauLine open'>
	| points |
	points := {
		          (1 @ 0).
		          (1.66575 @ -0.49197).
		          (3.07038 @ -0.1196).
		          (3 @ 1) } collect: [ :each | each * 100 ].

	^ RSCanvas new
		  addAll: (RSdeCasteljauLine new
				   samplesLinspace: 50;
				   controlPoints: points;
				   asGroupWithControlNet);
		  addShape: (RSBezier new
				   color: Color red;
				   controlPoints: points;
				   yourself);
		  zoomToFit;
		  addInteraction: RSCanvasController new;
		  yourself
]

{ #category : 'examples' }
RSdeCasteljauExamples >> example44deCasteljauLineAsBeziers [
	"lines"

	<script: 'self new example44deCasteljauLineAsBeziers open'>
	| points bezier |
	points := {
		          (1 @ 0).
		          (1.66575 @ -0.49197).
		          (3.07038 @ -0.1196).
		          (3 @ 1) } collect: [ :each | each * 100 ].

	bezier := RSdeCasteljauLine new
		          samplesLinspace: 50;
		          controlPoints: points;
		          yourself.

	^ RSCanvas new
		  addAll: (bezier asGroupWithControlNetColoured: Color red);
		  addAll: bezier asBeziersGroup;
		  zoomToFit;
		  addInteraction: RSCanvasController new;
		  yourself
]

{ #category : 'examples' }
RSdeCasteljauExamples >> example44deCasteljauLineBernsteinBase [
	"lines"

	<script: 'self new example44deCasteljauLineBernsteinBase open'>
	| points |
	points := {
		          (1 @ 1).
		          (3 @ 4).
		          (5 @ 6).
		          (7 @ 8).
		          (10 @ 2).
		          (1 @ 1) }.

	^ RSCanvas new
		  addAll: (RSdeCasteljauLine new
				   samplesLinspace: 50;
				   controlPoints: points;
				   asGroupBernsteinBase);
		  zoomToFit;
		  addInteraction: RSCanvasController new;
		  yourself
]

{ #category : 'examples' }
RSdeCasteljauExamples >> example44deCasteljauLineClosedControlPoints [
	"lines"

	<script: 'self new example44deCasteljauLineClosedControlPoints open'>
	^ RSCanvas new
		  addAll:
			  self lineDeCasteljauLineClosedControlPoints asGroupWithControlNet;
		  zoomToFit;
		  addInteraction: RSCanvasController new;
		  yourself
]

{ #category : 'examples' }
RSdeCasteljauExamples >> example44deCasteljauLineClosedControlPointsArcLengthParameterized [
	"lines"

	<script:
	'self new example44deCasteljauLineClosedControlPointsArcLengthParameterized open'>
	^ RSCanvas new
		  addAll:
			  self lineDeCasteljauLineClosedControlPoints
				  arcLengthParameterization asGroupWithControlNet;
		  zoomToFit;
		  addInteraction: RSCanvasController new;
		  yourself
]

{ #category : 'examples' }
RSdeCasteljauExamples >> example44deCasteljauLineDegreeElevation [
	"lines"

	<script: 'self new example44deCasteljauLineDegreeElevation open'>
	^ self linesDeCasteljauLineDegreeElevation bind: [
		  :bspline1
		  :bspline2
		  :bspline3
		  :bspline4 |
		  RSCanvas new
			  addAll: (bspline1 asGroupWithControlNetColoured: Color gray);
			  addAll: (bspline2 asGroupWithControlNetColoured: Color red);
			  addAll: (bspline3 asGroupWithControlNetColoured: Color blue);
			  addAll: (bspline4 asGroupWithControlNetColoured: Color brown);
			  zoomToFit;
			  addInteraction: RSCanvasController new;
			  yourself ]
]

{ #category : 'examples' }
RSdeCasteljauExamples >> example44deCasteljauLineDerivative [
	"lines"

	<script: 'self new example44deCasteljauLineDerivative open'>
	| points bezier |
	points := {
		          (1 @ 1).
		          (3 @ 4).
		          (5 @ 6).
		          (7 @ 8).
		          (10 @ 2).
		          (1 @ 1) }.

	bezier := RSdeCasteljauLine new
		          samplesLinspace: 50;
		          controlPoints: points;
		          scale: 100.

	^ RSCanvas new
		  addAll: (bezier asGroupWithControlNetColoured: Color red);
		  addAll:
			  (bezier difference derivative asGroupWithControlNetColoured:
					   Color blue);
		  zoomToFit;
		  addInteraction: RSCanvasController new;
		  yourself
]

{ #category : 'examples' }
RSdeCasteljauExamples >> example44deCasteljauLineDifference [
	"lines"

	<script: 'self new example44deCasteljauLineDifference open'>
	| points bezier |
	points := {
		          (1 @ 1).
		          (3 @ 4).
		          (5 @ 6).
		          (7 @ 8).
		          (10 @ 2).
		          (1 @ 1) }.

	bezier := RSdeCasteljauLine new
		          samplesLinspace: 50;
		          controlPoints: points;
		          scale: 100.

	^ RSCanvas new
		  addAll: (bezier asGroupWithControlNetColoured: Color blue);
		  addAll:
			  (bezier difference asGroupWithControlNetColoured: Color red);
		  zoomToFit;
		  addInteraction: RSCanvasController new;
		  yourself
]

{ #category : 'examples' }
RSdeCasteljauExamples >> example44deCasteljauLineJunctionLeft [
	"lines"

	<script: 'self new example44deCasteljauLineJunctionLeft open'>
	| line anotherLine |
	line := RSdeCasteljauLine new
		        samplesLinspace: 50;
		        controlPoints: {
				        (10 @ 12).
				        (13 @ 8.5).
				        (16 @ -2).
				        (26 @ 0) };
		        scale: 100.

	anotherLine := RSdeCasteljauLine new
		               samplesLinspace: 50;
		               controlPoints: {
				               (0 @ 3).
				               (1 @ -4).
				               (5 @ 0) };
		               scale: 100.

	^ line junction: anotherLine left: [ :lineC0 :lineC1 :lineC2 |
		  RSCanvas new
			  addAll: (line asGroupWithControlNetColoured: Color gray);
			  addAll: (anotherLine asGroupWithControlNetColoured: Color brown);
			  addAll: (lineC0 asGroupWithControlNetColoured: Color red);
			  addAll: (lineC1 asGroupWithControlNetColoured: Color blue);
			  addAll: (lineC2 asGroupWithControlNetColoured: Color green);
			  zoomToFit;
			  addInteraction: RSCanvasController new;
			  yourself ]
]

{ #category : 'examples' }
RSdeCasteljauExamples >> example44deCasteljauLineJunctionRight [
	"lines"

	<script: 'self new example44deCasteljauLineJunctionRight open'>
	| aLine anotherLine |
	aLine := RSdeCasteljauLine new
		         samplesLinspace: 50;
		         controlPoints: {
				         (0 @ 0).
				         (1 @ 2).
				         (3 @ 2).
				         (6 @ -1) };
		         scale: 100.

	anotherLine := RSdeCasteljauLine new
		               samplesLinspace: 50;
		               controlPoints: {
				               (15 @ 3).
				               (15 @ 3).
				               (15 @ 3).
				               (15 @ 3).
				               (17 @ -4).
				               (17 @ 0) };
		               scale: 100.

	^ aLine junction: anotherLine right: [ :lineC0 :lineC1 :lineC2 |
		  RSCanvas new
			  addAll: (aLine asGroupWithControlNetColoured: Color gray);
			  addAll: (anotherLine asGroupWithControlNetColoured: Color brown);
			  addAll: (lineC0 asGroupWithControlNetColoured: Color red);
			  addAll: (lineC1 asGroupWithControlNetColoured: Color blue);
			  addAll: (lineC2 asGroupWithControlNetColoured: Color green);
			  zoomToFit;
			  addInteraction: RSCanvasController new;
			  yourself ]
]

{ #category : 'examples' }
RSdeCasteljauExamples >> example44deCasteljauLineNoteBox [
	"lines"

	<script: 'self new example44deCasteljauLineNoteBox open'>
	| line |
	line := self lineDeCasteljauLineNoteBox.

	^ RSCanvas new
		  addAll: line asGroupWithControlNet;
		  zoomToFit;
		  addInteraction: RSCanvasController new;
		  yourself
]

{ #category : 'examples' }
RSdeCasteljauExamples >> example44deCasteljauLineNoteBoxDegreeElevation [
	"lines"

	<script:
	'self new example44deCasteljauLineNoteBoxDegreeElevation open'>
	^ (self lineDeCasteljauLineNoteBox elevate: 100) in: [ :whole |
		  RSCanvas new
			  addAll: whole arcLengthParameterization asGroupWithControlNet;
			  zoomToFit;
			  addInteraction: RSCanvasController new;
			  yourself ]
]

{ #category : 'examples' }
RSdeCasteljauExamples >> example44deCasteljauLineNoteBoxJunctionOfFourBeziers [
	"lines"

	<script:
	'self new example44deCasteljauLineNoteBoxJunctionOfFourBeziers open'>
	| left bottom right top leftBottom rightTop bottomRight topLeft |
	left := RSdeCasteljauLine new
		        samplesLinspace: 50;
		        controlPoints: {
				        (-1.143 @ 17).
				        (0 @ 39.19).
				        (0.429 @ 59.429).
				        (-1.143 @ 70.095).
				        (-2.597 @ 86.21).
				        (0 @ 100) };
		        yourself.
	" (0 @ 0)."

	bottom := RSdeCasteljauLine new
		          samplesLinspace: 50;
		          controlPoints: {
				          (33.024 @ 105.286).
				          (51.077 @ 90.71).
				          (81.187 @ 102.83).
				          (113.583 @ 105.57).
				          (137.6 @ 103.85).
				          (Float goldenRatio @ 1 * 100) };
		          yourself.
	"(0 @ 100)"

	leftBottom := left junction: bottom right: [ :c0 :c1 :c2 | c1 ].

	right := RSdeCasteljauLine new
		         samplesLinspace: 50;
		         controlPoints: ({
				          (0 @ 0).
				          (-1.143 @ 17).
				          (0 @ 39.19).
				          (0.429 @ 59.429).
				          (-1.143 @ 70.095).
				          (-2.597 @ 86.21).
				          (0 @ 100) } reversed collect: [ :each |
					          each x + (Float goldenRatio * 100) @ each y ]);
		         yourself.

	bottomRight := leftBottom junction: right right: [ :c0 :c1 :c2 | c1 ].

	top := RSdeCasteljauLine new
		       samplesLinspace: 50;
		       controlPoints: ({
				        (0 @ 100).
				        (33.024 @ 105.286).
				        (51.077 @ 90.71).
				        (81.187 @ 102.83).
				        (113.583 @ 105.57).
				        (137.6 @ 103.85)
				        " (Float goldenRatio * 100 @ 100)" } reversed collect: [
					        :each | each x @ (each y - 100) ]);
		       yourself.

	rightTop := bottomRight junction: top right: [ :c0 :c1 :c2 | c1 ].

	topLeft := rightTop junction: left right: [ :c0 :c1 :c2 | c1 ].

	^ RSCanvas new
		  addAll: (topLeft asGroupWithControlNetColoured: Color red);
		  addAll: (leftBottom asGroupWithControlNetColoured: Color blue);
		  addAll: (bottomRight asGroupWithControlNetColoured: Color magenta);
		  addAll: (rightTop asGroupWithControlNetColoured: Color green);
		  zoomToFit;
		  addInteraction: RSCanvasController new;
		  yourself
]

{ #category : 'examples' }
RSdeCasteljauExamples >> example44deCasteljauLinePenC [
	"lines"

	<script: 'self new example44deCasteljauLinePenC open'>
	| b1 |
	b1 := RSdeCasteljauLine new
		      samplesLinspace: 50;
		      pen: [ :aBezier |
			      aBezier
				      addPoint: 25 @ 50;
				      addPoint: 150 @ 50 via: 25 @ 100 via: 150 @ 100 ].

	^ RSCanvas new
		  addAll: b1 asGroupWithControlNet;
		  zoomToFit;
		  addInteraction: RSCanvasController new;
		  yourself
]

{ #category : 'examples' }
RSdeCasteljauExamples >> example44deCasteljauLinePenQ [
	"lines"

	<script: 'self new example44deCasteljauLinePenQ open'>
	| b1 |
	b1 := RSdeCasteljauLine new
		      samplesLinspace: 50;
		      pen: [ :aBezier |
			      aBezier
				      addPoint: 25 @ 75;
				      addPoint: 75 @ 100 via: 50 @ 150 ].

	^ RSCanvas new
		  addAll: b1 asGroupWithControlNet;
		  zoomToFit;
		  addInteraction: RSCanvasController new;
		  yourself
]

{ #category : 'examples' }
RSdeCasteljauExamples >> example44deCasteljauLinePenQuote [
	"lines"

	<script: 'self new example44deCasteljauLinePenQuote open'>
	| b1 |
	b1 := RSdeCasteljauLine new
		      samplesLinspace: 100;
		      pen: [ :aBezier |
			      | base |
			      base := 300 @ 419.7.
			      aBezier addPoint: base.
			      aBezier
				      addPoint: 0 @ -290
				      via: 0 @ 0
				      via: 224.2 @ -246.7
				      relativeTo: base.
			      aBezier
				      addBezierPoint: 300 @ 262.4 via: 197 @ 338;
				      addBezierPoint: 300 @ 419.7 via: 242 @ 498.2 ];
		      yourself.

	^ RSCanvas new
		  addAll: b1 asGroupWithControlNet;
		  zoomToFit;
		  addInteraction: RSCanvasController new;
		  yourself
]

{ #category : 'examples' }
RSdeCasteljauExamples >> example44deCasteljauLinePenS [
	"lines"

	<script: 'self new example44deCasteljauLinePenS open'>
	| b1 |
	b1 := RSdeCasteljauLine new
		      samplesLinspace: 50;
		      pen: [ :aBezier |
			      aBezier
				      addPoint: 25 @ 50;
				      addPoint: 150 @ 50 via: 25 @ 100 via: 150 @ 100;
				      addBezierPoint: 300 @ 25 via: 175 @ -50 ].

	^ RSCanvas new
		  addAll: b1 asGroupWithControlNet;
		  zoomToFit;
		  addInteraction: RSCanvasController new;
		  yourself
]

{ #category : 'examples' }
RSdeCasteljauExamples >> example44deCasteljauLinePenT [
	"lines"

	<script: 'self new example44deCasteljauLinePenT open'>
	| b1 |
	b1 := RSdeCasteljauLine new
		      samplesLinspace: 50;
		      pen: [ :aBezier |
			      aBezier
				      addPoint: 25 @ 75;
				      addPoint: 75 @ 100 via: 50 @ 150;
				      addBezierPoint: 150 @ 150 ].

	^ RSCanvas new
		  addAll: b1 asGroupWithControlNet;
		  zoomToFit;
		  addInteraction: RSCanvasController new;
		  yourself
]

{ #category : 'examples' }
RSdeCasteljauExamples >> example44deCasteljauLinePenTwoLines [
	"lines"

	<script: 'self new example44deCasteljauLinePenTwoLines open'>
	| b1 b2 b3 |
	b1 := RSdeCasteljauLine new
		      samplesLinspace: 50;
		      pen: [ :aBezier |
			      aBezier
				      addPoint: 25 @ 50;
				      addPoint: 150 @ 50 via: 25 @ 100 via: 150 @ 100 ].

	b2 := RSdeCasteljauLine new
		      samplesLinspace: 50;
		      pen: [ :aBezier |
			      aBezier
				      addPoint: b1 designPoints last;
				      addPoint: 250 @ 25
				      via:
					      (b1 designPoints nextToLast reflectedAbout:
							       b1 designPoints last)
				      via: 200 @ 0 ].

	b3 := RSdeCasteljauLine new
		      samplesLinspace: 50;
		      pen: [ :aBezier |
			      aBezier
				      addPoint: 200 @ 0;
				      addPoint: 250 @ 25 ].

	^ RSCanvas new
		  addAll: b1 asGroupWithControlNet;
		  addAll: (b2 asGroupWithControlNetColoured: Color red);
		  addAll: ((b1 junction: b3 right: [ :c0 :c1 :c2 | c1 ])
				   asGroupWithControlNetColoured: Color blue);
		  zoomToFit;
		  addInteraction: RSCanvasController new;
		  yourself
]

{ #category : 'examples' }
RSdeCasteljauExamples >> example44deCasteljauLinePolar [
	"lines"

	<script: 'self new example44deCasteljauLinePolar open'>
	| points bezier |
	points := {
		          (0 @ 0).
		          (0 @ 4).
		          (2 @ 4).
		          (1 @ 2) }.

	bezier := RSdeCasteljauLine new
		          samplesLinspace: 50;
		          controlPoints: points;
		          scale: 100.

	^ RSCanvas new
		  addAll: (bezier asGroupWithControlNetColoured: Color red);
		  addAll:
			  ((bezier polar: 1 / 2) asGroupWithControlNetColoured: Color blue);
		  zoomToFit;
		  addInteraction: RSCanvasController new;
		  yourself
]

{ #category : 'examples' }
RSdeCasteljauExamples >> example44deCasteljauLineReflection [
	"lines"

	<script: 'self new example44deCasteljauLineReflection open'>
	| b1 p1 p2 p3 p4 p5 p6 |
	p1 := 200 @ 100.
	p2 := 0 @ 200.
	p3 := p2 reflectedAbout: p1.

	p4 := 600 @ 300.
	p5 := 800 @ 100.
	p6 := p5 reflectedAbout: p4.

	b1 := RSdeCasteljauLine new
		      samplesLinspace: 50;
		      controlPoints: {
				      p1.
				      p2.
				      p3.
				      p4.
				      p5.
				      p6 };
		      yourself.

	^ RSCanvas new
		  addAll: (b1 asGroupWithControlNetColoured: Color green);
		  zoomToFit;
		  addInteraction: RSCanvasController new;
		  " addAll: (b1 asGroupWithControlNetColoured: Color red);
		  addAll: (b2 asGroupWithControlNetColoured: Color blue);"
			  yourself
]

{ #category : 'examples' }
RSdeCasteljauExamples >> example44deCasteljauLineRepeatedControlPoint [
	"lines"

	<script: 'self new example44deCasteljauLineRepeatedControlPoint open'>
	| simpleControlPoints repetitionControlPoints aPoint |
	aPoint := 10 @ 1.

	simpleControlPoints := {
		                       (2 @ 4).
		                       (6 @ 12).
		                       aPoint.
		                       (12 @ 12) } collect: [ :each | each * 100 ].

	repetitionControlPoints := {
		                           (2 @ 4).
		                           (6 @ 12).
		                           aPoint.
		                           aPoint.
		                           aPoint.
		                           aPoint.
		                           (12 @ 12) } collect: [ :each |
		                           each * 100 ].

	^ RSCanvas new
		  addAll: (RSdeCasteljauLine new
				   samplesLinspace: 50;
				   controlPoints: simpleControlPoints;
				   asGroupWithControlNetColoured: Color red);
		  addAll: (RSdeCasteljauLine new
				   samplesLinspace: 50;
				   controlPoints: repetitionControlPoints;
				   asGroupWithControlNetColoured: Color blue);
		  zoomToFit;
		  addInteraction: RSCanvasController new;
		  yourself
]

{ #category : 'examples' }
RSdeCasteljauExamples >> example44deCasteljauLineReversed [
	"lines"

	<script: 'self new example44deCasteljauLineReversed open'>
	| points line |
	points := {
		          (1 @ 0).
		          (1.66575 @ -0.49197).
		          (3.07038 @ -0.1196).
		          (3 @ 1) } collect: [ :each | each * 100 ].

	line := RSdeCasteljauLine new
		        samplesLinspace: 50;
		        controlPoints: points;
		        yourself.

	^ RSCanvas new
		  addAll: (line asGroupWithControlNetColoured: Color red);
		  addAll: (line reversed asGroupWithControlNetColoured: Color blue);
		  zoomToFit;
		  addInteraction: RSCanvasController new;
		  yourself
]

{ #category : 'examples' }
RSdeCasteljauExamples >> example44deCasteljauLineSplitAt [
	"lines"

	<script: 'self new example44deCasteljauLineSplitAt open'>
	| points |
	points := {
		          (0 @ 0).
		          (1 @ 3).
		          (2.5 @ 4).
		          (5 @ 4.5).
		          (4.5 @ 2.5).
		          (6 @ 1) }.

	^ (RSdeCasteljauLine new
		   samplesLinspace: 50;
		   controlPoints: points;
		   scale: 100)
		  splitAt: 1 / 4
		  in: [ :leftSpline :rightSpline :bspline |
			  RSCanvas new
				  addAll: (bspline asGroupWithControlNetColoured: Color gray);
				  addAll: (leftSpline asGroupWithControlNetColoured: Color red);
				  addAll: (rightSpline asGroupWithControlNetColoured: Color blue);
				  zoomToFit;
				  addInteraction: RSCanvasController new;
				  yourself ]
]

{ #category : 'examples' }
RSdeCasteljauExamples >> example44deCasteljauRationalLineClosedControlPoints [
	"lines"

	<script:
	'self new example44deCasteljauRationalLineClosedControlPoints open'>
	| points bezier |
	points := {
		          (0 @ 0).
		          (1 / 2 @ 2).
		          (3 @ 2).
		          (3 / 2 @ 1) }.

	bezier := RSdeCasteljauLine new
		          samplesLinspace: 50;
		          controlPoints: points;
		          scale: 100.

	^ RSCanvas new
		  addAll:
			  ((bezier weighted: #( 1 1 0 1 )) asGroupWithControlNetColoured:
					   Color red);
		  addAll:
			  ((bezier weighted: #( 1 1 0.5 1 ))
				   asGroupWithControlNetColoured: Color blue);
		  addAll:
			  ((bezier weighted: #( 1 1 1 1 )) asGroupWithControlNetColoured:
					   Color brown);
		  addAll:
			  ((bezier weighted: #( 1 1 2 1 )) asGroupWithControlNetColoured:
					   Color magenta);
		  addAll:
			  ((bezier weighted: #( 1 1 5 1 )) asGroupWithControlNetColoured:
					   Color pink);
		  addAll:
			  ((bezier weighted: #( 1 1 10 1 )) asGroupWithControlNetColoured:
					   Color orange);
		  zoomToFit;
		  addInteraction: RSCanvasController new;
		  yourself
]

{ #category : 'examples' }
RSdeCasteljauExamples >> example46NoteInteger [
	"lines"

	<script: 'self new example46NoteInteger open'>
	^ RSCanvas new
		  add: self noteInteger;
		  zoomToFit;
		  addInteraction: RSCanvasController new;
		  yourself
]

{ #category : 'examples' }
RSdeCasteljauExamples >> example46NoteLoremIpsum [
	"lines"

	<script: 'self new example46NoteLoremIpsum open'>
	^ RSCanvas new
		  add: self noteLoremIpsum;
		  zoomToFit;
		  addInteraction: RSCanvasController new;
		  yourself
]

{ #category : 'shapes' }
RSdeCasteljauExamples >> lineDeCasteljauLineClosedControlPoints [
	"lines"

	| points |
	points := {
		          (1 @ 1).
		          (3 @ 4).
		          (5 @ 6).
		          (7 @ 8).
		          (10 @ 2).
		          (1 @ 1) }.

	^ RSdeCasteljauLine new
		  samplesLinspace: 100;
		  controlPoints: points;
		  scale: 100
]

{ #category : 'shapes' }
RSdeCasteljauExamples >> lineDeCasteljauLineNoteBox [
	"lines"

	^ RSdeCasteljauLine new
		  samplesLinspace: 10;
		  controlPoints: {
				  (0 @ 0).
				  (8.461 @ 36.411).
				  (0.6 @ 129.887).
				  (25.3 @ 195.304).
				  (-67.3 @ 222.719).
				  (16.72 @ 245.576).
				  (-55.8 @ 178.406).
				  (60 @ 136.3).
				  (136 @ 136).
				  (142.2 @ 222.332).
				  (393.292 @ 192.739).
				  (247.8 @ 244.8).
				  (179.5 @ 201.105).
				  (221.9 @ 163.04).
				  (200 @ 125.8).
				  (204.4 @ 101.697).
				  (210.405 @ 85.124).
				  (217.89 @ 18.03).
				  (151.73 @ 29.54).
				  (244.5 @ -26.58).
				  (318.633 @ -42.131).
				  (145.27 @ 1.9).
				  (52.05 @ 8.718).
				  (0 @ 0) };
		  yourself
]

{ #category : 'shapes' }
RSdeCasteljauExamples >> linesDeCasteljauLineDegreeElevation [
	"lines"

	| points bspline1 bspline2 bspline3 bspline4 |
	points := {
		          (1 @ 1).
		          (3 @ 4).
		          (5 @ 6).
		          (7 @ (3 / 2)).
		          (10 @ 2) }.

	bspline1 := RSdeCasteljauLine new
		            controlPoints: points;
		            scale: 100.

	bspline2 := bspline1 increment.
	bspline3 := bspline2 increment.
	bspline4 := bspline3 increment.

	^ RSGroup
		  with: bspline1
		  with: bspline2
		  with: bspline3
		  with: bspline4
]

{ #category : 'shapes' }
RSdeCasteljauExamples >> noteInteger [
	"lines"

	^ RSLabel new
		  model: Number firstCarmichaelNumber;
		  useDefaultCodeFont;
		  notedWithPad: Float goldenPlatinumRatio
]

{ #category : 'shapes' }
RSdeCasteljauExamples >> noteLoremIpsum [
	"lines"

	^ RSLabel new
		  text: (String loremIpsum: 50);
		  useDefaultCodeFont;
		  padded: Float goldenPlatinumRatio
		  withNoteDo: [ :aBox | aBox color: Color yellow translucent ]
]
