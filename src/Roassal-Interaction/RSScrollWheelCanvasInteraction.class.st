"
This interaction simulates the vertical scroll with mouse wheel.
When used will creates animations to translate canvas camera position
"
Class {
	#name : 'RSScrollWheelCanvasInteraction',
	#superclass : 'RSAbstractControlCanvasInteraction',
	#instVars : [
		'animation',
		'doAnimation'
	],
	#category : 'Roassal-Interaction-Controls',
	#package : 'Roassal-Interaction',
	#tag : 'Controls'
}

{ #category : 'events - processing' }
RSScrollWheelCanvasInteraction >> canvas: aCanvas animationDo: block [

	(doAnimation and: [ animation isNotNil ]) ifTrue: [ animation stop ].

	block value.

	doAnimation ifTrue: [
		animation := aCanvas newAnimation
			             duration: 300 milliSeconds;
			             onStepDo: [ :t | aCanvas signalUpdate ];
			             when: RSAnimationLoopEvent do: [ :e |
				             | correct |
				             animation := nil.
				             correct := self correctCamera: aCanvas camera.
				             aCanvas camera position = correct ifFalse: [
						             aCanvas newAnimation
							             duration: 200 milliSeconds;
							             from: aCanvas camera position;
							             to: correct;
							             onStepDo: [ :t |
								             aCanvas camera translateTo: t.
								             aCanvas signalUpdate ] ] ]
			             for: self ]
]

{ #category : 'initialization' }
RSScrollWheelCanvasInteraction >> initialize [

	super initialize.

	animation := nil.

	doAnimation := false
]

{ #category : 'events - processing' }
RSScrollWheelCanvasInteraction >> move: aCanvas delta: delta [

	self canvas: aCanvas animationDo: [
		| camera p correct r |
		r := 0.33333333.
		camera := aCanvas camera.

		correct := self correctCamera: camera.
		p := (correct - camera position) abs max: 1 @ 1.
		p := (p x raisedTo: r) @ (p y raisedTo: r).
		camera translateBy: 0 @ delta / p.
		aCanvas signalUpdate ]
]

{ #category : 'hooks' }
RSScrollWheelCanvasInteraction >> onShape: aCanvas [
	aCanvas when: RSMouseWheelEvent send: #processEvent: to: self
]

{ #category : 'events - processing' }
RSScrollWheelCanvasInteraction >> processEvent: evt [

	| direction |
	direction := evt isUp
		             ifTrue: [ 1 ]
		             ifFalse: [ -1 ].

	self move: evt canvas delta: direction * self speed
]

{ #category : 'rendering' }
RSScrollWheelCanvasInteraction >> renderLegendOn: aLegendBuilder [
]

{ #category : 'events - processing' }
RSScrollWheelCanvasInteraction >> speed [

	^ (10 * Float goldenRatio) ceiling
]
