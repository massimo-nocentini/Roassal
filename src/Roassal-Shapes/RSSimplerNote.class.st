Class {
	#name : 'RSSimplerNote',
	#superclass : 'RSBox',
	#category : 'Roassal-Shapes-Bounding',
	#package : 'Roassal-Shapes',
	#tag : 'Bounding'
}

{ #category : 'visiting' }
RSSimplerNote >> buildPathOn: visitor [
	"visiting"

	visitor buildSimplerNotePath: self
]
