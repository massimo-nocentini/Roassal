"
I am a box drawn as a note by hand: my sides and my corners are Bezier curves shaken by a bivariate Gaussian (RSAthensRenderer>>#buildSimplerNotePath:).
"
Class {
	#name : 'RSSimplerNote',
	#superclass : 'RSBox',
	#category : 'Roassal-Shapes-Bounding',
	#package : 'Roassal-Shapes',
	#tag : 'Bounding'
}

{ #category : 'visiting' }
RSSimplerNote >> buildPathOn: visitor [

	visitor buildSimplerNotePath: self
]

{ #category : 'accessing' }
RSSimplerNote >> newRandom [
	"The random variable that shakes my path when it is built"

	^ RandomBoxMullerBivariateGaussian new
]
