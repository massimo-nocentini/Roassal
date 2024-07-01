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
