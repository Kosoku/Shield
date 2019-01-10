//
//  KSHEventAuthorization.h
//  Shield
//
//  Created by William Towe on 4/8/17.
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
#import <EventKit/EKTypes.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Enum defining the possible calendars authorization status values. See EKAuthorizationStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSHCalendarsAuthorizationStatus) {
    /**
     See EKAuthorizationStatusNotDetermined for more information.
     */
    KSHCalendarsAuthorizationStatusNotDetermined = EKAuthorizationStatusNotDetermined,
    /**
     See EKAuthorizationStatusRestricted for more information.
     */
    KSHCalendarsAuthorizationStatusRestricted = EKAuthorizationStatusRestricted,
    /**
     See EKAuthorizationStatusDenied for more information.
     */
    KSHCalendarsAuthorizationStatusDenied = EKAuthorizationStatusDenied,
    /**
     See EKAuthorizationStatusAuthorized for more information.
     */
    KSHCalendarsAuthorizationStatusAuthorized = EKAuthorizationStatusAuthorized
};
/**
 Completion block that is invoked after requesting calendars access.
 
 @param status The current calendars authorization status
 @param error The error
 */
typedef void(^KSHRequestCalendarsAuthorizationCompletionBlock)(KSHCalendarsAuthorizationStatus status, NSError * _Nullable error);

/**
 Enum defining the possible reminders authorization status values. See EKAuthorizationStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSHRemindersAuthorizationStatus) {
    /**
     See EKAuthorizationStatusNotDetermined for more information.
     */
    KSHRemindersAuthorizationStatusNotDetermined = EKAuthorizationStatusNotDetermined,
    /**
     See EKAuthorizationStatusRestricted for more information.
     */
    KSHRemindersAuthorizationStatusRestricted = EKAuthorizationStatusRestricted,
    /**
     See EKAuthorizationStatusDenied for more information.
     */
    KSHRemindersAuthorizationStatusDenied = EKAuthorizationStatusDenied,
    /**
     See EKAuthorizationStatusAuthorized for more information.
     */
    KSHRemindersAuthorizationStatusAuthorized = EKAuthorizationStatusAuthorized
};
/**
 Completion block that is invoked after requesting reminders access.
 
 @param status The current reminders authorization status
 @param error The error
 */
typedef void(^KSHRequestRemindersAuthorizationCompletionBlock)(KSHRemindersAuthorizationStatus status, NSError * _Nullable error);

/**
 KSHEventAuthorization wraps the APIs needed to request event access from the user.
 */
@interface KSHEventAuthorization : NSObject

/**
 Get the shared event authorization object.
 */
@property (class,readonly,nonatomic) KSHEventAuthorization *sharedAuthorization;

/**
 Get whether the user has authorized calendars access.
 */
@property (readonly,nonatomic) BOOL hasCalendarsAuthorization;
/**
 Get the calendars authorization status.
 
 @see KSHCalendarsAuthorizationStatus
 */
@property (readonly,nonatomic) KSHCalendarsAuthorizationStatus calendarsAuthorizationStatus;

/**
 Get whether the user has authorized reminders access.
 */
@property (readonly,nonatomic) BOOL hasRemindersAuthorization;
/**
 Get the reminders authorization status.
 
 @see KSHRemindersAuthorizationStatus
 */
@property (readonly,nonatomic) KSHRemindersAuthorizationStatus remindersAuthorizationStatus;

/**
 Request calendars authorization from the user and invoke the provided completion block when authorization status has been determined. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSCalendarsUsageDescription or an exception will be thrown.
 
 @param completion The completion block to invoke when authorization status has been determined
 */
- (void)requestCalendarsAuthorizationWithCompletion:(KSHRequestCalendarsAuthorizationCompletionBlock)completion;
/**
 Request reminders authorization from the user and invoke the provided completion block when authorization status has been determined. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSRemindersUsageDescription or an exception will be thrown.
 
 @param completion The completion block to invoke when authorization status has been determined
 */
- (void)requestRemindersAuthorizationWithCompletion:(KSHRequestRemindersAuthorizationCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
