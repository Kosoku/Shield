//
//  KSHVideoSubscriberAuthorization.h
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
#import <VideoSubscriberAccount/VSAccountManager.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Enum describing the possible values for video subscriber account authorization status. See VSAccountAccessStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSHVideoSubscriberAccountAuthorizationStatus) {
    /**
     See VSAccountAccessStatusNotDetermined for more information.
     */
    KSHVideoSubscriberAccountAuthorizationStatusNotDetermined = VSAccountAccessStatusNotDetermined,
    /**
     See VSAccountAccessStatusRestricted for more information.
     */
    KSHVideoSubscriberAccountAuthorizationStatusRestricted = VSAccountAccessStatusRestricted,
    /**
     See VSAccountAccessStatusDenied for more information.
     */
    KSHVideoSubscriberAccountAuthorizationStatusDenied = VSAccountAccessStatusDenied,
    /**
     See VSAccountAccessStatusGranted for more information.
     */
    KSHVideoSubscriberAccountAuthorizationStatusAuthorized = VSAccountAccessStatusGranted
};
/**
 Block that is invoked when video subscriber account authorization status has been determined.
 
 @param status The video subscriber account authorization status
 @param error The error
 */
typedef void(^KSHRequestVideoSubscriberAccountCompletionBlock)(KSHVideoSubscriberAccountAuthorizationStatus status, NSError * _Nullable error);

/**
 KSHVideoSubscriberAccountAuthorization wraps the APIs needed to request video subscriber account information from the user.
 */
@interface KSHVideoSubscriberAccountAuthorization : NSObject

/**
 Get the shared local authorization object.
 */
@property (class,readonly,nonatomic) KSHVideoSubscriberAccountAuthorization *sharedAuthorization;

/**
 Get whether the user has authorized video subscriber account access.
 */
@property (readonly,nonatomic) BOOL hasVideoSubscriberAccountAuthorization;
/**
 Get the current video subscriber account authorization status.
 */
@property (readonly,nonatomic) KSHVideoSubscriberAccountAuthorizationStatus videoSubscriberAccountAuthorizationStatus;

/**
 Request video subscriber account authorization from the user and invoke the *completion* block when the authorization status has been determined. The *completion* block is always invoked on the main thread. The client must provide a reason in their info plist using the NSVideoSubscriberAccountUsageDescription key or an exception will be thrown.
 
 @param completion The completion block to invoke when authorization status has been determined
 @exception NSException Thrown if *completion* is nil or the NSVideoSubscriberAccountUsageDescription key is missing from the info plist
 */
- (void)requestVideoSubscriberAccountAuthorizationWithCompletion:(KSHRequestVideoSubscriberAccountCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
