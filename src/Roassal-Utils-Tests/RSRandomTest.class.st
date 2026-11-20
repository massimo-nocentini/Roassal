"
I test the random variables of Roassal-Utils (RSRandom and its subclasses): seeded determinism, the same samples with and without the UtilsPlugin, and the mean and the variance of many samples (with a fixed seed, so the checks are deterministic).
"
Class {
	#name : 'RSRandomTest',
	#superclass : 'TestCase',
	#instVars : [
		'pluginHiddenBefore'
	],
	#category : 'Roassal-Utils-Tests',
	#package : 'Roassal-Utils-Tests'
}

{ #category : 'accessing' }
RSRandomTest >> distributions [
	"Fresh instances of every random variable, seeded"

	^ {
		  (RandomBernoulli seed: 7) p: 0.3; yourself.
		  (RandomBinomial seed: 7) p: 0.3; n: 10; yourself.
		  RandomBoxMullerBivariateGaussian seed: 7.
		  (RandomExponential seed: 7) lambda: 2.0; yourself.
		  (RandomGaussian seed: 7) mu: 1.0; sigma: 2.0; yourself.
		  (RandomGeometric seed: 7) p: 0.25; yourself.
		  (RandomInteger seed: 7) atLeast: 1; atMost: 6; yourself }
]

{ #category : 'asserting' }
RSRandomTest >> assertSamplesOf: aRandom count: n mean: mean variance: variance tolerance: aFraction [

	| samples sampleMean sampleVariance |
	samples := (1 to: n) collect: [ :i | aRandom next ].
	sampleMean := (samples inject: 0 into: [ :sum :each | sum + each ]) / n.
	sampleVariance := (samples inject: 0 into: [ :sum :each | sum + (each - sampleMean) squared ]) / (n - 1).
	self
		assert: (sampleMean - mean) abs <= (aFraction * (mean abs max: variance sqrt))
		description: aRandom class name , ': mean ' , sampleMean printString , ' instead of ' , mean printString.
	self
		assert: (sampleVariance - variance) abs <= (aFraction * 2 * variance)
		description: aRandom class name , ': variance ' , sampleVariance printString , ' instead of ' , variance printString.
	^ samples
]

{ #category : 'running' }
RSRandomTest >> setUp [

	super setUp.
	pluginHiddenBefore := UtilsPlugin pluginHidden
]

{ #category : 'running' }
RSRandomTest >> tearDown [

	UtilsPlugin pluginHidden: pluginHiddenBefore.
	super tearDown
]

{ #category : 'tests' }
RSRandomTest >> testBernoulli [

	| coin samples |
	coin := (RandomBernoulli seed: 42) p: 0.3; yourself.
	samples := self assertSamplesOf: coin count: 20000 mean: 0.3 variance: 0.21 tolerance: 0.05.
	self assert: (samples asSet difference: #( 0 1 )) isEmpty.
	self
		assert: (coin cdf: -0.5) equals: 0.0;
		assert: (coin cdf: 0.5) closeTo: 0.7;
		assert: (coin cdf: 1) equals: 1.0;
		assert: (coin density: 1) closeTo: 0.3;
		assert: (coin density: 0) closeTo: 0.7.
	self
		assert: ((RandomBernoulli new p: 2; yourself) p) equals: 1.0;
		assert: ((RandomBernoulli new p: -1; yourself) p) equals: 0.0;
		assert: (((RandomBernoulli seed: 1) p: 0; yourself) next: 100) asSet asArray equals: #( 0 );
		assert: (((RandomBernoulli seed: 1) p: 1; yourself) next: 100) asSet asArray equals: #( 1 ).
	self
		assert: ((1 to: 100) collect: [ :i | coin ifHead: [ #head ] ifTail: [ #tail ] ]) asSet
		equals: #( #head #tail ) asSet
]

{ #category : 'tests' }
RSRandomTest >> testBinomial [

	| binomial samples |
	binomial := (RandomBinomial seed: 42) p: 0.3; n: 10; yourself.
	samples := self assertSamplesOf: binomial count: 10000 mean: 3 variance: 2.1 tolerance: 0.05.
	self assert: (samples allSatisfy: [ :each | each between: 0 and: 10 ]).
	self
		assert: (binomial cdf: -1) equals: 0.0;
		assert: (binomial cdf: 0) closeTo: 0.7 ** 10;
		assert: (binomial cdf: 10) closeTo: 1.0;
		assert: (binomial cdf: 3) closeTo: ((0 to: 3) inject: 0 into: [ :sum :k | sum + ((10 choose: k) * (0.3 ** k) * (0.7 ** (10 - k))) ])
]

{ #category : 'tests' }
RSRandomTest >> testBoxMuller [

	| gaussian points xs ys |
	gaussian := RandomBoxMullerBivariateGaussian seed: 42.
	points := (1 to: 10000) collect: [ :i | gaussian next ].
	self assert: (points allSatisfy: [ :each | each isPoint and: [ each x isFinite and: [ each y isFinite ] ] ]).
	xs := points collect: [ :each | each x ].
	ys := points collect: [ :each | each y ].
	{ xs. ys } do: [ :samples |
		| mean variance |
		mean := samples average.
		variance := (samples inject: 0 into: [ :sum :each | sum + (each - mean) squared ]) / (samples size - 1).
		self
			assert: mean abs < 0.05;
			assert: (variance - 1) abs < 0.05 ]
]

{ #category : 'tests' }
RSRandomTest >> testCdfIfLessThanElse [

	| coin heads |
	coin := (RandomBernoulli seed: 42) p: 0.3; yourself.
	heads := ((1 to: 10000) select: [ :i | coin cdf: 0.5 ifLessThan: [ true ] else: [ false ] ]) size.
	"cdf: 0.5 is 0.7"
	self assert: (heads / 10000 - 0.7) abs < 0.02.
	self assert: (coin cdf: 0.5 ifLessThan: [ :x | x ] else: [ :x | x ]) equals: 0.5
]

{ #category : 'tests' }
RSRandomTest >> testExponential [

	| exponential samples |
	exponential := (RandomExponential seed: 42) lambda: 2.0; yourself.
	samples := self assertSamplesOf: exponential count: 20000 mean: 0.5 variance: 0.25 tolerance: 0.05.
	self assert: (samples allSatisfy: [ :each | each >= 0 ]).
	self
		assert: (exponential cdf: -1) equals: 0.0;
		assert: (exponential cdf: 0) equals: 0.0;
		assert: (exponential cdf: 1) closeTo: 1 - -2.0 exp.
	"the empirical distribution function"
	self assert: ((samples count: [ :each | each <= 0.5 ]) / samples size - (exponential cdf: 0.5)) abs < 0.02
]

{ #category : 'tests' }
RSRandomTest >> testGaussian [

	| gaussian samples |
	gaussian := (RandomGaussian seed: 42) mu: 1.0; sigma: 2.0; yourself.
	samples := self assertSamplesOf: gaussian count: 20000 mean: 1.0 variance: 4.0 tolerance: 0.05.
	"about 68.3% of the samples are within one sigma of the mean"
	self assert: ((samples count: [ :each | (each - 1.0) abs <= 2.0 ]) / samples size - 0.6827) abs < 0.02.
	"symmetric"
	self assert: ((samples count: [ :each | each < 1.0 ]) / samples size - 0.5) abs < 0.02
]

{ #category : 'tests' }
RSRandomTest >> testGeometric [

	| geometric samples |
	geometric := (RandomGeometric seed: 42) p: 0.25; yourself.
	samples := self assertSamplesOf: geometric count: 20000 mean: 4 variance: 12 tolerance: 0.05.
	self assert: (samples allSatisfy: [ :each | each isInteger and: [ each >= 1 ] ]).
	self
		assert: (geometric cdf: 0.5) equals: 0.0;
		assert: (geometric cdf: 1) closeTo: 0.25;
		assert: (geometric cdf: 2) closeTo: 1 - (0.75 ** 2);
		assert: (geometric density: 2) closeTo: 0.75 * 0.25.
	self assert: ((samples count: [ :each | each = 1 ]) / samples size - 0.25) abs < 0.02
]

{ #category : 'tests' }
RSRandomTest >> testInteger [

	| dice samples |
	dice := (RandomInteger seed: 42) atLeast: 1; atMost: 6; yourself.
	samples := self assertSamplesOf: dice count: 12000 mean: 3.5 variance: 35 / 12 tolerance: 0.05.
	self assert: samples asSet equals: (1 to: 6) asSet.
	(1 to: 6) do: [ :face | self assert: ((samples count: [ :each | each = face ]) / 2000 - 1) abs < 0.1 ].
	self assert: ((RandomInteger seed: 1) next: 10) size equals: 10
]

{ #category : 'tests' }
RSRandomTest >> testKnuthState [

	| random |
	random := RSRandom seed: 310952.
	self
		assert: random shortLagArray size equals: 100;
		assert: random longLagArray size equals: 1009;
		assert: (random shortLagArray allSatisfy: [ :each | each >= 0.0 and: [ each < 1.0 ] ]).
	"the buffer is filled at the first fraction, and ended by -1"
	random nextUniform.
	self
		assert: (random longLagArray at: 101) equals: -1.0;
		assert: ((random longLagArray first: 100) allSatisfy: [ :each | each >= 0.0 and: [ each < 1.0 ] ])
]

{ #category : 'tests' }
RSRandomTest >> testPluginAndSmalltalkAgree [
	"The same samples with the UtilsPlugin and with its Smalltalk twin (the same samples twice without the plugin)"

	| withPlugin withoutPlugin |
	UtilsPlugin pluginHidden: false.
	withPlugin := self distributions collect: [ :each | each next: 200 ].
	UtilsPlugin pluginHidden: true.
	withoutPlugin := self distributions collect: [ :each | each next: 200 ].
	self assert: withPlugin equals: withoutPlugin
]

{ #category : 'tests' }
RSRandomTest >> testSeeded [

	self assert: (self distributions collect: [ :each | each next: 50 ]) equals: (self distributions collect: [ :each | each next: 50 ]).
	self deny: ((RandomGaussian seed: 1) next: 5) equals: ((RandomGaussian seed: 2) next: 5)
]

{ #category : 'tests' }
RSRandomTest >> testUniformProtocol [
	"Random's protocol stays uniform in every distribution: nextInteger:, nextBetween:and:, nextIntegerBetween:and:"

	self distributions do: [ :random |
		| integers floats |
		integers := (1 to: 600) collect: [ :i | random nextInteger: 3 ].
		self assert: integers asSet equals: #( 1 2 3 ) asSet.
		floats := (1 to: 600) collect: [ :i | random nextBetween: 10 and: 20 ].
		self assert: (floats allSatisfy: [ :each | each >= 10 and: [ each < 20 ] ]).
		self assert: ((random nextIntegerBetween: 5 and: 5) = 5) ]
]

{ #category : 'tests' }
RSRandomTest >> testUniformsAreKnuths [
	"The uniform fractions of every distribution are those of KnuthRandom"

	| knuth |
	knuth := (KnuthRandom seed: 310952) next: 10.
	self distributions do: [ :each |
		each seed: 310952.
		self assert: ((1 to: 10) collect: [ :i | each nextUniform ]) equals: knuth ]
]
