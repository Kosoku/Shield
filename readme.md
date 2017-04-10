## Shield

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](http://img.shields.io/cocoapods/v/Shield.svg)](http://cocoapods.org/?q=Shield)
[![Platform](http://img.shields.io/cocoapods/p/Shield.svg)]()
[![License](http://img.shields.io/cocoapods/l/Shield.svg)](https://github.com/Kosoku/Shield/blob/master/license.txt)

*Shield* is an iOS/macOS/tvOS framework that wraps various authorization APIs (e.g. camera, photo, location). It relies on the [Stanley](https://github.com/Kosoku/Stanley) framework.

### Installation

You can install *Shield* using [cocoapods](https://cocoapods.org/), [Carthage](https://github.com/Carthage/Carthage), or as a framework. When installing as a framework, ensure you also link to [Stanley](https://github.com/Kosoku/Stanley) as *Shield* relies on it.

#### Cocoapods

1. Add *Shield* to your Podfile
	- Pull in the entire pod or
	
			pod 'Shield'
	
	- pull in subspecs
	
			pod 'Shield/Camera'
			pod 'Shield/Photos'

2. Update your pods

		$ pod update

##### Subspecs

- `Shield/Location`, wraps `CoreLocation` authorization APIs (`iOS`/`tvOS`/`macOS`)
- `Shield/Camera`, wraps `AVFoundation` video authorization APIs (`iOS`)
- `Shield/Microphone`, wraps `AVFoundation` audio authorization APIs (`iOS`)
- `Shield/MediaLibrary`, wraps `MediaPlayer` media library authorization APIs (`iOS`)
- `Shield/Photos`, wraps `Photos` authorization APIs (`iOS`/`tvOS`)
- `Shield/Health`, wraps `HealthKit` authorization APIs (`iOS`)
- `Shield/Siri`, wraps `Intents` Siri authorization APIs (`iOS`)
- `Shield/Speech`, wraps `Speech` speech recognizer authorization APIs (`iOS`)
- `Shield/Bluetooth`, wraps `CoreBluetooth` bluetooth peripheral authorization APIs (`iOS`)
- `Shield/Event`, wraps `EventKit` events and reminders authorization APIs (`iOS`/`macOS`)
- `Shield/Contacts`, wraps `Contacts` authorization APIs (`iOS`/`macOS`)
- `Shield/Accessibility`, wraps `ApplicationServices` accessibility authorization APIs (`macOS`)
- `Shield/Accounts`, wraps `Accounts` social accounts authorization APIs (`iOS`/`macOS`)
- `Shield/Home`, wraps `HomeKit` authorization APIs (`iOS`)
- `Shield/Motion`, wraps `CoreMotion` authorization APIs (`iOS`)
- `Shield/Security`, wraps `Security` authorization APIs for elevating execution privileges (`macOS`)
- `Shield/Local`, wraps `LocalAuthentication` Touch ID authorization APIs (`iOS`/`macOS`)
- `Shield/Notification`, wraps `UserNotifications` authorization APIs (`iOS`/`tvOS`)

### Dependencies

Third party:

- [Stanley](https://github.com/Kosoku/Stanley)

Apple:

- `HealthKit`, `iOS` only
- `Intents`, `iOS` only
- `Speech`, `iOS` only
- `AVFoundation`, `iOS` only
- `Photos`, `iOS` and `tvOS`
- `CoreBluetooth`, `iOS` only
- `ApplicationServices`, `macOS` only
- `CoreLocation`, `iOS`, `macOS` and `tvOS`
- `EventKit`, `iOS` and `macOS`
- `Contacts`, `iOS` and `macOS`
- `AppKit`, `macOS` only
- `MediaPlayer`, `iOS` only
- `HomeKit`, `iOS` only
- `Security`, `macOS` only
- `CoreMotion`, `iOS` only
- `Accounts`, `iOS` and `macOS`
- `MediaPlayer`, `iOS` only
- `LocalAuthorization`, `iOS` and `macOS`
- `UserNotifications`, `iOS` and `tvOS`
