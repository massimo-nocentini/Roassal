Class {
	#name : 'BaselineOfRoassalMN',
	#superclass : 'BaselineOfRoassal',
	#category : 'BaselineOfRoassal',
	#package : 'BaselineOfRoassal'
}

{ #category : 'API-packages' }
BaselineOfRoassalMN >> corePackagesNames [

	^ super corePackagesNames , #( 'Roassal-Utils' )
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
