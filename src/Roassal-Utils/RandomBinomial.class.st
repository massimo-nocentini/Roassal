"
From https://en.wikipedia.org/wiki/Binomial_distribution:

In probability theory and statistics, the binomial distribution with parameters n and p is the discrete probability distribution of the number of successes in a sequence of n independent experiments, each asking a yes–no question, and each with its own Boolean-valued outcome: success (with probability p) or failure (with probability {\displaystyle q=1-p}). A single success/failure experiment is also called a Bernoulli trial or Bernoulli experiment, and a sequence of outcomes is called a Bernoulli process; for a single trial, i.e., n = 1, the binomial distribution is a Bernoulli distribution. The binomial distribution is the basis for the popular binomial test of statistical significance.

The binomial distribution is frequently used to model the number of successes in a sample of size n drawn with replacement from a population of size N. If the sampling is carried out without replacement, the draws are not independent and so the resulting distribution is a hypergeometric distribution, not a binomial one. However, for N much larger than n, the binomial distribution remains a good approximation, and is widely used.
"
Class {
	#name : 'RandomBinomial',
	#superclass : 'RandomBernoulli',
	#instVars : [
		'n'
	],
	#category : 'Roassal-Utils-Random',
	#package : 'Roassal-Utils',
	#tag : 'Random'
}

{ #category : 'sampling' }
RandomBinomial >> cdf: x [

	^ (1 to: x floor)
		  inject: 0.0
		  into: [ :cum :i | cum + (self density: i) ]
]

{ #category : 'accessing' }
RandomBinomial >> density: x [

	^ (n choose: x) * (p ** x) * (1 - p ** (n - x))
]

{ #category : 'initialization' }
RandomBinomial >> initialize [

	super initialize.

	self n: 1
]

{ #category : 'accessing' }
RandomBinomial >> n: anInteger [

	n := anInteger
]

{ #category : 'accessing' }
RandomBinomial >> next [

	^ (1 to: n)
		  inject: 0
		  into: [ :successes :each | successes + super next ]
]
