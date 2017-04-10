//
//  KSHNotificationAuthorization.h
//  Shield
//
//  Created by William Towe on 4/10/17.
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
#import <UserNotifications/UNNotificationSettings.h>
#import <UserNotifications/UNUserNotificationCenter.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Enum describing the possible notification authorization status values. See UNAuthorizationStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSHNotificationAuthorizationStatus) {
    /**
     See UNAuthorizationStatusNotDetermined for more information.
     */
    KSHNotificationAuthorizationStatusNotDetermined = UNAuthorizationStatusNotDetermined,
    /**
     See UNAuthorizationStatusDenied for more information.
     */
    KSHNotificationAuthorizationStatusDenied = UNAuthorizationStatusDenied,
    /**
     See UNAuthorizationStatusAuthorized for more information.
     */
    KSHNotificationAuthorizationStatusAuthorized = UNAuthorizationStatusAuthorized
};
/**
 Block that is invoked when notification authorization status has been determined.
 
 @param status The notification authorization status
 @param error The error
 */
typedef void(^KSHRequestNotificationAuthorizationCompletionBlock)(KSHNotificationAuthorizationStatus status, NSError * _Nullable error);

/**
 Options mask describing the possible notification authorization options values. See UNAuthorizationOptions for more information.
 */
typedef NS_OPTIONS(NSUInteger, KSHNotificationAuthorizationOptions) {
    /**
     No options were authorized. Only relevant when inspecting current options using notificationAuthorizationOptions.
     */
    KSHNotificationAuthorizationOptionsNone = 0,
    /**
     See UNAuthorizationOptionBadge for more information.
     */
    KSHNotificationAuthorizationOptionsBadge = UNAuthorizationOptionBadge,
#if (TARGET_OS_IOS)
    /**
     See UNAuthorizationOptionSound for more information.
     */
    KSHNotificationAuthorizationOptionsSound = UNAuthorizationOptionSound,
    /**
     See UNAuthorizationOptionAlert for more information.
     */
    KSHNotificationAuthorizationOptionsAlert = UNAuthorizationOptionAlert,
    /**
     See UNAuthorizationOptionCarPlay for more information.
     */
    KSHNotificationAuthorizationOptionsCarPlay = UNAuthorizationOptionCarPlay
#endif
};

/**
 KSHNotificationAuthorization wraps the APIs needed to request notification authorization from the user.
 */
@interface KSHNotificationAuthorization : NSObject

/**
 Get the shared local authorization object.
 */
@property (class,readonly,nonatomic) KSHNotificationAuthorization *sharedAuthorization;

/**
 Get whether the user has authorized notifications.
 */
@property (readonly,nonatomic) BOOL hasNotificationAuthorization;
/**
 Get the current notification authorization status.
 */
@property (readonly,nonatomic) KSHNotificationAuthorizationStatus notificationAuthorizationStatus;
/**
 Get the current notification authorization options.
 */
@property (readonly,nonatomic) KSHNotificationAuthorizationOptions notificationAuthorizationOptions;

/**
 Request notification authorization from the user for the provided *options* and invoke the *completion* block when authorization status has been determined. The *completion* block is always invoked on the main thread.
 
 @param options The notification options to request
 @param completion The completion block to invoke when notification authorization status has been determined
 @exception NSException Thrown if *options* is KSHNotificationAuthorizationOptionsNone or *completion* is nil
 */
- (void)requestNotificationAuthorizationForOptions:(KSHNotificationAuthorizationOptions)options completion:(KSHRequestNotificationAuthorizationCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
