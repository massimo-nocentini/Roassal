Extension { #name : 'SequenceableCollection' }

{ #category : '*Roassal-Utils' }
SequenceableCollection >> exponentiallyWeighted: beta [

	^ self exponentiallyWeighted: beta init: 0
]

{ #category : '*Roassal-Utils' }
SequenceableCollection >> exponentiallyWeighted: beta init: init [

	"This message collects according to https://en.wikipedia.org/wiki/Moving_average#Exponential_moving_average."

	"(#(1.2 2.3 4.5 5.6) exponentiallyWeighted: 0.9 init: 0) >>> #(1.2 1.7789473684210526 2.783025830258303 3.602151788310556)"

	| betaComplement |
	betaComplement := 1 - beta.
	^ self class new: self size streamContents: [ :aStream | 
		  | w |
		  w := init.
		  self withIndexDo: [ :each :index | 
			  | wCorrected |
			  w := beta * w + (betaComplement * each).
			  wCorrected := w / (1 - (beta ** index)).
			  aStream nextPut: wCorrected ] ]
]

{ #category : '*Roassal-Utils' }
SequenceableCollection >> greatestCommonIndex: aCollection [

	| index stop |
	stop := false.
	index := 1.

	[ stop or: [ index > self size or: [ index > aCollection size ] ] ] 
		whileFalse: [ 
			(self at: index) == (aCollection at: index)
				ifTrue: [ index := index + 1 ]
				ifFalse: [ stop := true ] ].

	^ index - 1
]

{ #category : '*Roassal-Utils' }
SequenceableCollection >> scan: aBlock init: aValue [

	^ self scan: aBlock init: aValue included: true
]

{ #category : '*Roassal-Utils' }
SequenceableCollection >> scan: aBlock init: aValue included: included [

	^ self class
		  new: self size + included asBit
		  streamContents: [ :aStream |
			  | acc |
			  included ifTrue: [ aStream nextPut: aValue ].
			  acc := aValue.
			  self do: [ :each |
				  acc := aBlock value: acc value: each.
				  aStream nextPut: acc ] ]
]

{ #category : '*Roassal-Utils' }
SequenceableCollection >> scan: aBlock withoutInit: aValue [

	^ self scan: aBlock init: aValue included: false
]
