"
I load Roassal from the fork https://github.com/massimo-nocentini/Roassal with RTree from the fork https://github.com/massimo-nocentini/RTree (branch master), instead of the pharo-graphics repositories:

	Metacello new
		baseline: 'RoassalMN';
		repository: 'github://massimo-nocentini/Roassal:Pharo15/src';
		onWarning: [ :warning |
			(warning isKindOf: MCMergeOrLoadWarning)
				ifTrue: [ warning load ]
				ifFalse: [ warning resume ] ];
		load: 'Full'.

Pharo ships Roassal, and Metacello asks whether to load the new versions over its packages (MCMergeOrLoadWarning): answer Load, as the onWarning: block does. A plain resume (onWarningLog) keeps the methods of the image.

I am BaselineOfRoassal with another repository for RTree: the same packages and groups (Core, Examples, Tests, Mini, Full, BlocFull...; default is Mini), and the Roassal packages come from the repository I am loaded from.

My superclass must be in the image before I am loaded. Pharo 15 ships it; in an image without it, first send `Metacello new baseline: 'Roassal'; repository: 'github://massimo-nocentini/Roassal:Pharo15/src'; get`. I do not load Roassal as a nested project: Metacello would keep the Roassal and RTree projects that Pharo already registers.

Metacello loads me, not my superclass, from my repository: the BaselineOfRoassal of the image (the one of Pharo 15) builds the spec. So I add what this repository's BaselineOfRoassal has more than Pharo's, when the image's lacks it the packages Roassal-Utils and Roassal-Utils-Tests.
"
Class {
	#name : 'BaselineOfRoassalMN',
	#superclass : 'BaselineOfRoassal',
	#category : 'BaselineOfRoassalMN',
	#package : 'BaselineOfRoassalMN'
}

{ #category : 'baselines' }
BaselineOfRoassalMN >> baseline: spec [
	"https://github.com/massimo-nocentini/Roassal"

	<baseline>
	super baseline: spec
]

{ #category : 'API-packages' }
BaselineOfRoassalMN >> corePackagesNames [
	"Roassal-Utils first, as in the BaselineOfRoassal of my repository"

	| names |
	names := super corePackagesNames.
	^ (names includes: 'Roassal-Utils')
		  ifTrue: [ names ]
		  ifFalse: [ #( 'Roassal-Utils' ) , names ]
]

{ #category : 'dependencies' }
BaselineOfRoassalMN >> rtree: spec [

	spec
		baseline: 'RTree'
		with: [ spec repository: 'github://massimo-nocentini/RTree:master/src' ]
]

{ #category : 'API-packages' }
BaselineOfRoassalMN >> testPackagesNames [
	"With Roassal-Utils-Tests, as in the BaselineOfRoassal of my repository"

	| names |
	names := super testPackagesNames.
	^ (names includes: 'Roassal-Utils-Tests')
		  ifTrue: [ names ]
		  ifFalse: [ names , #( 'Roassal-Utils-Tests' ) ]
]
