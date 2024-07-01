Class {
	#name : 'RSNote',
	#superclass : 'RSBox',
	#instVars : [
		'polylineShape'
	],
	#classVars : [
		'CoinBlock',
		'DefaultCornerRadius',
		'DefaultEmptyRectangle',
		'GaussianRandom'
	],
	#category : 'Roassal-Shapes-Bounding',
	#package : 'Roassal-Shapes',
	#tag : 'Bounding'
}

{ #category : 'class initialization' }
RSNote class >> initialize [

	| coin |
	DefaultCornerRadius := RSCornerRadius new
		                       radius: 0;
		                       yourself.

	GaussianRandom := RandomGaussian seed: Number firstCarmichaelNumber.

	coin := RandomBernoulli new
		        p: 0.6;
		        yourself.

	CoinBlock := [ :c0 :c1 :c2 | coin ifHead: [ c1 ] ifTail: [ c2 ] ].

	DefaultEmptyRectangle := 0 @ 0 corner: 0 @ 0
]

{ #category : 'accessing' }
RSNote >> baseRectangleAtPoint: aPoint [

	^ super baseRectangleAtPoint: aPoint
	"| rectangle radius n m ratio lPoints rPoints bPoints tPoints |
rectangle := super baseRectangleAtPoint: aPoint.

radius := self hasCornerRadius
	          ifTrue: [ self cornerRadius ]
	          ifFalse: [ DefaultCornerRadius ].

n := rectangle height max: 1.
m := rectangle width max: 1.

n > m
	ifTrue: [
		ratio := n / m.
		m := (m log: 2) ceiling max: 4.
		n := ratio ceiling * m ]
	ifFalse: [
		ratio := m / n.
		n := (n log: 2) ceiling max: 4.
		m := ratio ceiling * n ].

lPoints := ((rectangle top + radius topLeft to:
             rectangle bottom - radius bottomLeft) chebyshev: n)
	           collect: [ :each |
	           rectangle left + GaussianRandom next @ each ].

rPoints := ((rectangle bottom - radius bottomRight to:
             rectangle top + radius topRight) chebyshev: n) collect: [
	           :each | rectangle right + GaussianRandom next @ each ].

bPoints := ((rectangle left + radius bottomLeft to:
             rectangle right - radius bottomRight) chebyshev: m)
	           collect: [ :each |
	           each @ (rectangle bottom + GaussianRandom next) ].

tPoints := ((rectangle right - radius topRight to:
             rectangle left + radius topLeft) chebyshev: m) collect: [
	           :each | each @ (rectangle top + GaussianRandom next) ].

^ {
	  lPoints.
	  rPoints.
	  bPoints.
	  tPoints } inject: DefaultEmptyRectangle into: [ :r :designPoints |
	  r encompass: (Rectangle encompassing: designPoints) extent ]"
]

{ #category : 'visiting' }
RSNote >> buildPathOn: visitor [

	visitor buildNotePath: self
]

{ #category : 'accessing' }
RSNote >> coinBlock [

	^ CoinBlock
]

{ #category : 'accessing' }
RSNote >> defaultCornerRadius [

	^ DefaultCornerRadius 
]

{ #category : 'accessing' }
RSNote >> randomGaussian [

	^ GaussianRandom
]
