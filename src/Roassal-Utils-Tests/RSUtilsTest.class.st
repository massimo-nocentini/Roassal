Class {
	#name : 'RSUtilsTest',
	#superclass : 'TestCase',
	#category : 'Roassal-Utils-Tests',
	#package : 'Roassal-Utils-Tests'
}

{ #category : 'tests' }
RSUtilsTest >> testGoldenRatios [

	self
		assert: Float goldenRatio equals: 1.618033988749895;
		assert: Float silverRatio equals: 0.6180339887498948;
		assert: Float bronzeRatio equals: 0.3819660112501051;
		assert: Float platinumRatio equals: 2.618033988749895;
		assert: Float goldenPlatinumRatio equals: 4.23606797749979
]
