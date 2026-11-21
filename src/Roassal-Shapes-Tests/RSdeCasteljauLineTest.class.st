"
I test RSdeCasteljauLine, whose points come from the de Casteljau scheme of the UtilsPlugin (UtilsPlugin class>>#deCasteljau:into:at:), or from its Smalltalk twin on a VM without the plugin.
"
Class {
	#name : 'RSdeCasteljauLineTest',
	#superclass : 'TestCase',
	#instVars : [
		'pluginHiddenBefore'
	],
	#category : 'Roassal-Shapes-Tests',
	#package : 'Roassal-Shapes-Tests'
}

{ #category : 'accessing' }
RSdeCasteljauLineTest >> controlPoints [

	^ {
		  (1 @ 1).
		  (3 @ 4).
		  (5 @ 6).
		  (7 @ (3 / 2)).
		  (10 @ 2) } collect: [ :each | each * 100 ]
]

{ #category : 'accessing' }
RSdeCasteljauLineTest >> lines [
	"Fresh lines of each kind of parameterization"

	^ {
		  (RSdeCasteljauLine new
			   samplesLinspace: 50;
			   controlPoints: self controlPoints;
			   yourself).
		  (RSdeCasteljauLine new
			   samplesChebyshev: 33;
			   controlPoints: self controlPoints;
			   yourself).
		  (RSdeCasteljauLine new
			   controlPoints: self controlPoints;
			   arcLengthParameterization;
			   yourself).
		  ((RSdeCasteljauLine new
			    samplesLinspace: 20;
			    controlPoints: self controlPoints;
			    yourself) weighted: #( 1 2 3 2 1 )).
		  (RSdeCasteljauRawLine new
			   samplesLinspace: 20;
			   controlPoints: self controlPoints;
			   yourself) }
]

{ #category : 'running' }
RSdeCasteljauLineTest >> setUp [

	super setUp.
	pluginHiddenBefore := UtilsPlugin pluginHidden
]

{ #category : 'running' }
RSdeCasteljauLineTest >> tearDown [

	UtilsPlugin pluginHidden: pluginHiddenBefore.
	super tearDown
]

{ #category : 'tests' }
RSdeCasteljauLineTest >> testArcLengths [

	| line points length |
	line := RSdeCasteljauLine new
		        samplesLinspace: 40;
		        controlPoints: self controlPoints;
		        yourself.
	points := line controlPoints.
	length := 0.0.
	points overlappingPairsDo: [ :a :b | length := length + (a distanceTo: b) ].
	self assert: line parameterization arcLength equals: length
]

{ #category : 'tests' }
RSdeCasteljauLineTest >> testCurveOfTheSchemeInSmalltalk [
	"The points of the UtilsPlugin are those of #deCasteljau:at:, but for the roundings"

	| line |
	line := RSdeCasteljauLine new
		        samplesChebyshev: 33;
		        controlPoints: self controlPoints;
		        yourself.
	line parameterization domain with: line controlPoints do: [ :t :point |
		| expected |
		expected := line controlPointsAt: t.
		self
			assert: (point x - expected x) abs < 1.0e-9;
			assert: (point y - expected y) abs < 1.0e-9 ]
]

{ #category : 'tests' }
RSdeCasteljauLineTest >> testDerivativeScaleOfAMovedLine [
	"A derivative line keeps its own translation: scaling the line scales the translation too. The number of samples grows with the control polygon, so the curves are compared at the same parameters"

	| derivative scaled |
	derivative := (RSdeCasteljauLine new
		               samplesLinspace: 20;
		               controlPoints: self controlPoints;
		               yourself) derivative.
	derivative translateBy: 30 @ -40.
	scaled := derivative scale: 2.
	(0 to: 1 by: 1 / 10) do: [ :t |
		self assert:
			((scaled controlPointsAt: t) distanceTo:
				 (derivative controlPointsAt: t) * 2) < 1.0e-6 ]
]

{ #category : 'tests' }
RSdeCasteljauLineTest >> testEndPoints [

	self lines do: [ :line |
		self
			assert: line controlPoints size equals: line parameterization size;
			assert: (line controlPoints allSatisfy: [ :each | each isPoint and: [ each x isFloat and: [ each y isFloat ] ] ]);
			assert: (line controlPoints first distanceTo: self controlPoints first) < 1.0e-9;
			assert: (line controlPoints last distanceTo: self controlPoints last) < 1.0e-9 ]
]

{ #category : 'tests' }
RSdeCasteljauLineTest >> testPlainScheme [

	self
		assert: RSdeCasteljauLine new hasPlainScheme;
		assert: RSdeCasteljauWeightedLine new hasPlainScheme;
		deny: RSdeCasteljauRawLine new hasPlainScheme;
		deny: RSdeCasteljauPolynomialLine new hasPlainScheme;
		deny: RSdeCasteljauDerivativeLine new hasPlainScheme;
		deny: RSdeCasteljauPolarLine new hasPlainScheme;
		deny: RSdeCasteljauRationalLine new hasPlainScheme;
		deny: RSdeCasteljauRationalWoznyChudyLine new hasPlainScheme;
		deny: RSdeCasteljauRationalWoznyChudyStableLine new hasPlainScheme
]

{ #category : 'tests' }
RSdeCasteljauLineTest >> testPluginAndSmalltalkAgree [
	"The same points, bit for bit, with the UtilsPlugin and without it"

	| withPlugin withoutPlugin |
	UtilsPlugin pluginHidden: false.
	withPlugin := self lines collect: [ :each | each controlPoints ].
	UtilsPlugin pluginHidden: true.
	withoutPlugin := self lines collect: [ :each | each controlPoints ].
	self assert: withPlugin equals: withoutPlugin
]

{ #category : 'tests' }
RSdeCasteljauLineTest >> testRefreshAfterNewControlPoints [

	| line |
	line := RSdeCasteljauLine new
		        samplesLinspace: 10;
		        controlPoints: self controlPoints;
		        yourself.
	line controlPoints: { 0 @ 0. 100 @ 0 }.
	self
		assert: line controlPoints first equals: 0.0 @ 0.0;
		assert: line controlPoints last equals: 100.0 @ 0.0;
		assert: (line controlPoints allSatisfy: [ :each | each y = 0.0 and: [ each x between: 0.0 and: 100.0 ] ])
]

{ #category : 'tests' }
RSdeCasteljauLineTest >> testWeightsChangeTheCurve [

	| plain weighted |
	plain := RSdeCasteljauLine new
		         samplesLinspace: 20;
		         controlPoints: self controlPoints;
		         yourself.
	weighted := plain weighted: #( 1 2 3 2 1 ).
	self deny: weighted controlPoints equals: plain controlPoints.
	self
		assert: (weighted controlPoints first distanceTo: plain controlPoints first) < 1.0e-9;
		assert: (weighted controlPoints last distanceTo: plain controlPoints last) < 1.0e-9
]
