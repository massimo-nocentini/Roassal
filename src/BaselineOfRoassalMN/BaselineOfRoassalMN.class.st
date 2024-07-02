"
Baseline for https://github.com/massimo-nocentini/Roassal
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
	^ super baseline: spec
]

{ #category : 'API-packages' }
BaselineOfRoassalMN >> corePackagesNames [

	^ #( 'Roassal-Utils' ) , super corePackagesNames
]

{ #category : 'dependencies' }
BaselineOfRoassalMN >> layouts: spec [

	spec
		baseline: 'RoassalLayouts'
		with: [
		spec repository: 'github://massimo-nocentini/RoassalLayouts/src' ]
]

{ #category : 'API-packages' }
BaselineOfRoassalMN >> testPackagesNames [

	^ super testPackagesNames , #( 'Roassal-Utils-Tests' )
]
