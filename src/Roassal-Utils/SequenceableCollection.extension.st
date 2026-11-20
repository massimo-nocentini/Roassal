Extension { #name : 'SequenceableCollection' }

{ #category : '*Roassal-Utils' }
SequenceableCollection >> exponentiallyWeighted: alpha [
	"The exponentially weighted moving average of my Numbers (or Points), with the smoothing factor alpha in [0, 1]: its first element is my first one, and each other one is alpha times my element plus 1 - alpha times the previous average. An Array of my size"

	| averages average |
	averages := Array new: self size.
	self isEmpty ifTrue: [ ^ averages ].
	average := self first.
	averages at: 1 put: average.
	2 to: self size do: [ :index |
		average := (self at: index) * alpha + (average * (1 - alpha)).
		averages at: index put: average ].
	^ averages
]
