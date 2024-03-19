Extension { #name : 'Integer' }

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
