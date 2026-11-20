Class {
	#name : 'RSScrollWheelCanvasInteractionTest',
	#superclass : 'TestCase',
	#instVars : [
		'canvas',
		'interaction'
	],
	#category : 'Roassal-Interaction-Tests-Core',
	#package : 'Roassal-Interaction-Tests',
	#tag : 'Core'
}

{ #category : 'running' }
RSScrollWheelCanvasInteractionTest >> setUp [

	super setUp.
	canvas := RSCanvas new.
	canvas add: (RSBox new
			 size: 100;
			 yourself).
	interaction := RSScrollWheelCanvasInteraction new.
	canvas addInteraction: interaction
]

{ #category : 'tests' }
RSScrollWheelCanvasInteractionTest >> testDefaults [

	self
		deny: interaction shouldAnimate;
		assert: interaction speed equals: 17.
	self
		deny: RSControlConfiguration new shouldAnimateZoom;
		assert: (RSControlConfiguration new padding left - (Float goldenRatio * 10)) abs < 1.0e-9
]

{ #category : 'tests' }
RSScrollWheelCanvasInteractionTest >> testScrollWithAnimation [

	| position |
	interaction shouldAnimate: true.
	position := canvas camera position.
	interaction move: canvas delta: interaction speed.
	self
		deny: canvas camera position equals: position;
		assert: canvas animations notEmpty
]

{ #category : 'tests' }
RSScrollWheelCanvasInteractionTest >> testScrollWithoutAnimation [

	| position up down |
	position := canvas camera position.
	interaction move: canvas delta: interaction speed.
	up := canvas camera position - position.
	self
		assert: up x equals: 0;
		deny: up y equals: 0;
		assert: canvas animations isEmpty.
	position := canvas camera position.
	interaction move: canvas delta: interaction speed negated.
	down := canvas camera position - position.
	self assert: up y * down y < 0
]
