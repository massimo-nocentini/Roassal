"
I am the root of the random variables of Roassal (RandomBernoulli, RandomGaussian, RandomExponential...): each of my subclasses answers a sample of its distribution to `next`, and its cumulative distribution function to `cdf:`.

My uniform fractions, in [0, 1), come from Knuth's lagged Fibonacci generator of TAOCP 3.6 (his `rng-double.c`), which `KnuthRandom` (VM-Plugins-Primitives) runs in the UtilsPlugin of the VM, or in Smalltalk on a VM without it, bit for bit the same: `nextUniform` answers the next one, whatever `next` answers in a subclass. So `nextInteger:`, `nextBetween:and:` and `nextIntegerBetween:and:` stay uniform, as in Random.

`shortLagArray` and `longLagArray` show the state of the generator: Knuth's `ran_u` (the 100 last fractions of the lagged Fibonacci sequence) and his buffer of 1009 fractions (ended by -1 when it is used up).

```
(RandomGaussian seed: 42) next: 5.
(RandomBernoulli new p: 0.3; yourself) next.
```
"
Class {
	#name : 'RSRandom',
	#superclass : 'KnuthRandom',
	#category : 'Roassal-Utils-Random',
	#package : 'Roassal-Utils',
	#tag : 'Random'
}

{ #category : 'sampling' }
RSRandom >> cdf: x [
	"The probability that a sample is at most x"

	self subclassResponsibility
]

{ #category : 'sampling' }
RSRandom >> cdf: x ifLessThan: sBlock else: fBlock [
	"Evaluate sBlock with x with the probability (self cdf: x), else fBlock"

	^ self nextUniform < (self cdf: x)
		  ifTrue: [ sBlock cull: x ]
		  ifFalse: [ fBlock cull: x ]
]

{ #category : 'private' }
RSRandom >> doublesOf: aByteArray [

	^ (1 to: aByteArray size // 8) collect: [ :index |
		  aByteArray float64AtOffset: index - 1 * 8 ]
]

{ #category : 'accessing' }
RSRandom >> longLagArray [
	"Knuth's buffer of 1009 fractions, ranf_arr_buf (-1 marks its end once it is used up)"

	^ self doublesOf: (state at: 2)
]

{ #category : 'accessing' }
RSRandom >> nextBetween: lowerBound and: higherBound [
	"A uniform Float in [lowerBound, higherBound), whatever my distribution"

	^ lowerBound + (self nextUniform * (higherBound - lowerBound))
]

{ #category : 'accessing' }
RSRandom >> nextInteger: anInteger [
	"A uniform integer in [1, anInteger], whatever my distribution, as KnuthRandom's"

	anInteger strictlyPositive ifFalse: [ self error: 'Range must be positive' ].
	^ (self nextUniform asTrueFraction * anInteger) truncated + 1
]

{ #category : 'accessing' }
RSRandom >> nextUniform [
	"The next uniform fraction of the generator, a Float in [0, 1)"

	^ super next
]

{ #category : 'private' }
RSRandom >> privateNextValue [
	"Random's: an integer in [0, maxValue], uniform, whatever my distribution"

	^ (self nextUniform * (self maxValue + 1)) truncated
]

{ #category : 'accessing' }
RSRandom >> shortLagArray [
	"Knuth's ran_u, the state of the lagged Fibonacci sequence: its 100 last fractions"

	^ self doublesOf: (state at: 1)
]
