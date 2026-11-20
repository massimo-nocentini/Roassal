"
I provide some parametric lines.
"
Trait {
	#name : 'RSTParametricXYLines',
	#category : 'Roassal-Examples-Experimental',
	#package : 'Roassal-Examples',
	#tag : 'Experimental'
}

{ #category : 'lines' }
RSTParametricXYLines >> lineParametricHypotrochoid [
	"lines"

	| s r d a b |
	s := 5.
	r := 3.
	d := 5.

	a := s - r.
	b := a / r.

	^ RSParametricXYLine new
		  parameterization: (RSLinspaceParameterization new
				   from: -10 to: 10 samples: 10000;
				   yourself);
		  x: [ :t | a * t cos + (d * (b * t) cos) ]
		  y: [ :t | a * t sin - (d * (b * t) sin) ];
		  scale: 10
]

{ #category : 'lines' }
RSTParametricXYLines >> lineParametricLissajous [
	"lines"

	^ RSParametricXYLine new
		  parameterization: (RSLinspaceParameterization new
				   from: 0 to: Float pi * 2 samples: 1000;
				   yourself);
		  x: [ :t | (3 * t) cos ] y: [ :t | (2 * t) sin ];
		  scale: 100
]

{ #category : 'lines' }
RSTParametricXYLines >> lineParametricNeil [
	"lines"

	^ RSParametricXYLine new
		  parameterization: (RSLinspaceParameterization new
				   from: -2 to: 2 samples: 100;
				   yourself);
		  x: [ :t | t raisedTo: 2 ] y: [ :t | t raisedTo: 3 ];
		  scale: 10
]

{ #category : 'lines' }
RSTParametricXYLines >> lineParametricNeil2 [
	"lines"

	^ RSParametricXYLine new
		  parameterization: (RSLinspaceParameterization new
				   from: -2 to: 2 samples: 100;
				   yourself);
		  x: [ :t | t raisedTo: 2 ] y: [ :t | (t raisedTo: 3) - t ];
		  scale: 10
]

{ #category : 'lines' }
RSTParametricXYLines >> lineParametricTrochoid [
	"lines"

	^ RSParametricXYLine new
		  parameterization: (RSLinspaceParameterization new
				   from: 0 to: Float pi samples: 100;
				   yourself);
		  x: [ :t | t cos * (3 * t) cos ] y: [ :t | t sin * (3 * t) cos ];
		  scale: 100
]

{ #category : 'lines' }
RSTParametricXYLines >> lineParametricUnitCircle [
	"lines"

	^ RSParametricXYLine new
		  parameterization: (RSLinspaceParameterization new
				   from: 0 to: Float pi * 2 samples: 100;
				   yourself);
		  x: [ :t | t cos ] y: [ :t | t sin ];
		  scale: 100
]

{ #category : 'lines' }
RSTParametricXYLines >> parametricXYlineButterfly [
	"lines"

	^ RSParametricXYLine new
		  parameterization: (RSLinspaceParameterization new
				   from: 0 to: Float pi * 12 samples: 10000;
				   yourself);
		  x: [ :t |
			  t sin
			  * (t cos exp - (2 * (4 * t) cos) - ((t / 12) sin raisedTo: 5)) ]
		  y: [ :t |
			  t cos
			  * (t cos exp - (2 * (4 * t) cos) - ((t / 12) sin raisedTo: 5)) ];
		  scale: 30
]
