Extension { #name : 'Duration' }

{ #category : '*Roassal-Utils' }
Duration >> asStringScaledUptoHours [

	^ String streamContents: [ :aStream | 
		  self printScaledUptoHoursOn: aStream ]
]

{ #category : '*Roassal-Utils' }
Duration >> printOn: aStream scales: scales withRespectTo: aBlock [

	"The first of scales, associations from a number of nanoseconds to a unit name, from the largest, that I am at least one of (the last one otherwise)"

	| base i scale |
	base := self asNanoSeconds.

	i := 1.
	[ i <= scales size and: [ (base quo: (scales at: i) key) isZero ] ]
		whileTrue: [ i := i + 1 ].

	i := i min: scales size.
	scale := scales at: i.

	aStream
		nextPutAll: (base / scale key) asFloat asString;
		nextPutAll: ' ';
		nextPutAll: scale value
]

{ #category : '*Roassal-Utils' }
Duration >> printScaledUptoHoursOn: aStream [

	self
		printOn: aStream
		scales: { 
				(3600e9 -> 'hour').
				(60e9 -> 'min').
				(1e9 -> 'sec').
				(1e6 -> 'millisec').
				(1e3 -> 'microsec').
				(1 -> 'nanosec') }
		withRespectTo: [ :aDuration | aDuration asNanoSeconds ]
]
