Extension { #name : 'AthensCairoSurface' }

{ #category : '*Roassal' }
AthensCairoSurface >> hasBeenFreed [
	"Return true if the external resource has been freed"
	^ handle isNull
]
