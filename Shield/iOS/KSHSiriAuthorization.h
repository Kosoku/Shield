//
//  KSHSiriAuthorization.h
//  Shield
//
//  Created by William Towe on 4/8/17.
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
#import <Intents/INPreferences.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Enum defining the possible siri authorization status values. See INSiriAuthorizationStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSHSiriAuthorizationStatus) {
    /**
     See INSiriAuthorizationStatusNotDetermined for more information.
     */
    KSHSiriAuthorizationStatusNotDetermined = INSiriAuthorizationStatusNotDetermined,
    /**
     See INSiriAuthorizationStatusRestricted for more information.
     */
    KSHSiriAuthorizationStatusRestricted = INSiriAuthorizationStatusRestricted,
    /**
     See INSiriAuthorizationStatusDenied for more information.
     */
    KSHSiriAuthorizationStatusDenied = INSiriAuthorizationStatusDenied,
    /**
     See INSiriAuthorizationStatusAuthorized for more information.
     */
    KSHSiriAuthorizationStatusAuthorized = INSiriAuthorizationStatusAuthorized
};
/**
 Completion block that is invoked after requesting siri access.
 
 @param status The current siri authorization status
 @param error The error
 */
typedef void(^KSHRequestSiriAuthorizationCompletionBlock)(KSHSiriAuthorizationStatus status, NSError * _Nullable error);

/**
 KSHSiriAuthorization wraps the APIs needed to request Siri access from the user.
 */
@interface KSHSiriAuthorization : NSObject

/**
 Get the shared siri authorization object.
 */
@property (class,readonly,nonatomic) KSHSiriAuthorization *sharedAuthorization;

/**
 Get whether the user has authorized siri access.
 */
@property (readonly,nonatomic) BOOL hasSiriAuthorization;
/**
 Get the siri authorization status.
 
 @see KSHSiriAuthorizationStatus
 */
@property (readonly,nonatomic) KSHSiriAuthorizationStatus siriAuthorizationStatus;

/**
 Requst siri authorization from the user and invoke the provided completion block when authorization status has been determined. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSSiriUsageDescription or an exception will be thrown.
 
 @param completion The completion block to invoke when authorization status has been determined
 */
- (void)requestSiriAuthorizationWithCompletion:(KSHRequestSiriAuthorizationCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
