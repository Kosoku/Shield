//
//  KSHNotificationAuthorization.h
//  Shield
//
//  Created by William Towe on 4/10/17.
//  Copyright © 2021 Kosoku Interactive, LLC. All rights reserved.
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
