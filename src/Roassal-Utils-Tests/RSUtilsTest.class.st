Class {
	#name : 'RSUtilsTest',
	#superclass : 'TestCase',
	#category : 'Roassal-Utils-Tests',
	#package : 'Roassal-Utils-Tests'
}

{ #category : 'tests' }
RSUtilsTest >> testAsCompositeShape [

	| box composite |
	box := RSBox new
		       model: 42;
		       yourself.
	self assert: box asGroup asArray equals: { box }.
	composite := box asCompositeShape.
	self
		assert: composite class equals: RSComposite;
		assert: composite model equals: 42;
		assert: composite children asArray equals: { box }
]

{ #category : 'tests' }
RSUtilsTest >> testBernstein [
	"The Bernstein polynomials of degree n sum to 1 at any t"

	#( 0 0.25 0.5 1 ) do: [ :t |
		self
			assert: ((0 to: 4) inject: 0 into: [ :sum :i | sum + (t bernstein: 4 choose: i) ])
			closeTo: 1 ].
	self assert: (1 / 2 bernstein: 2 choose: 1) equals: 1 / 2
]

{ #category : 'tests' }
RSUtilsTest >> testCarmichaelNumbers [

	{
		Number firstCarmichaelNumber.
		Number secondCarmichaelNumber.
		Number thirdCarmichaelNumber.
		Number fourthCarmichaelNumber.
		Number fifthCarmichaelNumber } do: [ :n |
		self deny: n isPrime.
		"Fermat's little theorem holds for every base coprime with n"
		#( 2 3 5 7 11 13 ) do: [ :a |
			(a gcd: n) = 1 ifTrue: [ self assert: (a raisedTo: n - 1 modulo: n) equals: 1 ] ] ]
]

{ #category : 'tests' }
RSUtilsTest >> testChebyshev [

	| knots |
	knots := (-1 to: 1) chebyshev: 3.
	self
		assert: knots size equals: 3;
		assert: knots first closeTo: (Float pi / 6) cos negated;
		assert: knots second closeTo: 0;
		assert: knots third closeTo: (Float pi / 6) cos.
	knots := (0 to: 10) chebyshevInclusive: 5.
	self
		assert: knots size equals: 5;
		assert: knots first equals: 0;
		assert: knots last equals: 10;
		assert: (knots allSatisfy: [ :each | each between: 0 and: 10 ]);
		assert: (knots asSortedCollection asArray) equals: knots
]

{ #category : 'tests' }
RSUtilsTest >> testChoose [

	self
		assert: (5 choose: 2) equals: 10;
		assert: (5 choose: 0) equals: 1;
		assert: (5 choose: 5) equals: 1;
		assert: (5 choose: 6) equals: 0;
		assert: (5 choose: -1) equals: 0
]

{ #category : 'tests' }
RSUtilsTest >> testExponentiallyWeighted [

	self
		assert: (#( 4 8 0 ) exponentiallyWeighted: 1 / 2) equals: #( 4 6 3 );
		assert: (#( 4 8 0 ) exponentiallyWeighted: 1) equals: #( 4 8 0 );
		assert: (#( 4 8 0 ) exponentiallyWeighted: 0) equals: #( 4 4 4 );
		assert: (#(  ) exponentiallyWeighted: 1 / 2) equals: #(  );
		assert: ({ 0 @ 0. 2 @ 4 } exponentiallyWeighted: 1 / 2) equals: { 0 @ 0. 1 @ 2 }
]

{ #category : 'tests' }
RSUtilsTest >> testGoldenRatios [

	self
		assert: Float goldenRatio equals: 1.618033988749895;
		assert: Float silverRatio equals: 0.6180339887498948;
		assert: Float bronzeRatio equals: 0.3819660112501051;
		assert: Float platinumRatio equals: 2.618033988749895;
		assert: Float goldenPlatinumRatio equals: 4.23606797749979;
		assert: Float π equals: Float pi
]

{ #category : 'tests' }
RSUtilsTest >> testHalvedDoubled [

	self
		assert: 3 halved equals: 3 / 2;
		assert: 3 doubled equals: 6;
		assert: 3 increment equals: 4;
		assert: 3 decrement equals: 2;
		assert: 3.0 halved equals: 1.5;
		assert: 3.0 doubled equals: 6.0;
		assert: 1.5 increment equals: 2.5;
		assert: 1.5 decrement equals: 0.5;
		assert: (3 @ 4) halved equals: (3 / 2) @ 2;
		assert: (3 @ 4) halvedAsFloat equals: 1.5 @ 2.0
]

{ #category : 'tests' }
RSUtilsTest >> testIfZeroIfNotZero [

	self
		assert: (0 ifZero: [ #zero ] ifNotZero: [ :n | n ]) equals: #zero;
		assert: (7 ifZero: [ #zero ] ifNotZero: [ :n | n ]) equals: 7
]

{ #category : 'tests' }
RSUtilsTest >> testLinspace [

	self
		assert: ((0 to: 1) linspace: 5) asArray equals: { 0. 1 / 4. 1 / 2. 3 / 4. 1 };
		assert: ((0 to: 10) linspace: 1) equals: (0 to: 10);
		assert: ((2 to: 4) linspace: 2) asArray equals: #( 2 4 )
]

{ #category : 'tests' }
RSUtilsTest >> testPoints [

	self
		assert: ((1 / 3) @ (2 / 3) asFloatPointRound: 2) equals: 0.33 @ 0.67;
		assert: (3 @ 4) distanceToOrigin equals: 5;
		assert: (3 @ 4) xMinusY equals: -1;
		assert: (3 @ 4) yMinusX equals: 1;
		assert: (0 @ 0 unitAffine: 10 @ 10 at: 1 / 4) equals: (15 / 2) @ (15 / 2);
		assert: (0 @ 0 unitAffine: 10 @ 10 at: 2) equals: 0 @ 0;
		assert: (1 @ 0 unitAffine: 0 @ 1 at: 1 / 2 and: 0 @ 0 at: 1 / 2)
		equals: (1 / 2) @ (1 / 2);
		assert: (1 @ 0) π equals: 0;
		assert: (0 @ 1) π equals: 1 / 2;
		assert: (0 @ -1) π equals: 3 / 2
]

{ #category : 'tests' }
RSUtilsTest >> testRectangleCenteredAtOrigin [

	| rectangle |
	rectangle := Rectangle extentCenteredAtCartesianOrigin: 4 @ 6.
	self
		assert: rectangle origin equals: -2 @ -3;
		assert: rectangle extent equals: 4 @ 6;
		assert: rectangle center equals: 0 @ 0
]

{ #category : 'tests' }
RSUtilsTest >> testUnitAt [

	self
		assert: ((10 to: 20) unitAt: 15) equals: 1 / 2;
		assert: ((10 to: 20) unitAt: 5) equals: 0;
		assert: ((10 to: 20) unitAt: 25) equals: 1
]
