Extension { #name : 'Integer' }

{ #category : '*Roassal-Utils' }
Integer >> asStringaz [

	^ self positive
		  ifTrue: [ 
			  | repr skipInterval upperCasesInterval |
			  repr := self printStringBase: 26.

			  skipInterval := $0 asInteger to: $9 asInteger.
			  upperCasesInterval := $A asInteger to: $Z asInteger.

			  String streamContents: [ :aStream | 
				  repr do: [ :each | 
					  | i |
					  i := each asInteger.

					  i := (skipInterval includes: i)
						       ifTrue: [ i - skipInterval first + $q asInteger ]
						       ifFalse: [ 
							       (upperCasesInterval includes: i)
								       ifTrue: [ i - upperCasesInterval first + $a asInteger ]
								       ifFalse: [ i ] ].

					  aStream nextPut: i asCharacter ] ] ]
		  ifFalse: [ Error signal ]
]

{ #category : '*Roassal-Utils' }
Integer >> choose: k [

	^ (k positive and: [ self >= k ])
		  ifTrue: [ self factorial / (k factorial * (self - k) factorial) ]
		  ifFalse: [ 0 ]
]

{ #category : '*Roassal-Utils' }
Integer >> ifZero: zBlock ifNotZero: nzBlock [

	^ self isZero 
		  ifTrue: [ zBlock cull: self ]
		  ifFalse: [ nzBlock cull: self ]
]
