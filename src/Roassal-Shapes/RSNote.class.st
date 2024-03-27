Class {
	#name : 'RSNote',
	#superclass : 'RSBox',
	#category : 'Roassal-Shapes-Bounding',
	#package : 'Roassal-Shapes',
	#tag : 'Bounding'
}

{ #category : 'visiting' }
RSNote >> buildPathOn: visitor [
	"visiting"

	visitor buildNotePath: self
]
