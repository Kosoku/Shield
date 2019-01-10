//
//  Shield.h
//  Shield
//
//  Created by William Towe on 3/13/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
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

#import <Shield/KSHLocationAuthorization.h>
#if (TARGET_OS_IOS || TARGET_OS_TV || TARGET_OS_OSX)
#import <Shield/KSHNotificationAuthorization.h>
#import <Shield/KSHPhotosAuthorization.h>
#endif
#if (TARGET_OS_IOS || TARGET_OS_OSX)
#import <Shield/KSHEventAuthorization.h>
#import <Shield/KSHContactsAuthorization.h>
#import <Shield/KSHLocalAuthorization.h>
#import <Shield/KSHCameraAuthorization.h>
#import <Shield/KSHMicrophoneAuthorization.h>
#endif
#if (TARGET_OS_IOS || TARGET_OS_TV)
#import <Shield/KSHVideoSubscriberAccountAuthorization.h>
#endif
#if (TARGET_OS_OSX)
#import <Shield/KSHAccessibilityAuthorization.h>
#import <Shield/KSHSecurityAuthorization.h>
#import <Shield/KSHSecurityRights.h>
#endif
#if (TARGET_OS_IOS)
#import <Shield/KSHMediaLibraryAuthorization.h>
#import <Shield/KSHHealthAuthorization.h>
#import <Shield/KSHSiriAuthorization.h>
#import <Shield/KSHSpeechAuthorization.h>
#import <Shield/KSHBluetoothAuthorization.h>
#import <Shield/KSHHomeAuthorization.h>
#import <Shield/KSHMotionAuthorization.h>
#endif
