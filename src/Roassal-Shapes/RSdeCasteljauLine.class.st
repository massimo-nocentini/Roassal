Class {
	#name : 'RSdeCasteljauLine',
	#superclass : 'RSParametricLine',
	#category : 'Roassal-Shapes-Lines',
	#package : 'Roassal-Shapes',
	#tag : 'Lines'
}

{ #category : 'adding' }
RSdeCasteljauLine >> addBezierPoint: aPoint [
	"draw helpers"

	| firstPoint |
	firstPoint := points nextToLast reflectedAbout: points last.

	self addPoint: aPoint via: firstPoint
]

{ #category : 'adding' }
RSdeCasteljauLine >> addBezierPoint: aPoint via: secondPoint [

	| firstPoint |
	firstPoint := points nextToLast reflectedAbout: points last.

	self addPoint: aPoint via: firstPoint via: secondPoint
]

{ #category : 'adding' }
RSdeCasteljauLine >> addPoint: aPoint [
	"draw helpers"

	points add: aPoint
]

{ #category : 'adding' }
RSdeCasteljauLine >> addPoint: aPoint via: anotherPoint [

	self addPoint: aPoint via: anotherPoint via: anotherPoint
]

{ #category : 'adding' }
RSdeCasteljauLine >> addPoint: aPoint via: firstPoint via: secondPoint [

	points
		add: firstPoint;
		add: secondPoint;
		add: aPoint
]

{ #category : 'adding' }
RSdeCasteljauLine >> addPoint: aPoint via: firstPoint via: secondPoint relativeTo: basePoint [

	self
		addPoint: aPoint + basePoint
		via: firstPoint + basePoint
		via: secondPoint + basePoint
]

{ #category : 'adding' }
RSdeCasteljauLine >> asBeziersGroup [
	"converting"

	^ self asBeziersGroupSplitBlock: [ :aBezier |
		  aBezier overlappingControlPointsDistance > 100
			  ifTrue: [ 1 / 2 ]
			  ifFalse: [ nil ] ]
]

{ #category : 'adding' }
RSdeCasteljauLine >> asBeziersGroupSplitBlock: aBlock [
	"converting"

	^ (self splitWhile: aBlock) collect: [ :each | each asRSBezier ]
]

{ #category : 'adding' }
RSdeCasteljauLine >> asGroupBernsteinBase [
	"converting"

	| n scale |
	n := pointsSize - 1.

	scale := Float goldenRatio * (pointsSize max: 100).

	^ (0 to: n)
		  collect: [ :each |
			  RSParametricXYLine new
				  parameterization: (RSUnaryLinspaceParameterization new
						   from: 0 to: 1 samples: scale ceiling;
						   yourself);
				  x: [ :t | t ] y: [ :t | t bernstein: n choose: each ];
				  scale: scale ]
		  as: RSGroup
]

{ #category : 'adding' }
RSdeCasteljauLine >> asRSBezier [
	"converting"

	^ RSBezier new
		  controlPoints: self designPoints;
		  yourself
]

{ #category : 'adding' }
RSdeCasteljauLine >> controlPoints: aSequenceableOfPoints at: t [

	^ self deCasteljau: aSequenceableOfPoints at: t asFloat
]

{ #category : 'adding' }
RSdeCasteljauLine >> deCasteljau: aSequenceableOfPoints at: t [

	| h u qPoint |
	h := 1.0.
	u := h - t.
	qPoint := aSequenceableOfPoints first.

	1 to: pointsSize - 1 do: [ :k |
		| hPoint i |
		i := k + 1.
		h := self weight: h * t * (pointsSize - k) atIndex: i.
		h := h max: 2.220446049250313e-16.
		h := h / ((self weight: k * u atIndex: k) + h).
		hPoint := h * (aSequenceableOfPoints at: i).
		qPoint := qPoint * (1 - h) + hPoint ].

	^ qPoint
]

{ #category : 'adding' }
RSdeCasteljauLine >> derivative [
	"accessing"

	^ RSdeCasteljauDerivativeLine new
		  parameterization: parameterization;
		  controlPoints: points;
		  yourself
]

{ #category : 'adding' }
RSdeCasteljauLine >> difference [
	"accessing"

	| diffPoints size |
	size := pointsSize - 1.

	diffPoints := Array new: size.

	1 to: size do: [ :i |
		| aPoint |
		aPoint := (points at: i + 1) - (points at: i).
		diffPoints at: i put: aPoint ].

	^ self newLine
		  controlPoints: diffPoints;
		  yourself
]

{ #category : 'adding' }
RSdeCasteljauLine >> elevate: n [
	"instance creation"

	| line |
	line := self.

	n timesRepeat: [ line := line increment ].

	^ line
]

{ #category : 'adding' }
RSdeCasteljauLine >> increment [
	"accessing"

	| incremented sandbox |
	sandbox := Array new: pointsSize + 2.

	sandbox
		replaceFrom: 2
		to: pointsSize + 1
		with: points
		startingAt: 1.

	sandbox
		at: 1 put: 0 @ 0;
		at: pointsSize + 2 put: 0 @ 0.

	incremented := Array new: pointsSize + 1.

	1 to: pointsSize + 1 do: [ :i |
		| t aPoint |
		t := i - 1 / pointsSize.

		aPoint := (sandbox at: i) unitAffine: (sandbox at: i + 1) at: t.

		incremented at: i put: aPoint ].

	^ self newLine
		  controlPoints: incremented;
		  yourself
]

{ #category : 'initialization' }
RSdeCasteljauLine >> initialize [
	"initialization"

	super initialize.

	self samplesLinspace: 2
]

{ #category : 'adding' }
RSdeCasteljauLine >> junction: aLine left: aBlock [

	^ self
		  junction: 1
		  to: 1
		  left: [ :continuityPoint :tangentPoint :obsculatorPoint :a_succ_i |
			  aLine
				  junction: self
				  left: aBlock
				  c0: continuityPoint
				  c1: tangentPoint
				  c2: obsculatorPoint ]
]

{ #category : 'adding' }
RSdeCasteljauLine >> junction: aLine left: aBlock c0: continuityPoint c1: tangentPoint c2: obsculatorPoint [

	| lineC0 lineC1 lineC2 |
	lineC0 := self newLine
		          controlPoints: points , { continuityPoint };
		          yourself.

	lineC1 := self newLine
		          controlPoints: points , {
					          tangentPoint.
					          continuityPoint };
		          yourself.

	lineC2 := self newLine
		          controlPoints: points , {
					          obsculatorPoint.
					          tangentPoint.
					          continuityPoint };
		          yourself.

	^ aBlock value: lineC0 value: lineC1 value: lineC2
]

{ #category : 'adding' }
RSdeCasteljauLine >> junction: aLine right: aBlock [

	^ self
		  junction: 1
		  to: 1
		  right: [ :continuityPoint :tangentPoint :obsculatorPoint :a_succ_i |
			  aLine
				  junction: self
				  right: aBlock
				  c0: continuityPoint
				  c1: tangentPoint
				  c2: obsculatorPoint ]
]

{ #category : 'adding' }
RSdeCasteljauLine >> junction: aLine right: aBlock c0: continuityPoint c1: tangentPoint c2: obsculatorPoint [

	| lineC0 lineC1 lineC2 |
	lineC0 := self newLine
		          controlPoints: { continuityPoint } , points;
		          yourself.

	lineC1 := self newLine
		          controlPoints: {
				          continuityPoint.
				          tangentPoint } , points;
		          yourself.

	lineC2 := self newLine
		          controlPoints: {
				          continuityPoint.
				          tangentPoint.
				          obsculatorPoint } , points;
		          yourself.

	^ aBlock value: lineC0 value: lineC1 value: lineC2
]

{ #category : 'adding' }
RSdeCasteljauLine >> junction: h_i to: h_succ_i left: aBlock [

	| continuityPoint secondControlPoint thirdControlPoint tangentPoint intervalLengthSum obsculatorPoint a_succ_i ratio ratioInverted |
	continuityPoint := points at: 1.
	secondControlPoint := points at: 2.
	thirdControlPoint := points at: 3.

	ratio := h_succ_i / h_i.
	ratioInverted := h_i / h_succ_i.

	intervalLengthSum := h_i + h_succ_i.

	tangentPoint := continuityPoint
	                - (h_i / intervalLengthSum * secondControlPoint)
	                * (intervalLengthSum / h_succ_i).

	obsculatorPoint := tangentPoint * (1 + (h_succ_i / h_i))
	                   - secondControlPoint
	                   -
	                   (h_i / h_succ_i
	                    * (secondControlPoint - thirdControlPoint)).

	obsculatorPoint := ratioInverted * obsculatorPoint.

	a_succ_i := tangentPoint + (ratio * (tangentPoint - obsculatorPoint)).

	^ aBlock
		  value: continuityPoint
		  value: tangentPoint
		  value: obsculatorPoint
		  value: a_succ_i
]

{ #category : 'adding' }
RSdeCasteljauLine >> junction: h_i to: h_succ_i right: aBlock [

	| continuityPoint lastButOneControlPoint lastButTwoControlPoint tangentPoint intervalLengthSum obsculatorPoint a_succ_i ratio ratioInverted offset |
	continuityPoint := points atLast: 1.
	lastButOneControlPoint := points atLast: 2.
	lastButTwoControlPoint := points atLast: 3.

	ratio := h_succ_i / h_i.
	ratioInverted := h_i / h_succ_i.

	offset := ratio * (lastButOneControlPoint - lastButTwoControlPoint).

	intervalLengthSum := h_i + h_succ_i.

	tangentPoint := intervalLengthSum * continuityPoint
	                - (h_succ_i * lastButOneControlPoint) / h_i.

	obsculatorPoint := tangentPoint - lastButOneControlPoint.
	obsculatorPoint := obsculatorPoint - offset.
	obsculatorPoint := obsculatorPoint + (ratioInverted * tangentPoint).
	obsculatorPoint := ratio * obsculatorPoint.

	a_succ_i := tangentPoint
	            + (ratioInverted * (tangentPoint - obsculatorPoint)).

	^ aBlock
		  value: continuityPoint
		  value: tangentPoint
		  value: obsculatorPoint
		  value: a_succ_i
]

{ #category : 'adding' }
RSdeCasteljauLine >> newLine [
	"instance creation"

	^ super newLine
		  parameterization: parameterization copy;
		  yourself
]

{ #category : 'adding' }
RSdeCasteljauLine >> notifyDesignPointsChanged [
	"accessing"

	parameterization
		controlPointsChanged: self designPoints
		overlappingDistancesSum: self overlappingControlPointsDistance
]

{ #category : 'adding' }
RSdeCasteljauLine >> pen: aBlock [
	"draw helpers"

	"Inspired by https://css-tricks.com/svg-path-syntax-illustrated-guide/"

	points := OrderedCollection new.

	aBlock value: self.

	self controlPoints: points
]

{ #category : 'adding' }
RSdeCasteljauLine >> polar: ratio [
	"accessing"

	^ RSdeCasteljauPolarLine new
		  parameterization: parameterization;
		  ratio: ratio;
		  controlPoints: points;
		  yourself
]

{ #category : 'adding' }
RSdeCasteljauLine >> primitiveRefreshDesignPoints: designPoints controlPoints: destControlPoints parameterDomain: domain [

	<primitive: 'primitive_decasteljau' module: 'UtilsPlugin'>
	^ super refreshControlPoints
]

{ #category : 'adding' }
RSdeCasteljauLine >> refreshControlPoints [
	"accessing"

	| paramDomain |
	paramDomain := (parameterization domain ifNil: [ #(  ) ]) collect:
		               #asFloat.

	^ self
		  primitiveRefreshDesignPoints: points
		  controlPoints: controlPoints
		  parameterDomain: paramDomain
]

{ #category : 'adding' }
RSdeCasteljauLine >> samplesChebyshev: n [
	"accessing - structure variables"

	self parameterization: (RSChebyshevParameterization new
			 from: 0 to: 1 samples: n;
			 yourself)
]

{ #category : 'adding' }
RSdeCasteljauLine >> samplesLinspace: n [
	"accessing - structure variables"

	self parameterization: (RSUnaryLinspaceParameterization new
			 from: 0 to: 1 samples: n;
			 yourself)
]

{ #category : 'adding' }
RSdeCasteljauLine >> splitAt: aParam in: aBlock [

	| left right diagonal last t |
	sandboxPoints
		replaceFrom: 1
		to: pointsSize
		with: points
		startingAt: 1.

	diagonal := Array new: pointsSize.
	last := Array new: pointsSize.

	diagonal at: 1 put: sandboxPoints first.
	last at: 1 put: sandboxPoints last.

	t := parameterization unitAt: aParam.

	1 to: pointsSize do: [ :k |
		| delta |
		delta := pointsSize - k.

		1 to: delta do: [ :i |
			| aPoint |
			aPoint := (sandboxPoints at: i)
				          unitAffine: (sandboxPoints at: i + 1)
				          at: 1 - t.

			sandboxPoints at: i put: aPoint ].

		k < pointsSize ifTrue: [
			| kSucc |
			kSucc := k + 1.
			diagonal at: kSucc put: sandboxPoints first.
			last at: kSucc put: (sandboxPoints at: delta) ] ].

	left := self newLine
		        controlPoints: diagonal;
		        yourself.

	right := self newLine
		         controlPoints: last;
		         yourself.

	^ aBlock value: left value: right value: self
]

{ #category : 'adding' }
RSdeCasteljauLine >> splitWhile: aBlock [
	"converting"

	| pool beziers |
	beziers := RSGroup new.

	pool := OrderedCollection with: self.

	[ pool isNotEmpty ] whileTrue: [
		| bezier |
		bezier := pool removeFirst.
		(aBlock value: bezier)
			ifNil: [ beziers add: bezier ]
			ifNotNil: [ :at |
				bezier splitAt: at in: [ :left :right :whole |
					pool
						addFirst: right;
						addFirst: left ] ] ].

	^ beziers
]

{ #category : 'adding' }
RSdeCasteljauLine >> weight: aNumber atIndex: anIndex [

	^ aNumber
]

{ #category : 'adding' }
RSdeCasteljauLine >> weighted: aCollection [
	"accessing"

	^ RSdeCasteljauRationalWoznyChudyLine new
		  parameterization: parameterization;
		  weights: aCollection;
		  controlPoints: points;
		  yourself
]
