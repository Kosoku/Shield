## Shield

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](http://img.shields.io/cocoapods/v/Shield.svg)](http://cocoapods.org/?q=Shield)
[![Platform](http://img.shields.io/cocoapods/p/Shield.svg)]()
[![License](http://img.shields.io/cocoapods/l/Shield.svg)](https://github.com/Kosoku/Shield/blob/master/license.txt)

*Shield* is an iOS/macOS/tvOS framework that wraps various authorization APIs (e.g. camera, photo, location). It relies on the [Stanley](https://github.com/Kosoku/Stanley) framework.

### Installation

You can install *Shield* using [cocoapods](https://cocoapods.org/), [Carthage](https://github.com/Carthage/Carthage), or as a framework. When installing as a framework, ensure you also link to [Stanley](https://github.com/Kosoku/Stanley) as *Shield* relies on it.

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
