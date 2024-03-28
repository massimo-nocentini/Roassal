Extension { #name : 'CairoScaledFont' }

{ #category : '*Roassal-Shapes' }
CairoScaledFont >> extents [

	| extents |
	extents := CairoFontExtentsBySlots new.

	self getExtents: extents.

	^ extents
]
