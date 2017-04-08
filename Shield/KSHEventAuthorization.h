//
//  KSHEventAuthorization.h
//  Shield
//
//  Created by William Towe on 4/8/17.
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
