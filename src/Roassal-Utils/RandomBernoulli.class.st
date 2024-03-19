"
From: https://en.wikipedia.org/wiki/Bernoulli_distribution

In probability theory and statistics, the Bernoulli distribution, named after Swiss mathematician Jacob Bernoulli, is the discrete probability distribution of a random variable which takes the value 1 with probability {\displaystyle p} and the value 0 with probability {\displaystyle q=1-p}. 

Less formally, it can be thought of as a model for the set of possible outcomes of any single experiment that asks a yes–no question. Such questions lead to outcomes that are Boolean-valued: a single bit whose value is success/yes/true/one with probability p and failure/no/false/zero with probability q. It can be used to represent a (possibly biased) coin toss where 1 and 0 would represent ""heads"" and ""tails"", respectively, and p would be the probability of the coin landing on heads (or vice versa where 1 would represent tails and p would be the probability of tails). In particular, unfair coins would have {\displaystyle p\neq 1/2.}

The Bernoulli distribution is a special case of the binomial distribution where a single trial is conducted (so n would be 1 for such a binomial distribution). It is also a special case of the two-point distribution, for which the possible outcomes need not be 0 and 1.
"
Class {
	#name : 'RandomBernoulli',
	#superclass : 'RSRandom',
	#instVars : [
		'p'
	],
	#category : 'Roassal-Utils-Random',
	#package : 'Roassal-Utils',
	#tag : 'Random'
}

{ #category : 'sampling' }
RandomBernoulli >> cdf: x [

	^ x < 0.0
		  ifTrue: [ 0.0 ]
		  ifFalse: [
			  x >= 1.0
				  ifTrue: [ 1.0 ]
				  ifFalse: [ 1.0 - p ] ]
]

{ #category : 'accessing' }
RandomBernoulli >> density: x [

	^ p ** x * (1.0 - p ** (1.0 - x))
]

{ #category : 'accessing' }
RandomBernoulli >> ifHead: hBlock ifTail: tBlock [

	^ self next ifZero: tBlock ifNotZero: hBlock
]

{ #category : 'initialization' }
RandomBernoulli >> initialize [

	super initialize.

	self p: 0.5
]

{ #category : 'accessing' }
RandomBernoulli >> next [

	^ (super next <= p) asInteger
]

{ #category : 'accessing' }
RandomBernoulli >> p: aNumber [

	p := aNumber min: 0.0 max: 1.0
]
