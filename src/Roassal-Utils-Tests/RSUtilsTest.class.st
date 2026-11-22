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
RSUtilsTest >> testAsStringaz [

	self
		assert: ((0 to: 104) collect: [ :each | each asStringaz ])
		equals:
			#( 'q' 'r' 's' 't' 'u' 'v' 'w' 'x' 'y' 'z' 'a' 'b' 'c' 'd' 'e' 'f'
			   'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'rq' 'rr' 'rs' 'rt' 'ru'
			   'rv' 'rw' 'rx' 'ry' 'rz' 'ra' 'rb' 'rc' 'rd' 're' 'rf' 'rg' 'rh'
			   'ri' 'rj' 'rk' 'rl' 'rm' 'rn' 'ro' 'rp' 'sq' 'sr' 'ss' 'st' 'su'
			   'sv' 'sw' 'sx' 'sy' 'sz' 'sa' 'sb' 'sc' 'sd' 'se' 'sf' 'sg' 'sh'
			   'si' 'sj' 'sk' 'sl' 'sm' 'sn' 'so' 'sp' 'tq' 'tr' 'ts' 'tt' 'tu'
			   'tv' 'tw' 'tx' 'ty' 'tz' 'ta' 'tb' 'tc' 'td' 'te' 'tf' 'tg' 'th'
			   'ti' 'tj' 'tk' 'tl' 'tm' 'tn' 'to' 'tp' 'uq' ).

	"Ensure #asStringaz is a bijection: for the sake of clarity,
	 to each integer corresponds an unique az representation."
	10000 in: [ :n | 
		self
			assert:
			((1 to: n) collect: [ :each | each asStringaz ] as: Set) size
			equals: n ]
]

{ #category : 'tests' }
RSUtilsTest >> testAsStringScaledUptoHours [
	"The first unit, from hours down to nanoseconds, that the duration is at least one of"

	self
		assert: 9 milliSeconds asStringScaledUptoHours equals: '9.0 millisec';
		assert: 90 minutes asStringScaledUptoHours equals: '1.5 hour';
		assert: 2 seconds asStringScaledUptoHours equals: '2.0 sec';
		assert: (Duration seconds: 0 nanoSeconds: 1500) asStringScaledUptoHours equals: '1.5 microsec';
		assert: (Duration seconds: 0 nanoSeconds: 7) asStringScaledUptoHours equals: '7.0 nanosec';
		assert: Duration zero asStringScaledUptoHours equals: '0.0 nanosec';
		assert: (String streamContents: [ :aStream | 3 hours printScaledUptoHoursOn: aStream ]) equals: '3.0 hour'
]

{ #category : 'tests' }
RSUtilsTest >> testAtInOrderedCollectionAdd [

	| dictionary |
	dictionary := Dictionary new.
	self
		assert: (dictionary at: #a inOrderedCollectionAdd: 1) equals: (OrderedCollection with: 1);
		assert: (dictionary at: #a inOrderedCollectionAdd: 2) equals: (OrderedCollection with: 1 with: 2);
		assert: (dictionary at: #b inOrderedCollectionAdd: 3) equals: (OrderedCollection with: 3);
		assert: dictionary size equals: 2;
		assert: (dictionary at: #a) identicalTo: (dictionary at: #a inOrderedCollectionAdd: 4);
		assert: (dictionary at: #a) asArray equals: #( 1 2 4 )
]

{ #category : 'tests' }
RSUtilsTest >> testAtUpdate [
	"Any collection with at: and at:put:, not only a Dictionary"

	| array ordered |
	array := Array with: 1 with: 2.
	self
		assert: (array at: 2 update: [ :each | each * 10 ]) equals: 20;
		assert: array equals: #( 1 20 ).
	ordered := OrderedCollection with: 3 with: 4.
	ordered at: 1 update: [ :each | each max: 5 ].
	self assert: ordered asArray equals: #( 5 4 ).
	self should: [ array at: 3 update: [ :each | each ] ] raise: SubscriptOutOfBounds
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
	"beta weighs the previous average, 1 - beta my element, and each average is divided by 1 - (beta ** index), the bias correction of the initial 0"

	self
		assert: (#( 1.2 2.3 4.5 5.6 ) exponentiallyWeighted: 0.9 init: 0)
		equals: #( 1.2 1.7789473684210526 2.783025830258303 3.602151788310556 );
		assert: (#( 1.2 2.3 4.5 5.6 ) exponentiallyWeighted: 0.9)
		equals: (#( 1.2 2.3 4.5 5.6 ) exponentiallyWeighted: 0.9 init: 0);
		assert: (#( 4 8 0 ) exponentiallyWeighted: 1 / 2)
		equals: { 4. 20 / 3. 20 / 7 };
		assert: (#( 4 8 0 ) exponentiallyWeighted: 0) equals: #( 4 8 0 );
		assert: (#( 5 5 5 ) exponentiallyWeighted: 1 / 3) equals: #( 5 5 5 );
		assert: (#(  ) exponentiallyWeighted: 1 / 2) equals: #(  );
		assert: ({ 0 @ 0. 2 @ 4 } exponentiallyWeighted: 1 / 2)
		equals: { 0 @ 0. (4 / 3) @ (8 / 3) }
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
RSUtilsTest >> testGreatestCommonIndex [
	"The length of the longest common prefix, comparing the elements by identity"

	| a b |
	a := 'a' copy.
	b := 'b' copy.
	self
		assert: (#( 1 2 3 ) greatestCommonIndex: #( 1 2 4 )) equals: 2;
		assert: (#( 1 2 ) greatestCommonIndex: #( 1 2 3 )) equals: 2;
		assert: (#( 1 2 3 ) greatestCommonIndex: #( 1 2 3 )) equals: 3;
		assert: (#( 1 2 3 ) greatestCommonIndex: #( 4 2 3 )) equals: 0;
		assert: (#(  ) greatestCommonIndex: #( 1 )) equals: 0;
		assert: ({ a. b } greatestCommonIndex: (OrderedCollection with: a with: b)) equals: 2;
		assert: ({ a. b } greatestCommonIndex: { a copy. b }) equals: 0
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
RSUtilsTest >> testIfAbsentPutOrderAt [
	"Each new key gets the index of its insertion"

	| dictionary |
	dictionary := IdentityDictionary new.
	self
		assert: (dictionary ifAbsentPutOrderAt: #x) equals: 1;
		assert: (dictionary ifAbsentPutOrderAt: #y) equals: 2;
		assert: (dictionary ifAbsentPutOrderAt: #x) equals: 1;
		assert: (dictionary ifAbsentPutOrderAt: #z) equals: 3;
		assert: dictionary size equals: 3
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
RSUtilsTest >> testScan [
	"The partial folds, with or without the initial value"

	self
		assert: (#( 1 2 3 ) scan: [ :acc :each | acc + each ] init: 0) equals: #( 0 1 3 6 );
		assert: (#( 1 2 3 ) scan: [ :acc :each | acc + each ] init: 0 included: false) equals: #( 1 3 6 );
		assert: (#( 1 2 3 ) scan: [ :acc :each | acc + each ] withoutInit: 0) equals: #( 1 3 6 );
		assert: (#( 2 3 ) scan: [ :acc :each | acc * each ] init: 1) equals: #( 1 2 6 );
		assert: (#(  ) scan: [ :acc :each | acc + each ] init: 0) equals: #( 0 );
		assert: ((OrderedCollection withAll: #( 1 1 )) scan: [ :acc :each | acc + each ] init: 0) asArray equals: #( 0 1 2 )
]

{ #category : 'tests' }
RSUtilsTest >> testUnitAt [

	self
		assert: ((10 to: 20) unitAt: 15) equals: 1 / 2;
		assert: ((10 to: 20) unitAt: 5) equals: 0;
		assert: ((10 to: 20) unitAt: 25) equals: 1
]
