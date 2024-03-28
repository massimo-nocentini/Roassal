Extension { #name : 'CairoFontMetricsProvider' }

{ #category : '*Roassal-Shapes' }
CairoFontMetricsProvider >> initialize [

	utfConverter := CairoUTF8Converter new.
	glyphExtents := CairoTextExtentsBySlots new.
	cache := CairoBackendCache soleInstance
]
