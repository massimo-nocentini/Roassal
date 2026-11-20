"
I load Roassal from the fork https://github.com/massimo-nocentini/Roassal with RTree and RoassalLayouts from the forks https://github.com/massimo-nocentini/RTree and https://github.com/massimo-nocentini/RoassalLayouts (branch master), instead of the pharo-graphics repositories:

	Metacello new
		baseline: 'RoassalMN';
		repository: 'github://massimo-nocentini/Roassal:Pharo15/src';
		onWarning: [ :warning |
			(warning isKindOf: MCMergeOrLoadWarning)
				ifTrue: [ warning load ]
				ifFalse: [ warning resume ] ];
		load: 'Full'.

Pharo ships Roassal, and Metacello asks whether to load the new versions over its packages (MCMergeOrLoadWarning): answer Load, as the onWarning: block does. A plain resume (onWarningLog) keeps the methods of the image.

I am BaselineOfRoassal with other repositories for RTree and RoassalLayouts: the same packages and groups (Core, Examples, Tests, Mini, Full, BlocFull...; default is Mini), and the Roassal packages come from the repository I am loaded from. My group Full (and the groups that include it) also loads the group Core of RoassalExporters, from its fork https://github.com/massimo-nocentini/RoassalExporters (branch master), after the Roassal packages: the PNG, SVG, PDF and HTML exporters (RSCanvas>>#exportToPNG...), their examples and their tests.

My superclass must be in the image before I am loaded. Pharo 15 ships it; in an image without it, first send `Metacello new baseline: 'Roassal'; repository: 'github://massimo-nocentini/Roassal:Pharo15/src'; get`. I do not load Roassal as a nested project: Metacello would keep the Roassal and RTree projects that Pharo already registers.

Metacello loads me, not my superclass, from my repository: the BaselineOfRoassal of the image (the one of Pharo 15) builds the spec. So I add what this repository's BaselineOfRoassal has more than Pharo's, when the image's lacks it (when #hasOwnSuperclass answers false): the packages Roassal-Utils and Roassal-Utils-Tests, and their dependency on VMPluginsPrimitives (github://massimo-nocentini/vm-plugins-primitives.st).
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
	super baseline: spec.
	spec for: #common do: [
		self roassalExporters: spec.
		spec group: 'Full' with: #( 'RoassalExporters' ) ]
]

{ #category : 'baselines' }
BaselineOfRoassalMN >> baselineOfCommon: spec [

	super baselineOfCommon: spec.
	self hasOwnSuperclass ifTrue: [ ^ self ].
	"The BaselineOfRoassal of Pharo 15: the packages require what they do in the one of my repository"
	spec for: #common do: [
		spec
			package: #Roassal with: [ spec requires: #( 'VMPluginsPrimitives' ) ];
			package: #'Roassal-Utils' with: [ spec requires: #( 'VMPluginsPrimitives' ) ];
			package: #'Roassal-Utils-Tests' with: [ spec requires: #( 'Roassal-Utils' ) ] ]
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

{ #category : 'testing' }
BaselineOfRoassalMN >> hasOwnSuperclass [
	"Whether the image has the BaselineOfRoassal of my repository, rather than the one of Pharo 15, which lacks what I add when this answers false"

	^ BaselineOfRoassal includesSelector: #vmPluginsPrimitives:
]

{ #category : 'dependencies' }
BaselineOfRoassalMN >> layouts: spec [
	"The fork of RoassalLayouts, with its tree layouts (Van der Ploeg's)"

	spec
		baseline: 'RoassalLayouts'
		with: [
		spec repository: 'github://massimo-nocentini/RoassalLayouts:master/src' ]
]

{ #category : 'dependencies' }
BaselineOfRoassalMN >> roassalExporters: spec [
	"Its baseline asks for Roassal only in an image without RSCanvas, which Pharo 15 has"

	spec
		baseline: 'RoassalExporters'
		with: [
			spec
				repository: 'github://massimo-nocentini/RoassalExporters:master/src';
				loads: #( 'Core' ) ]
]

{ #category : 'dependencies' }
BaselineOfRoassalMN >> rtree: spec [
	"The last of the projects that BaselineOfRoassal>>#baselineOfCommon: declares before its packages: with the BaselineOfRoassal of Pharo 15, VMPluginsPrimitives goes after it, so that the packages that require it are loaded after it, in their order"

	spec
		baseline: 'RTree'
		with: [ spec repository: 'github://massimo-nocentini/RTree:master/src' ].
	self hasOwnSuperclass ifFalse: [ self vmPluginsPrimitives: spec ]
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

{ #category : 'dependencies' }
BaselineOfRoassalMN >> vmPluginsPrimitives: spec [
	"As the BaselineOfRoassal of my repository, for when the image has the one of Pharo 15, without it"

	spec
		baseline: 'VMPluginsPrimitives'
		with: [
			spec
				repository: 'github://massimo-nocentini/vm-plugins-primitives.st:master/src';
				loads: #( 'Core' ) ]
]
