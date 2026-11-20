"
This interaction simulates the vertical scroll with mouse wheel: each step of the wheel translates the camera of the canvas by `speed` pixels.
With `shouldAnimate: true`, it animates the canvas during the scroll, and brings the camera back inside the shapes after it; by default it does not, and the camera goes where the wheel takes it.
"
Class {
	#name : 'RSScrollWheelCanvasInteraction',
	#superclass : 'RSAbstractControlCanvasInteraction',
	#instVars : [
		'animation',
		'shouldAnimate',
		'speed'
	],
	#category : 'Roassal-Interaction-Controls',
	#package : 'Roassal-Interaction',
	#tag : 'Controls'
}

{ #category : 'events - processing' }
RSScrollWheelCanvasInteraction >> canvas: aCanvas animationDo: aBlock [
	"Evaluate aBlock, which moves the camera, within an animation when I should animate"

	(shouldAnimate and: [ animation isNotNil ]) ifTrue: [ animation stop ].

	aBlock value.

	shouldAnimate ifFalse: [ ^ self ].
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
		             for: self
]

{ #category : 'initialization' }
RSScrollWheelCanvasInteraction >> initialize [

	super initialize.
	shouldAnimate := false.
	speed := (10 * Float goldenRatio) ceiling
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

{ #category : 'accessing' }
RSScrollWheelCanvasInteraction >> shouldAnimate [

	^ shouldAnimate
]

{ #category : 'accessing' }
RSScrollWheelCanvasInteraction >> shouldAnimate: aBoolean [
	"Whether a scroll animates the canvas and brings the camera back inside the shapes (upstream's behaviour); false by default"

	shouldAnimate := aBoolean
]

{ #category : 'accessing' }
RSScrollWheelCanvasInteraction >> speed [
	"The pixels by which a step of the wheel translates the camera"

	^ speed
]

{ #category : 'accessing' }
RSScrollWheelCanvasInteraction >> speed: aNumber [

	speed := aNumber
]
