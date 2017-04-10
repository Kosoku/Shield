//
//  Shield.h
//  Shield
//
//  Created by William Towe on 3/13/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <Foundation/Foundation.h>

//! Project version number for Shield.
FOUNDATION_EXPORT double ShieldVersionNumber;

//! Project version string for Shield.
FOUNDATION_EXPORT const unsigned char ShieldVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Shield/PublicHeader.h>

#import <Shield/KSHLocationAuthorization.h>
#if (TARGET_OS_IOS || TARGET_OS_OSX)
#import <Shield/KSHEventAuthorization.h>
#import <Shield/KSHContactsAuthorization.h>
#import <Shield/KSHAccountsAuthorization.h>
#import <Shield/KSHLocalAuthorization.h>
#endif
#if (TARGET_OS_IOS || TARGET_OS_TV)
#import <Shield/KSHPhotosAuthorization.h>
#import <Shield/KSHNotificationAuthorization.h>
#import <Shield/KSHVideoSubscriberAccountAuthorization.h>
#endif
#if (TARGET_OS_OSX)
#import <Shield/KSHAccessibilityAuthorization.h>
#import <Shield/KSHSecurityAuthorization.h>
#import <Shield/KSHSecurityRights.h>
#endif
#if (TARGET_OS_IOS)
#import <Shield/KSHCameraAuthorization.h>
#import <Shield/KSHMicrophoneAuthorization.h>
#import <Shield/KSHMediaLibraryAuthorization.h>
#import <Shield/KSHHealthAuthorization.h>
#import <Shield/KSHSiriAuthorization.h>
#import <Shield/KSHSpeechAuthorization.h>
#import <Shield/KSHBluetoothAuthorization.h>
#import <Shield/KSHHomeAuthorization.h>
#import <Shield/KSHMotionAuthorization.h>
#endif
