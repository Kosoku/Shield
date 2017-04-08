//
//  KSHAuthorizationManager.h
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

#import <TargetConditionals.h>

#if (TARGET_OS_IPHONE)
#if (TARGET_OS_IOS)
#import <HealthKit/HKHealthStore.h>
#import <MediaPlayer/MPMediaLibrary.h>
#if (TARGET_OS_IOS)
#import <Speech/SFSpeechRecognizer.h>
#endif
#endif
#import <AVFoundation/AVCaptureDevice.h>
#import <Photos/PHPhotoLibrary.h>
#import <CoreBluetooth/CBPeripheralManager.h>
#else
#import <ApplicationServices/ApplicationServices.h>
#endif
#if (TARGET_OS_IOS || TARGET_OS_OSX)
#import <EventKit/EKTypes.h>
#import <Contacts/CNContactStore.h>
#endif

NS_ASSUME_NONNULL_BEGIN

#if (TARGET_OS_IOS || TARGET_OS_OSX)

/**
 Enum defining possible contacts authorization status values. See CNAuthorizationStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSHContactsAuthorizationStatus) {
    /**
     See CNAuthorizationStatusNotDetermined for more information.
     */
    KSHContactsAuthorizationStatusNotDetermined = CNAuthorizationStatusNotDetermined,
    /**
     See CNAuthorizationStatusRestricted for more information.
     */
    KSHContactsAuthorizationStatusRestricted = CNAuthorizationStatusRestricted,
    /**
     See CNAuthorizationStatusDenied for more information.
     */
    KSHContactsAuthorizationStatusDenied = CNAuthorizationStatusDenied,
    /**
     See CNAuthorizationStatusAuthorized for more information.
     */
    KSHContactsAuthorizationStatusAuthorized = CNAuthorizationStatusAuthorized
};
/**
 Completion block that is invoked after requesting contacts access.
 
 @param status The current contacts authorization status
 @param error The error
 */
typedef void(^KSHRequestContactsAuthorizationCompletionBlock)(KSHContactsAuthorizationStatus status, NSError * _Nullable error);
#endif

/**
 KSHAuthorizationManager is an NSObject subclass that combines all the authorization methods into a consistent interface.
 */
@interface KSHAuthorizationManager : NSObject

/**
 Get the shared manager instance.
 */
@property (class,readonly,nonatomic) KSHAuthorizationManager *sharedManager;

#if (TARGET_OS_IPHONE)

#else
/**
 Get whether the user has authorized accessibility access.
 */
@property (readonly,nonatomic) BOOL hasAccessibilityAuthorization;
#endif

#if (TARGET_OS_IOS || TARGET_OS_OSX)


/**
 Get whether the user has authorized contacts access.
 */
@property (readonly,nonatomic) BOOL hasContactsAuthorization;
/**
 Get the contacts authorization status.
 
 @see KSHContactsAuthorizationStatus
 */
@property (readonly,nonatomic) KSHContactsAuthorizationStatus contactsAuthorizationStatus;
#endif

#if (TARGET_OS_IPHONE)

#else
/**
 Request accessibility authorization from the user and optionally display the system alert. If *openSystemPreferences* is YES and this method returns NO the Security & Privacy -> Privacy pane in System Preferences will be opened automatically.
 
 @param displaySystemAlert Whether to display the system accessibility alert
 @param openSystemPreferences Whether to open the appropriate system preferences pane if this method returns NO
 @return YES if the user has granted accessibility authorization, otherwise NO
 */
- (BOOL)requestAccessibilityAuthorizationDisplayingSystemAlert:(BOOL)displaySystemAlert openSystemPreferencesIfNecessary:(BOOL)openSystemPreferences;
#endif

#if (TARGET_OS_IOS || TARGET_OS_OSX)
/**
 Request contacts authorization from the user and invoke the provided completion block when authorization status has been determined. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSContactsUsageDescription or an exception will be thrown.
 
 @param completion The completion block to invoke when authorization status has been determined
 */
- (void)requestContactsAuthorizationWithCompletion:(KSHRequestContactsAuthorizationCompletionBlock)completion;
#endif

@end

NS_ASSUME_NONNULL_END
