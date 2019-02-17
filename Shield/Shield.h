//
//  Shield.h
//  Shield
//
//  Created by William Towe on 3/13/17.
//  Copyright © 2019 Kosoku Interactive, LLC. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import <Foundation/Foundation.h>

//! Project version number for Shield.
FOUNDATION_EXPORT double ShieldVersionNumber;

//! Project version string for Shield.
FOUNDATION_EXPORT const unsigned char ShieldVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Shield/PublicHeader.h>

#if __has_include(<Shield/KSHLocationAuthorization.h>)
#import <Shield/KSHLocationAuthorization.h>
#endif

#if (TARGET_OS_IOS || TARGET_OS_TV || TARGET_OS_OSX)

#if __has_include(<Shield/KSHNotificationAuthorization.h>)
#import <Shield/KSHNotificationAuthorization.h>
#endif

#if __has_include(<Shield/KSHPhotosAuthorization.h>)
#import <Shield/KSHPhotosAuthorization.h>
#endif

#endif

#if (TARGET_OS_IOS || TARGET_OS_OSX)

#if __has_include(<Shield/KSHEventAuthorization.h>)
#import <Shield/KSHEventAuthorization.h>
#endif

#if __has_include(<Shield/KSHContactsAuthorization.h>)
#import <Shield/KSHContactsAuthorization.h>
#endif

#if __has_include(<Shield/KSHLocalAuthorization.h>)
#import <Shield/KSHLocalAuthorization.h>
#endif

#if __has_include(<Shield/KSHCameraAuthorization.h>)
#import <Shield/KSHCameraAuthorization.h>
#endif

#if __has_include(<Shield/KSHMicrophoneAuthorization.h>)
#import <Shield/KSHMicrophoneAuthorization.h>
#endif

#endif

#if (TARGET_OS_IOS || TARGET_OS_TV)

#if __has_include(<Shield/KSHVideoSubscriberAccountAuthorization.h>)
#import <Shield/KSHVideoSubscriberAccountAuthorization.h>
#endif

#endif

#if (TARGET_OS_OSX)

#if __has_include(<Shield/KSHAccessibilityAuthorization.h>)
#import <Shield/KSHAccessibilityAuthorization.h>
#endif

#if __has_include(<Shield/KSHSecurityAuthorization.h>)
#import <Shield/KSHSecurityAuthorization.h>
#import <Shield/KSHSecurityRights.h>
#endif

#endif

#if (TARGET_OS_IOS)

#if __has_include(<Shield/KSHMediaLibraryAuthorization.h>)
#import <Shield/KSHMediaLibraryAuthorization.h>
#endif

#if __has_include(<Shield/KSHHealthAuthorization.h>)
#import <Shield/KSHHealthAuthorization.h>
#endif

#if __has_include(<Shield/KSHSiriAuthorization.h>)
#import <Shield/KSHSiriAuthorization.h>
#endif

#if __has_include(<Shield/KSHSpeechAuthorization.h>)
#import <Shield/KSHSpeechAuthorization.h>
#endif

#if __has_include(<Shield/KSHBluetoothAuthorization.h>)
#import <Shield/KSHBluetoothAuthorization.h>
#endif

#if __has_include(<Shield/KSHHomeAuthorization.h>)
#import <Shield/KSHHomeAuthorization.h>
#endif

#if __has_include(<Shield/KSHMotionAuthorization.h>)
#import <Shield/KSHMotionAuthorization.h>
#endif

#endif
